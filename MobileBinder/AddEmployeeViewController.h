/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <UIKit/UIKit.h>
#import "BackgroundViewController.h"
@class AttendanceModel;
@class EmployeeRecord;

/*
 *  Will get called when the user is done using the AddEmployeeViewController
 */
@protocol AddEmployeeDelegate <NSObject>
@optional

/*
 *  The user decided not to add a new employee or not to edit a pre-existing employee
 */
- (void) canceledAddEmployeeViewController;

/*
 *  The user has finished entering all of the information needed for a new employee record
 *  and that information has been successfully validated
 */
- (void) addedNewEmployeeRecord: (EmployeeRecord *) record;

/*
 *  The user has finished editing an employee record and the database has been saved
 */
- (void) editedEmployeedRecord;
@end

/*
 *  Allows the user to add a new employee record to the database
 */
@interface AddEmployeeViewController : BackgroundViewController

/*
 *  The delegate that will get called once a user finishes using this view controller
 */
@property (nonatomic, weak) id<AddEmployeeDelegate> delegate;

/*
 *  The record that is being edited on this screen.  If this view controller is being used
 *  to add a new employee, this property is nil
 */
@property (nonatomic, strong) EmployeeRecord *myRecord;

/*
 *  The model where the new employee record will be saved,
 *  or in the case of editing, where the employee record is already saved
 */
@property (nonatomic, strong) AttendanceModel *myModel;
@end
