/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "PayrollModel.h"
#import "ReminderCenter.h"
#import "Reminder.h"
#import "PayrollCategory.h"

#define BIWEEKLY_PAYROLL_DATA_FILE @"BiweeklyPayrollData"
#define MONTHLY_PAYROLL_DATA_FILE @"MonthlyPayrollData"

#define DATE_FORMAT_CODE @"dd-MM-yy"
#define TIME_FORMAT_CODE @"HH:mm"

@interface PayrollModel()
@property (nonatomic, strong) NSMutableArray *biweeklyCategories;
@property (nonatomic, strong) NSMutableArray *biweeklyPeriods;
@property (nonatomic, strong) NSMutableArray *monthlyCategories;
@property (nonatomic, strong) NSMutableArray *monthlyPeriods;
@property (nonatomic, strong) NSMutableArray *currentCategories;
@property (nonatomic, strong) NSMutableArray *currentPeriods;
@end

@implementation PayrollModel

- (void) setMode:(Mode)mode
{
    _mode = mode;
    if(_mode == BiweeklyMode)
    {
        self.currentCategories = self.biweeklyCategories;
        self.currentPeriods = self.biweeklyPeriods;
    }
    else
    {
        self.currentCategories = self.monthlyCategories;
        self.currentPeriods = self.monthlyPeriods;
    }
}

- (void) addRemindersForTypeIDs: (NSArray *) toAdd andCancelRemindersForTypeIDs: (NSArray *) toCancel completion: (void (^) (void)) block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ReminderCenter *center = [ReminderCenter getInstance];
        NSMutableArray *remindersToAdd = [[NSMutableArray alloc] init];
        for (NSNumber *typeID in toAdd)
        {
            NSArray *biweeklyReminders = [self produceRemindersFromCategories:self.biweeklyCategories matchingTypeID:[typeID intValue]];
            NSArray *monthlyReminders =[self produceRemindersFromCategories:self.monthlyCategories matchingTypeID:[typeID intValue]];
            [remindersToAdd addObjectsFromArray:biweeklyReminders];
            [remindersToAdd addObjectsFromArray:monthlyReminders];
        }
        [center addReminders:remindersToAdd cancelRemindersWithTypeIDs:toCancel completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
        }];
    });
}

- (NSArray *) produceRemindersFromCategories: (NSArray *) categories matchingTypeID: (int) typeID
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for (PayrollCategory *category in categories)
    {
        if(category.typeID == typeID)
        {
            NSArray *dates = [category getDates];
            
            NSDateComponents *timeComps = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:category.fireTime];
            
            for (NSDate *date in dates)
            {
                NSDateComponents *dateComps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:date];
                
                NSDateComponents *dateAndTimecomps = [[NSDateComponents alloc] init];
                dateAndTimecomps.year = dateComps.year;
                dateAndTimecomps.month = dateComps.month;                
                dateAndTimecomps.day = dateComps.day;
                dateAndTimecomps.hour = timeComps.hour;
                dateAndTimecomps.minute = timeComps.minute;
                
                NSDate *fireDateAndTime = [[NSCalendar currentCalendar] dateFromComponents:dateAndTimecomps];

                Reminder *reminder = [[Reminder alloc] initWithText:[category getNotificationText] fireDate:fireDateAndTime typeID:category.typeID];
                [returnArray addObject:reminder];
            }
        }
    }
    return returnArray;
}

- (NSArray *) getPeriods
{
    return self.currentPeriods;
}

- (NSArray *) getCategories
{
    return self.currentCategories;
}

- (NSDate *) getDateForCategoryNum: (int) categoryNum period: (NSString *) period
{
    PayrollCategory *category = [self.currentCategories objectAtIndex:categoryNum];
    return [category dateForPeriod:period];
}

- (void) parseDataFromFile: (NSString *) file categories: (NSMutableArray *) categories periods: (NSMutableArray *) periods
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = DATE_FORMAT_CODE;
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = TIME_FORMAT_CODE;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:file
                                                     ofType:@""];
    NSArray *lines = [[NSString stringWithContentsOfFile:path
                                       encoding:NSUTF8StringEncoding
                                          error:nil]
             componentsSeparatedByString:@"\n"];
    
    PayrollCategory *currentCategory;
    for (NSString *line in lines)
    {
        if([line hasPrefix:@"//"]) continue; //Skip comment lines
        else if([line hasPrefix:@"##"])
        {
            NSArray *headerArray = [line componentsSeparatedByString:@"##"];
            if(headerArray.count != 4) [NSException raise:NSInvalidArgumentException format:@"Each header must have the form ##Description##typeID##"];
            currentCategory = [[PayrollCategory alloc] init];
            currentCategory.name = [headerArray objectAtIndex:1];
            currentCategory.typeID = [[headerArray objectAtIndex:2] intValue];
            [categories addObject:currentCategory];
        }
        else if([line hasPrefix:@"**"])
        {
            NSArray *notificationTextArray = [line componentsSeparatedByString:@"**"];
            if(notificationTextArray.count != 3) [NSException raise:NSInvalidArgumentException format:@"Each notification text header must have the form **Notification Text**"];
            [currentCategory setNotificationText:[notificationTextArray objectAtIndex:1]];
        }
        else if([line hasPrefix:@"!!"])
        {
            NSArray *notificationTimeArray = [line componentsSeparatedByString:@"!!"];
            if(notificationTimeArray.count != 3) [NSException raise:NSInvalidArgumentException format:@"Each notification fire time header must have the form !!Fire Time!!"];
            NSDate *time = [timeFormatter dateFromString:[notificationTimeArray objectAtIndex:1]];
            if(time)
            {
                currentCategory.fireTime = time;
            }
        }
        else
        {
            if(line.length < 4) continue;
            int delimiterLocation = [line rangeOfString:@":"].location;
            NSString *period = [line substringToIndex:delimiterLocation];
            NSString *dateString = [line substringFromIndex:delimiterLocation + 1];
            NSDate *date = [formatter dateFromString:dateString];
            if(date)
            {
                [currentCategory addDate:date forPeriod:period];
                if(![periods containsObject:period])
                {
                    [periods addObject:period];
                }
            }
        }
    }
}

- (void) initializeModelWithDelegate:(id<PayrollModelDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{    
        [self parseDataFromFile:BIWEEKLY_PAYROLL_DATA_FILE categories:self.biweeklyCategories periods:self.biweeklyPeriods];
        [self parseDataFromFile:MONTHLY_PAYROLL_DATA_FILE categories:self.monthlyCategories periods:self.monthlyPeriods];
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate doneInitializingPayrollModel];
        });
    });
}

- (id) init
{
    if(self = [super init])
    {
        self.biweeklyCategories = [[NSMutableArray alloc] init];
        self.biweeklyPeriods = [[NSMutableArray alloc] init];
        self.monthlyCategories = [[NSMutableArray alloc] init];
        self.monthlyPeriods = [[NSMutableArray alloc] init];
        self.mode = BiweeklyMode;
    }
    return self;
}

@end
