/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <CoreData/CoreData.h>
#import "RoundingLogManagedObjectProtocol.h"

/*
 *  The CoreData object that backs a SeniorRoundingLog
 */
@interface SeniorRoundingLogManagedObject : NSManagedObject <RoundingLogManagedObjectProtocol>

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) id contents;

@end
