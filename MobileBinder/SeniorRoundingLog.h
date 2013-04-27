/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "RoundingLog.h"

/*
 *  Represents a single senior rounding log
 */
@interface SeniorRoundingLog : RoundingLog

/*
 *  Overview information
 */
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *notes;
@end
