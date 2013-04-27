/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>
@class ReminderManagedObject;

/*
 *  Similar to iOS's UILocalNotifications, except this is used internally within the app
 *  ReminderCenter can be used to schedule reminders as UILocalNotifications
 */
@interface Reminder : NSObject

/*
 *  The reminder's text that will be displayed if scheduled as a UILocalNotification
 */
@property (nonatomic, strong, readonly) NSString *text;

/*
 *  The date that the associated UILocalNotification should fire (if scheduled using ReminderCenter)
 */  
@property (nonatomic, strong, readonly) NSDate *fireDate;

/*
 *  An arbitrary number that is used for identifying this Reminder (so that it can be canceled by ReminderCenter later)
 *  See Constants.h for more information
 */
@property (nonatomic, readonly) int typeID;

/*
 *  Returns if the fireDate for this reminder has already passed
 */
@property (nonatomic, readonly) BOOL isInPast;

/*
 *  A unique ID that may be used by ReminderCenter
 */
@property (nonatomic, readonly) int uniqueID;

/*
 *  A convience constructor
 */
- (id) initWithText: (NSString *) text fireDate: (NSDate *) fireDate typeID: (int) typeID;

/*
 *  A constructor that intializes the property values of this object based on the property values of an associated managed object
 */
- (id) initWithManagedObject: (ReminderManagedObject *) managedObject;
@end
