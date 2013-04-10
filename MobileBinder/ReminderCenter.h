
#import <Foundation/Foundation.h>
@class Reminder;

@interface ReminderCenter : NSObject

+ (ReminderCenter *) getInstance;

- (void) addReminders:(NSArray *)reminders cancelRemindersWithTypeIDs: (NSArray *) typeIDArray completion:(void (^)(void))block;

- (void) addReminders: (NSArray *) reminders completion: (void (^) (void)) block;

//TypeIDArray is an array of NSNumbers of the typeIDs that you wish to cancel
- (void) cancelRemindersWithTypeIDs: (NSArray *) typeIDArray completion: (void (^)(void)) block;

/* 
 * This method makes NO adjustments to the time of begin and end
 * The results are INCLUSIVE of the begin date and EXCLUSIVE of the end date 
 */
- (NSArray *) getRemindersBetween: (NSDate *) begin andEndDate: (NSDate *) end;

- (void) reset;

//Call this when the app becomes active in order to ensure that the proper UILocalNotifications are scheduled
- (void) refreshReminders;
@end
