/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "IncidentAutopopulator.h"
#import "EmployeeRecord.h"

@interface IncidentAutopopulator()
@property (nonatomic, strong) NSMutableArray *possibleDates;
@property (nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation IncidentAutopopulator

- (void) populateEmployeeRecords:(NSArray *)employeeRecords
{
    for(int i = 0; i < employeeRecords.count; i++)
    {
        EmployeeRecord *record = [employeeRecords objectAtIndex:i];
        
        NSInteger numOfAbsences = arc4random() % ((int)(MAX_ABSENCES + 1));
        if(i == 0) numOfAbsences = LEVEL_1_ABSENCE_THRESHOLD - 1;
        if(i == 1) numOfAbsences = 3;
        NSArray *absences = [self getNRandomDates:numOfAbsences];
        for (NSDate *date in absences) {
            [record addAbsence:date error:nil];
        }
        
        NSInteger numOfTardies = arc4random() % ((int)(MAX_TARDIES + 1));
        if(i == 1) numOfTardies = LEVEL_2_TARDY_THRESHOLD - 1;
        NSArray *tardies = [self getNRandomDates:numOfTardies];
        for (NSDate *date in tardies) {
            [record addTardy:date error:nil];
        }
        
        NSInteger numOfMissedSwipes = arc4random() % ((int)(MAX_MISSED_SWIPES + 1));
        if(i == 2) numOfMissedSwipes = LEVEL_3_SWIPE_THRESHOLD - 1;
        NSArray *missedSwipes = [self getNRandomDates:numOfMissedSwipes];
        for (NSDate *date in missedSwipes)
        {
            [record addMissedSwipe:date error:nil];
        }
    }

}

- (NSArray *) getNRandomDates: (int) N
{
    NSMutableSet *pickedDatesSet = [[NSMutableSet alloc] init];
    while (pickedDatesSet.count != N)
    {
        NSString *dateString = [self.possibleDates objectAtIndex: arc4random() % [self.possibleDates count]];
        NSDate *date = [self.formatter dateFromString:dateString];
        [pickedDatesSet addObject: date];
    }
    NSArray *pickedDatesArray = [NSArray arrayWithArray:[pickedDatesSet allObjects]];
    pickedDatesArray = [[pickedDatesArray sortedArrayUsingComparator:
                                            ^(id obj1, id obj2) {
                                                return [obj1 compare:obj2]; // note reversed comparison here
                                            }] mutableCopy];
    return pickedDatesArray;
}

- (id) init
{
    if(self = [super init])
    {
        self.possibleDates = [[NSMutableArray alloc] init];
        [self.possibleDates addObject:@"03/24/13"];
        [self.possibleDates addObject:@"02/18/13"];
        [self.possibleDates addObject:@"01/01/13"];
        [self.possibleDates addObject:@"03/22/13"];
        [self.possibleDates addObject:@"02/17/13"];
        [self.possibleDates addObject:@"01/16/13"];
        [self.possibleDates addObject:@"03/04/13"];
        [self.possibleDates addObject:@"02/11/13"];
        [self.possibleDates addObject:@"01/12/13"];
        [self.possibleDates addObject:@"03/29/13"];
        [self.possibleDates addObject:@"02/20/13"];
        [self.possibleDates addObject:@"01/19/13"];
        [self.possibleDates addObject:@"03/10/13"];
        [self.possibleDates addObject:@"02/18/13"];
        [self.possibleDates addObject:@"01/23/13"];
        
        [self.possibleDates addObject:@"12/03/12"];
        [self.possibleDates addObject:@"11/16/12"];
        [self.possibleDates addObject:@"10/13/12"];
        [self.possibleDates addObject:@"09/08/12"];
        [self.possibleDates addObject:@"08/22/12"];


        self.formatter = [[NSDateFormatter alloc] init];
        self.formatter.dateFormat = @"MM/dd/yy";
    }
    return self;
}

@end
