/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>
@class Reminder;

/*
 *  Schedules and cancels reminders and converts them into UILocalNotifications
 *  Note, this class's functionality has NOT been extensively tested
 */
@interface ReminderCenter : NSObject

/*
 *  Returns the singleton instance.  No additional steps are needed in order to setup the reminder center
 */
+ (ReminderCenter *) getInstance;

/*
 *  Schedules a series of UILocalNotifications based on an array of reminders.  Similarly, cancels a series of UILocalNotifications
 *  that have one of a series of type IDs.
 *  This is asynchronous and there are no guarantees on what thread/queue your completition block parameter will be run
 *  Design Note: Add and cancel functionality was combined into one method in order to improve performance
 */
- (void) addReminders:(NSArray *)reminders cancelRemindersWithTypeIDs: (NSArray *) typeIDArray completion:(void (^)(void))block;

/*
 *  Asynchronously retrieves all Reminder objects that have a fireDate between two given dates.  
 *  The array of retrieved Reminders is passed as a parameter into the completion block
 */
- (void) getRemindersBetween:(NSDate *)begin andEndDate:(NSDate *)end withCompletion: (void (^) (NSArray *)) block;

/*
 *  Asynchronously erases all Reminders from the system and cancels all UILocalNotifications
 *  There are no guarantees on what thread/queue your block parameter will be run
 */
- (void) resetWithCompletition: (void (^)(void)) block;

/*
 *  iOS limits the number of scheduled UILocalNotifications to 64, thus calling this method when the app becomes active,
 *  ensures that as many UILocalNotifications as possible are scheduled.
 *  Note, this method is automatically called in the process of adding and canceling reminders
 */
- (void) refreshReminders;

/*
 *  Call this method to ensure that the correct badge number appears when UILocalNotifications are recieved
 *  Note, refreshReminders also does this, but is more computationally intensive (it does other things as well)
 */
- (void) refreshNotificationBadgeNumbers;
@end
