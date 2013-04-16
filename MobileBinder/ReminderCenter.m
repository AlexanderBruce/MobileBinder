#import "ReminderCenter.h"
#import "Reminder.h"
#import "BetterDatabase.h"
#import "ReminderManagedObject.h"

#define TYPE_ID_KEY @"TypeID"
#define UNIQUE_ID_KEY @"UniqueIDKey"
#define WARNING_NOTIF_UNIQUE_ID (INT_MIN)
#define WARNING_NOTIF_TYPE_ID (INT_MAX - 1)
#define MAX_NUM_OF_SCHEDULED_REMINDERS 64

@interface ReminderCenter()
@end

@implementation ReminderCenter
static ReminderCenter *instance;

+ (ReminderCenter *) getInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void) addReminders:(NSArray *) remindersToAdd cancelRemindersWithTypeIDs: (NSArray *) typeIDArray completion:(void (^)(void))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[BetterDatabase sharedDocumentHandler] lock];
        [[BetterDatabase sharedDocumentHandler] performWithDocument:^(UIManagedDocument * document) {
            [self cancelRemindersWithTypeIDs:typeIDArray usingDatabase:document];
            [self addReminders:remindersToAdd toDatabase:document];
            [[BetterDatabase sharedDocumentHandler] save:document withCompletion:^{
                [self refreshRemindersPrivatelyWithDatabase:document];
                [[BetterDatabase sharedDocumentHandler] save:document withCompletion:^{
                    [[BetterDatabase sharedDocumentHandler] unlock];
                    block();
                }];
            }];
        }];
    });
}

- (void) addReminders: (NSArray *) reminders toDatabase: (UIManagedDocument *) document
{
    for (Reminder *reminder in reminders)
    {
        if(reminder.isInPast) continue;

        ReminderManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass([ReminderManagedObject class]) inManagedObjectContext:document.managedObjectContext];
        managedObject.text = reminder.text;
        managedObject.fireDate = reminder.fireDate;
        managedObject.typeID = [NSNumber numberWithInt:reminder.typeID];
        managedObject.uniqueID = [NSNumber numberWithInt:reminder.uniqueID];
    }
}

- (void) refreshReminders
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[BetterDatabase sharedDocumentHandler] lock];
        [[BetterDatabase sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
            [self refreshRemindersPrivatelyWithDatabase:document];
            [[BetterDatabase sharedDocumentHandler] save:document withCompletion:^{
                [[BetterDatabase sharedDocumentHandler] unlock];
            }];
        }];
    });
}

- (void) refreshRemindersPrivatelyWithDatabase: (UIManagedDocument *) document
{
    NSMutableDictionary *alreadyScheduledNotifUniqueIds = [[NSMutableDictionary alloc] init]; //Unique id to scheduled notif
    
    //Find already scheduled unique ID notifs
    NSArray *notifs = [UIApplication sharedApplication].scheduledLocalNotifications;
    for(UILocalNotification *currentNotif in notifs)
    {
        int uniqueID = [currentNotif.userInfo objectForKey:UNIQUE_ID_KEY];
        [alreadyScheduledNotifUniqueIds setObject:currentNotif forKey:[NSNumber numberWithInt:uniqueID]];
    }
    
    //Fetch all reminders (scheduled and unscheduled)
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([ReminderManagedObject class]) inManagedObjectContext:document.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fireDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray *retrievedReminders = [document.managedObjectContext executeFetchRequest: fetchRequest error: nil];
    
    NSMutableArray *notifsToSchedule = [[NSMutableArray alloc] init];
    for(ReminderManagedObject *managedObj in retrievedReminders)
    {
        if([managedObj.fireDate compare:[NSDate date]] == NSOrderedAscending)
        {
            [document.managedObjectContext deleteObject:managedObj];
        }
        else if(notifsToSchedule.count == MAX_NUM_OF_SCHEDULED_REMINDERS - 1) break;
        else
        {
            UILocalNotification *oldNotif = [alreadyScheduledNotifUniqueIds objectForKey:[NSNumber numberWithInt:managedObj.uniqueID]];
            if(oldNotif) [notifsToSchedule addObject:oldNotif];
            else [notifsToSchedule addObject:[self createNotifFromManagedObj:managedObj]];
        }
    }
    if(notifsToSchedule.count == MAX_NUM_OF_SCHEDULED_REMINDERS - 1)
    {
        NSDate *lastScheduledFireDate = [[notifsToSchedule lastObject] fireDate];
        [notifsToSchedule addObject:[self createWarningNotifWithFireDate:lastScheduledFireDate]];
    }
    if(notifsToSchedule.count > 0) //Saftey check to make sure we don't overwrite with zero notifs
    {
        [UIApplication sharedApplication].scheduledLocalNotifications = notifsToSchedule;
    }
}

- (UILocalNotification *) createNotifFromManagedObj: (ReminderManagedObject *) managedObj
{
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    notif.fireDate = managedObj.fireDate;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    notif.alertBody = managedObj.text;
    notif.hasAction = YES;
    notif.applicationIconBadgeNumber = 1;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSNumber numberWithInt:managedObj.typeID] forKey:TYPE_ID_KEY];
    [dictionary setObject:[NSNumber numberWithInt:managedObj.uniqueID] forKey:UNIQUE_ID_KEY];
    notif.userInfo = dictionary;
    return notif;
}

- (UILocalNotification *) createWarningNotifWithFireDate: (NSDate *) fireDate
{
    UILocalNotification *notif = [[UILocalNotification alloc] init];

    notif.fireDate = fireDate;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [info objectForKey:@"CFBundleDisplayName"];
    
    notif.alertBody = [NSString stringWithFormat:@"You have not visited %@ recently; therefore, you will stop recieving notifications.  Open the app to re-enable notifications.",appName];
    notif.hasAction = YES;
    notif.applicationIconBadgeNumber = 1;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSNumber numberWithInt:WARNING_NOTIF_TYPE_ID] forKey:TYPE_ID_KEY];
    [dictionary setObject:[NSNumber numberWithInt:WARNING_NOTIF_UNIQUE_ID] forKey:UNIQUE_ID_KEY];
    notif.userInfo = dictionary;
    return notif;
}

- (void) cancelRemindersWithTypeIDs: (NSArray *) typeIDArray usingDatabase: (UIManagedDocument *) document
{
    //Remove notifications
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *currentNotif in notifications)
    {
        NSNumber *currentNotifTypeID = [currentNotif.userInfo objectForKey:TYPE_ID_KEY];
        for (NSNumber *typeIDToRemove in typeIDArray)
        {
            if([currentNotifTypeID integerValue] == [typeIDToRemove integerValue])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:currentNotif];
                break;
            }
        }
    }
    
    //Remove reminders
    NSMutableArray *objectsToDelete = [[NSMutableArray alloc] init];
    for (NSNumber *typeID in typeIDArray)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest new];
        fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([ReminderManagedObject class]) inManagedObjectContext:document.managedObjectContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"typeID = %d", [typeID intValue]];
        [fetchRequest setPredicate:predicate];
        [objectsToDelete addObjectsFromArray:[document.managedObjectContext executeFetchRequest: fetchRequest error: nil] ];
    }
    for (NSManagedObject *managedObject in objectsToDelete)
    {
        [document.managedObjectContext deleteObject:managedObject];
    }
}

- (void) getRemindersBetween:(NSDate *)begin andEndDate:(NSDate *)end withCompletion:(void (^)(NSArray *))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[BetterDatabase sharedDocumentHandler] lock];
        [[BetterDatabase sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            NSArray *result = [self getRemindersBetween:begin andEndDate:end fromDatabase:document];
            [[BetterDatabase sharedDocumentHandler] unlock];
            dispatch_async(dispatch_get_main_queue(),^{
                block(result);
            });
        }];
    });
}

- (NSArray *) getRemindersBetween: (NSDate *) begin andEndDate: (NSDate *) end fromDatabase: (UIManagedDocument *) document
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([ReminderManagedObject class]) inManagedObjectContext:document.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fireDate >= %@) AND (fireDate < %@)", begin, end];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fireDate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *managedObjects = [document.managedObjectContext executeFetchRequest: fetchRequest error: nil];
    NSMutableArray *remindersToReturn = [[NSMutableArray alloc] init];
    for (ReminderManagedObject *currentManagedObject in managedObjects)
    {
        [remindersToReturn addObject:[[Reminder alloc] initWithManagedObject:currentManagedObject]];
    }
    return remindersToReturn;
}

- (void) resetWithCompletition: (void (^)(void)) block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[BetterDatabase sharedDocumentHandler] lock];
        [[BetterDatabase sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document)
         {
             [[UIApplication sharedApplication] cancelAllLocalNotifications];
             
             NSMutableArray *objectsToDelete = [[NSMutableArray alloc] init];
             NSFetchRequest *fetchRequest = [NSFetchRequest new];
             fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([ReminderManagedObject class]) inManagedObjectContext:document.managedObjectContext];
             [objectsToDelete addObjectsFromArray:[document.managedObjectContext executeFetchRequest: fetchRequest error: nil]];
             
             for (NSManagedObject *managedObject in objectsToDelete)
             {
                 [document.managedObjectContext deleteObject:managedObject];
             }
             [[BetterDatabase sharedDocumentHandler] save:document withCompletion:^{
                 [[BetterDatabase sharedDocumentHandler] unlock];
                 block();
             }];
         }];
    });
    
}


@end
