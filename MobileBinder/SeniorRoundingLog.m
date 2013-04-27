/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "SeniorRoundingLog.h"
#import "SeniorRoundingLogManagedObject.h"

@interface SeniorRoundingLog()
@property (nonatomic, strong) NSArray *columnTitles;
@property (nonatomic, strong) SeniorRoundingLogManagedObject *managedObject;
@end

@implementation SeniorRoundingLog

- (NSArray *) getColumnTitles
{
    if (!_columnTitles) _columnTitles = [NSArray arrayWithObjects: @"Unit",@"Working Well", @"Reward and Recognition", @"Improvement", @"Additional Learnings", @"Follow-Up Action", nil];
    return _columnTitles;
}

- (void) discardChanges
{
    self.date = self.managedObject.date;
    self.unit = self.managedObject.unit;
    self.name = self.managedObject.name;
    self.notes = self.managedObject.notes;
    [super discardChanges];
}

- (void) saveLogWithCompletition:(void (^)(void))block
{
    self.managedObject.date = self.date;
    self.managedObject.unit = self.unit;
    self.managedObject.name = self.name;
    self.managedObject.notes = self.notes;
    [super saveLogWithCompletition:block];
}


- (void) setDate:(NSDate *)date
{
    _date = date;
    self.saved = NO;
}

- (void) setUnit:(NSString *)unit
{
    _unit = unit;
    self.saved = NO;
}

- (void) setName:(NSString *)name
{
    _name = name;
    self.saved = NO;
}

- (void) setNotes:(NSString *)notes
{
    _notes = notes;
    self.saved = NO;
}


- (id) initWithManagedObject: (SeniorRoundingLogManagedObject *) managedObject
{
    if(self = [super initWithManagedObject:managedObject])
    {        
        self.date = (managedObject.date) ? managedObject.date : [NSDate date];
        self.unit = (managedObject.unit) ? managedObject.unit : @"";
        self.name = (managedObject.name) ? managedObject.name : @"";
        self.notes = (managedObject.notes) ? managedObject.notes : @"";
        self.managedObject = managedObject;
    }
    return self;
}


@end
