/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>
@class EmployeeRecord;
@class AttendanceModel;

/*
 *  Displays details about a single employee
 */
@interface EmployeeViewController : UIViewController

/*
 *  The employee record whose details are displayed on this screen
 */
@property (nonatomic, strong) EmployeeRecord *employeeRecord;

/*
 *  The model where this employee record came from
 */
@property (nonatomic, strong) AttendanceModel *myModel;

@end
