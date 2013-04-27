/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <UIKit/UIKit.h>
#import "BackgroundViewController.h"
@class EmployeeRecord;

/*
 *  Used to add a new incident (absence, tardy...etc) to an employee record
 */
@interface IncidentViewController : BackgroundViewController

/*
 *  The employee to add an incident to
 */
@property (nonatomic, strong) EmployeeRecord *employeeRecord;

@end
