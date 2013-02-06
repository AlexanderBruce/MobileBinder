#import "Reminder.h"
#import "ReminderManagedObject.h"

@interface Reminder()
@property (nonatomic, strong, readwrite) NSString *text;
@property (nonatomic, strong, readwrite) NSDate *eventDate;
@property (nonatomic, strong, readwrite) NSDate *fireDate;
@property (nonatomic, readwrite) int typeID;
@end

@implementation Reminder

- (id) initWithText:(NSString *)text eventDate:(NSDate *)eventDate fireDate:(NSDate *)fireDate typeID:(int)typeID
{
    if(self = [super init])
    {
        self.text = text;
        self.eventDate = eventDate;
        self.fireDate = fireDate;
        self.typeID = typeID;
    }
    return self;
}

- (id) initWithManagedObject:(ReminderManagedObject *)managedObject
{
    if(self = [super init])
    {
        self.text = managedObject.text;
        self.eventDate = managedObject.eventDate;
        self.fireDate = managedObject.fireDate;
        self.typeID = managedObject.typeID;
    }
    return self;
}

@end
