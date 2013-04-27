/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/*
 *  The parallel class to Reminder.m/h that interfaces with CoreData
 *  See Reminder.h for more details
 *  Design note: Reminder and ReminderManagedObject should probably be combined into one class
 */
@interface ReminderManagedObject : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * fireDate;
@property (nonatomic, retain) NSNumber * typeID;
@property (nonatomic, retain) NSNumber *uniqueID;

@end
