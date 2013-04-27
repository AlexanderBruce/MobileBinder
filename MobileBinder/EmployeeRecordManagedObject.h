/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


/*
 *  The underlying CoreData object of an EmployeeRecord
 */
@interface EmployeeRecordManagedObject : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSString *idNum;
@property (nonatomic, copy) id absences;
@property (nonatomic, copy) id tardies;
@property (nonatomic, copy) id missedSwipes;

@end
