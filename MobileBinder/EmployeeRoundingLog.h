/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "RoundingLog.h"

/*
 *  Represents one employee rounding log
 */
@interface EmployeeRoundingLog : RoundingLog

/*
 *  Overview information
 */
@property (nonatomic, strong) NSString *employeeName;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *leader;
@property (nonatomic, strong) NSString *keyFocus;
@property (nonatomic, strong) NSString *keyReminders;

@end
