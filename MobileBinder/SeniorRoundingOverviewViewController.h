/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <UIKit/UIKit.h>
#import "BackgroundViewController.h"
#import "RoundingOverviewViewController.h"
#import "SeniorRoundingLog.h"
#import "RoundingLog.h"

/*
 *   Displays "overview" information about a single senior rounding log
 */
@interface SeniorRoundingOverviewViewController : RoundingOverviewViewController
@property (nonatomic, strong) SeniorRoundingLog *log;
@end
