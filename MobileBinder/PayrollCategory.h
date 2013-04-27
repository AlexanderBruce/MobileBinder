/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>

/*
 *  A grouping of payroll dates associated with a specific event.  
 *  For example, all biweekly pay period beginning dates
 */
@interface PayrollCategory : NSObject

/*
 *  The name of this category (e.g. Pay Day)
 */
@property (nonatomic, strong) NSString *name;

/*
 *  A predefined number (see Constants.h) that specifies exactly what category this is.
 *  This is necessary because there may be two PayrollCategory instances with the same name
 *  (e.g. Pay Dates for both biweekly and monthly employees)
 */
@property (nonatomic) int typeID;

/*
 *  If the dates in this category are converted into UILocalNotifications, what time should these notifications fire at
 */
@property (nonatomic, strong) NSDate *fireTime;

/*
 *  Add a date to this category for a specific period (e.g. January)
 *  Currently, there can only be one date per period
 */
- (void) addDate: (NSDate *) date forPeriod: (NSString *) period;

/*
 *  Returns the date (or null) for this period.
 *  Currently, there can only be onde date per period
 */
- (NSDate *) dateForPeriod: (NSString *) period;

/*
 *  Returns an array of all of the dates for this category (sorted by soonest (or furthest in past) date to farthest away date)
 */
- (NSArray *) getDates;

/*
 *  Set the text the will be displayed if these dates get scheduled as UILocalNotifications
 */
- (void) setNotificationText: (NSString *) notificationText;

/*
 *  Returns the text that will be displayed on associated UILocalNotifications
 */
- (NSString *) getNotificationText;

@end
