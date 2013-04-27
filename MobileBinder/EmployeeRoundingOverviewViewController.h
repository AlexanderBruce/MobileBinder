/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <UIKit/UIKit.h>
#import "RoundingOverviewViewController.h"
#import "RoundingLog.h"
#import "EmployeeRoundingLog.h"
@class RoundingModel;


/*
 *  Displays the "overview" information about one employee rounding log
 */
@interface EmployeeRoundingOverviewViewController : RoundingOverviewViewController

@property (nonatomic, strong) EmployeeRoundingLog *log; /* The log whose information is displayed */
@property (nonatomic, strong) RoundingModel *model;

@end
