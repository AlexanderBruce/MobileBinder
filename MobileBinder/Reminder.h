#import <Foundation/Foundation.h>
@class ReminderManagedObject;

@interface Reminder : NSObject
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSDate *fireDate;
@property (nonatomic, readonly) int typeID;
@property (nonatomic, readonly) BOOL isInPast;

- (id) initWithText: (NSString *) text fireDate: (NSDate *) fireDate typeID: (int) typeID;

- (id) initWithManagedObject: (ReminderManagedObject *) managedObject;
@end
