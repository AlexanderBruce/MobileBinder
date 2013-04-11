
#import <Foundation/Foundation.h>
@class Reminder;

@interface ReminderCenter : NSObject

+ (ReminderCenter *) getInstance;

//This is asynchronous and there are no guarantees on what thread/queue your block parameter will be run
- (void) addReminders:(NSArray *)reminders cancelRemindersWithTypeIDs: (NSArray *) typeIDArray completion:(void (^)(void))block;

- (void) getRemindersBetween:(NSDate *)begin andEndDate:(NSDate *)end withCompletion: (void (^) (NSArray *)) block;

//This is asynchronous and there are no guarantees on what thread/queue your block parameter will be run
- (void) resetWithCompletition: (void (^)(void)) block;

//Call this when the app becomes active in order to ensure that the proper UILocalNotifications are scheduled
- (void) refreshReminders;
@end
