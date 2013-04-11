#import "ReminderCenter.h"
#import "Reminder.h"
#import "Database.h"
#import "ReminderManagedObject.h"

#define TYPE_ID_KEY @"TypeID"
#define UNIQUE_ID_KEY @"UniqueIDKey"
#define WARNING_NOTIF_UNIQUE_ID (INT_MIN)
#define WARNING_NOTIF_TYPE_ID (INT_MAX - 1)
#define MAX_NUM_OF_SCHEDULED_REMINDERS 64

@interface ReminderCenter()
@property (nonatomic, strong) UIManagedDocument *database;
@end

@implementation ReminderCenter
static ReminderCenter *instance;
static NSLock *lock;

+ (void) initialize
{
    lock = [[NSLock alloc] init];
}


+ (ReminderCenter *) getInstance
{
    if(!instance)
    {
        instance = [[ReminderCenter alloc] init];
    }
    return instance;
}



//Public method
- (void) addReminders:(NSArray *)reminders completion:(void (^)(void))block
{
    if(!reminders || reminders.count == 0)
    {
        block();
        return;
    }
    
    [lock lock];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self addRemindersToDatabase:reminders];
        [self synchronizeWithCompletion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [lock unlock];
                block();
            });
            [self refreshReminders];
        }];
    });
}

//Private method
- (void) addRemindersToDatabase: (NSArray *) reminders
{
    for (Reminder *reminder in reminders)
    {
        if(reminder.isInPast) continue;

        ReminderManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass([ReminderManagedObject class]) inManagedObjectContext:self.database.managedObjectContext];
        managedObject.text = reminder.text;
        managedObject.fireDate = reminder.fireDate;
        managedObject.typeID = [NSNumber numberWithInt:reminder.typeID];
        managedObject.uniqueID = [NSNumber numberWithInt:reminder.uniqueID];
    }
}

- (void) refreshReminders
{
    [lock lock];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
        fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([ReminderManagedObject class]) inManagedObjectContext:self.database.managedObjectContext];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fireDate" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSArray *retrievedReminders = [self.database.managedObjectContext executeFetchRequest: fetchRequest error: nil];
        
        NSMutableArray *notifsToSchedule = [[NSMutableArray alloc] init];
        for(ReminderManagedObject *managedObj in retrievedReminders)
        {
            if([managedObj.fireDate compare:[NSDate date]] == NSOrderedAscending)
            {
                [self.database.managedObjectContext deleteObject:managedObj];
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
        [UIApplication sharedApplication].scheduledLocalNotifications = notifsToSchedule;
        
        [self synchronizeWithCompletion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [lock unlock];
            });
        }];
    });

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

- (void) cancelRemindersWithTypeIDs: (NSArray *) typeIDArray completion: (void (^)(void)) block
{
    if(!typeIDArray || typeIDArray.count == 0)
    {
        block();
        return;
    }
    
    [lock lock];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
            fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([ReminderManagedObject class]) inManagedObjectContext:self.database.managedObjectContext];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"typeID = %d", [typeID intValue]];
            [fetchRequest setPredicate:predicate];
            [objectsToDelete addObjectsFromArray:[self.database.managedObjectContext executeFetchRequest: fetchRequest error: nil] ];
        }
        for (NSManagedObject *managedObject in objectsToDelete)
        {
            [self.database.managedObjectContext deleteObject:managedObject];
        }
        
        [self synchronizeWithCompletion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [lock unlock];
                block();
            });
            [self refreshReminders];
        }];
    });
}

- (NSArray *) getRemindersBetween: (NSDate *) begin andEndDate: (NSDate *) end
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([ReminderManagedObject class]) inManagedObjectContext:self.database.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fireDate >= %@) AND (fireDate < %@)", begin, end];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fireDate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *managedObjects = [self.database.managedObjectContext executeFetchRequest: fetchRequest error: nil];
    NSMutableArray *remindersToReturn = [[NSMutableArray alloc] init];
    for (ReminderManagedObject *currentManagedObject in managedObjects)
    {
        [remindersToReturn addObject:[[Reminder alloc] initWithManagedObject:currentManagedObject]];
    }
    return remindersToReturn;
}

- (void) reset
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSMutableArray *objectsToDelete = [[NSMutableArray alloc] init];
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([ReminderManagedObject class]) inManagedObjectContext:self.database.managedObjectContext];
    [objectsToDelete addObjectsFromArray:[self.database.managedObjectContext executeFetchRequest: fetchRequest error: nil]];
    
    for (NSManagedObject *managedObject in objectsToDelete)
    {
        [self.database.managedObjectContext deleteObject:managedObject];
    }
    
    [self synchronizeWithCompletion:^{}];
}

- (void) synchronizeWithCompletion: (void (^) (void)) block
{
    [Database saveDatabaseWithCompletion:block];
}

- (id) init
{
    if(self = [super init])
    {
        self.database = [Database getInstance];
    }
    return self;
}

@end
