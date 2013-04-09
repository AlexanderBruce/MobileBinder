#import "Reminder.h"
#import "ReminderManagedObject.h"

@interface Reminder()
@property (nonatomic, strong, readwrite) NSString *text;
@property (nonatomic, strong, readwrite) NSDate *fireDate;
@property (nonatomic, readwrite) int typeID;
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
//        NSLog(@"Fire date = %@",self.fireDate);
        self.typeID = typeID;
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
    }
    return self;
}

@end
