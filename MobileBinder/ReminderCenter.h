#import <Foundation/Foundation.h>
@class Reminder;

@interface ReminderCenter : NSObject

+ (ReminderCenter *) getInstance;

- (void) addReminder: (Reminder *) reminder;

- (void) cancelRemindersWithTypeID: (int) typeID;

- (NSArray *) getRemindersBetween: (NSDate *) begin andEndDate: (NSDate *) end;

- (void) synchronize;

@end
