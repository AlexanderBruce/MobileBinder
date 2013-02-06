#import <Foundation/Foundation.h>
@class Reminder;

@interface ReminderCenter : NSObject

+ (ReminderCenter *) getInstance;

- (void) addReminders: (NSArray *) reminders completion: (void (^) (void)) block;

//TypeIDArray is an array of NSNumbers of the typeIDs that you wish to cancel
- (void) cancelRemindersWithTypeIDs: (NSArray *) typeIDArray completion: (void (^)(void)) block;

- (NSArray *) getRemindersBetween: (NSDate *) begin andEndDate: (NSDate *) end;

@end
