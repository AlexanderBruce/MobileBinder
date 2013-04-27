/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>
@class EmployeeRecord;

/*
 *  THIS IS A DEMO CLASS
 *  Used to randomly add incidents to a collection of employees
 */
@interface IncidentAutopopulator : NSObject

- (void) populateEmployeeRecords: (NSArray *) employeeRecords;

@end
