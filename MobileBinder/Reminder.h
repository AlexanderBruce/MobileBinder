#import <Foundation/Foundation.h>
@class ReminderManagedObject;

@interface Reminder : NSObject
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSDate *eventDate;
@property (nonatomic, strong, readonly) NSDate *fireDate;
@property (nonatomic, readonly) int typeID;


- (id) initWithText: (NSString *) text eventDate: (NSDate *) eventDate fireDate: (NSDate *) fireDate typeID: (int) typeID;

- (id) initWithManagedObject: (ReminderManagedObject *) managedObject;
@end