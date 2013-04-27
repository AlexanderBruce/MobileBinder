/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RoundingLogManagedObjectProtocol.h"

/*
 *  The CoreData object that backs an EmployeeRoundingLog
 */
@interface EmployeeRoundingLogManagedObject : NSManagedObject <RoundingLogManagedObjectProtocol>

@property (nonatomic, retain) NSString * employeeName;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSString * leader;
@property (nonatomic, retain) NSString * keyFocus;
@property (nonatomic, retain) NSString * keyReminders;
@property (nonatomic, retain) id contents;

@end
