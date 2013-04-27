/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>

@protocol PayrollModelDelegate <NSObject>

- (void) doneInitializingPayrollModel;

@end

/*
 *  Use to specify what type of information is returned when calling methods on PayRollModel instances
 */
typedef enum Mode {
    BiweeklyMode = 0,
    MonthlyMode = 1
} Mode;

/*
 *  Used to obtain, process and return information regarding payroll data
 */
@interface PayrollModel : NSObject

/*
 *  A silly enum that specifies what type of information that should be returned when calling the methods below
 */
@property (nonatomic) Mode mode;

/*
 *  Add all reminders of a specific type ID and cancel all reminders of another type ID to ReminderCenter.
 *  ReminderCenter will ensure that UILocalNotifications are scheduled/unscheduled for these type IDs
 *  Note that the completition block is guaranteed to run on the main thread
 *  Design Note: Add and cancel functionality was combined into one method in order to improve performance
 */ 
- (void) addRemindersForTypeIDs: (NSArray *) toAdd andCancelRemindersForTypeIDs: (NSArray *) toCancel completion: (void (^) (void)) block;

/*
 *  Returns the periods that are associated with the set mode
 *  This method will return undefined information if called before the PayrollModelDelegate method is called
 */ 
- (NSArray *) getPeriods;

/*
 *  Returns the categories that are associated with the set mode
 *  This method will return undefined information if called before the PayrollModelDelegate method is called
 */
- (NSArray *) getCategories;

/*
 *  Returns the date for a specific category num in a given period
 *  This method will return undefined information if called before the PayrollModelDelegate method is called
 */
- (NSDate *) getDateForCategoryNum: (int) categoryNum period: (NSString *) period;

/*
 *  The constructor for this object will obtain payroll data and then call the delegate method
 *  This constructor should be used rather than normal init
 */
- (void) initializeModelWithDelegate: (id<PayrollModelDelegate>) delegate;

@end
