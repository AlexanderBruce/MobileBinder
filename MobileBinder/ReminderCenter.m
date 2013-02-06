#import "ReminderCenter.h"
#import "Reminder.h"
#import "Database.h"
#import "ReminderManagedObject.h"

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

- (void) addReminder: (Reminder *) reminder
{
    ReminderManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass([ReminderManagedObject class]) inManagedObjectContext:self.database.managedObjectContext];
    managedObject.text = reminder.text;
    managedObject.eventDate = reminder.eventDate;
    managedObject.fireDate = reminder.fireDate;
    managedObject.typeID = [NSNumber numberWithInt:reminder.typeID];
}

- (void) cancelRemindersWithTypeID: (int) typeID
{
    
}

- (NSArray *) getRemindersBetween: (NSDate *) begin andEndDate: (NSDate *) end
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([ReminderManagedObject class]) inManagedObjectContext:self.database.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fireDate >= %@) AND (fireDate <= %@)", begin, end];
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

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
    	return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
    	return NO;
    
    return YES;
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
