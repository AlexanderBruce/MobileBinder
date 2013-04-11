#import "Reminder.h"
#import "ReminderManagedObject.h"

#define CURRENT_UNUSED_UNIQUE_ID_KEY @"reminderCurrentUnusedUniqueIdKey"
@interface Reminder()
@property (nonatomic, strong, readwrite) NSString *text;
@property (nonatomic, strong, readwrite) NSDate *fireDate;
@property (nonatomic, readwrite) int typeID;
@property (nonatomic, readwrite) int uniqueID;
@end

@implementation Reminder

- (BOOL) isInPast
{
    return ([self.fireDate timeIntervalSinceNow] < 0.0);
}

- (id) initWithText:(NSString *)text fireDate:(NSDate *)fireDate typeID:(int)typeID
{
    if(self = [super init])
    {
        self.text = text;
        self.fireDate = fireDate;
        self.typeID = typeID;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.uniqueID = [defaults integerForKey:CURRENT_UNUSED_UNIQUE_ID_KEY];
        [defaults setInteger:self.uniqueID + 1 forKey:CURRENT_UNUSED_UNIQUE_ID_KEY];
        [defaults synchronize];
    }
    return self;
}

- (id) initWithManagedObject:(ReminderManagedObject *)managedObject
{
    if(self = [super init])
    {
        self.text = managedObject.text;
        self.fireDate = managedObject.fireDate;
        self.typeID = managedObject.typeID;
        self.uniqueID = [managedObject.uniqueID intValue];
    }
    return self;
}

@end
