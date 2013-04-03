#import "ReminderCenter.h"
#import "Reminder.h"
#import "Database.h"
#import "ReminderManagedObject.h"

#define TYPE_ID_KEY @"TypeID"

@interface ReminderCenter()
@property (nonatomic, strong) UIManagedDocument *database;
@end

@implementation ReminderCenter
static ReminderCenter *instance;


+ (ReminderCenter *) getInstance
{
    if(!instance)
    {
        instance = [[ReminderCenter alloc] init];
    }
    return instance;
}

- (void) addReminders: (NSArray *) reminders completion: (void (^) (void)) block
{
    if(!reminders || reminders.count == 0)
    {
        block();
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (Reminder *reminder in reminders)
        {
            ReminderManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass([ReminderManagedObject class]) inManagedObjectContext:self.database.managedObjectContext];
            managedObject.text = reminder.text;
            managedObject.eventDate = reminder.eventDate;
            managedObject.fireDate = reminder.fireDate;
            managedObject.typeID = [NSNumber numberWithInt:reminder.typeID];
            
            UILocalNotification *notif = [[UILocalNotification alloc] init];
            //ALEX BRUCE LOOK AT FIRE DATE HERE
            notif.fireDate = reminder.fireDate;
            notif.timeZone = [NSTimeZone defaultTimeZone];
            notif.alertBody = reminder.text;
            notif.hasAction = NO;
            notif.soundName = UILocalNotificationDefaultSoundName;
            notif.applicationIconBadgeNumber = 1;
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [dictionary setObject:[NSNumber numberWithInt:reminder.typeID] forKey:TYPE_ID_KEY];
            notif.userInfo = dictionary;
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        }
        [self synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    });
}

- (void) cancelRemindersWithTypeIDs: (NSArray *) typeIDArray completion: (void (^)(void)) block
{
    if(!typeIDArray || typeIDArray.count == 0)
    {
        block();
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Remove notifications
        NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        NSMutableArray *notifsToRemove = [[NSMutableArray alloc] init];
        for (UILocalNotification *currentNotif in notifications)
        {
            NSNumber *currentNotifTypeID = [currentNotif.userInfo objectForKey:TYPE_ID_KEY];
            for (NSNumber *typeIDToRemove in typeIDArray)
            {
                if([currentNotifTypeID integerValue] == [typeIDToRemove integerValue])
                {
                    [notifsToRemove addObject:currentNotif];
                    break;
                }
            }
        }
        for(UILocalNotification *currentNotif in notifsToRemove)
        {
            [[UIApplication sharedApplication] cancelLocalNotification:currentNotif];
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
        [self synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
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

- (void) synchronize
{
    [Database saveDatabase];
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
