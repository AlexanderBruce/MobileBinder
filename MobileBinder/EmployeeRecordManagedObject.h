//
//  EmployeeRecordManagedObject.h
//  MobileBinder
//
//  Created by Andrew Patterson on 1/29/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EmployeeRecordManagedObject : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, copy) id absences;
@property (nonatomic, copy) id tardies;
@property (nonatomic, copy) id missedSwipes;

@end
