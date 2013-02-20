#import "PayrollModel.h"
#import "ReminderCenter.h"
#import "Reminder.h"

#define PAYROLL_DATA_FILE @"PayrollData"

#define DATE_FORMAT_CODE @"dd-MM"

@interface PayrollModel()
@property (nonatomic,strong) NSMutableDictionary *typeIDToDateArray;
@property (nonatomic, strong) NSMutableDictionary *typeIDToText;
@property (nonatomic, strong) NSMutableDictionary *periodToDates;
@property (nonatomic, strong) NSString *year;
@end

@implementation PayrollModel

- (void) addRemindersForTypeIDs: (NSArray *) toAdd andCancelRemindersForTypeIDs: (NSArray *) toCancel completion: (void (^) (void)) block
{
    ReminderCenter *center = [ReminderCenter getInstance];
    [center cancelRemindersWithTypeIDs:toCancel completion:^{
        NSMutableArray *remindersToAdd = [[NSMutableArray alloc] init];
        for (NSNumber *typeID in toAdd)
        {
            NSArray *dates = [self getDatesForTypeID:[typeID intValue]];
            for (NSDate *currentDate in dates)
            {
                Reminder *reminder = [[Reminder alloc] initWithText:[self getTextForTypeID:[typeID intValue]] eventDate:currentDate fireDate:currentDate typeID:[typeID intValue]];
                [remindersToAdd addObject:reminder];
            }
        }
        [center addReminders:remindersToAdd completion:^{
            block();
        }];
    }];
}

- (NSArray*) datesForPayPeriod: (NSString *) payPeriod
{
    return [self.periodToDates objectForKey:payPeriod];
}

- (NSArray *) getDatesForTypeID: (int) typeID
{
    return [self.typeIDToDateArray objectForKey:[NSNumber numberWithInt:typeID]];
}

- (NSString *) getTextForTypeID: (int) typeID
{
    NSString *text = [self.typeIDToText objectForKey:[NSNumber numberWithInt:typeID]];
    return text ? text : @"";
}


- (void) parseData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = DATE_FORMAT_CODE;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:PAYROLL_DATA_FILE
                                                     ofType:@""];
    NSArray *lines = [[NSString stringWithContentsOfFile:path
                                       encoding:NSUTF8StringEncoding
                                          error:nil]
             componentsSeparatedByString:@"\n"];
    
    NSMutableArray *datesForTypeID = [[NSMutableArray alloc] init];
    for (NSString *line in lines)
    {
        if([line hasPrefix:@"//"]) continue; //Skip comment lines
        if([line hasPrefix:@"##"])
        {
            NSArray *headerArray = [line componentsSeparatedByString:@"##"];
            if(headerArray.count != 4) [NSException raise:NSInvalidArgumentException format:@"Each header must have the form ##Description##typeID##"];
            int currentTypeID = [[headerArray objectAtIndex:2] intValue];
            datesForTypeID = [[NSMutableArray alloc] init];
            [self.typeIDToDateArray setObject:datesForTypeID forKey:[NSNumber numberWithInt:currentTypeID]];
            [self.typeIDToText setObject:[headerArray objectAtIndex:1] forKey:[NSNumber numberWithInt:currentTypeID]];
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
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit) fromDate:date];
                components.year = 2013; //FIX ME
                date = [calendar dateFromComponents:components];
                [datesForTypeID addObject:date];
                
                NSMutableArray *datesForPeriod = [self.periodToDates objectForKey:period];
                if(!datesForPeriod) datesForPeriod = [[NSMutableArray alloc] init];
                [datesForPeriod addObject:date];
                [self.periodToDates setObject:datesForPeriod forKey:period];
            }
        }
    }
}

- (id) init
{
    if(self = [super init])
    {
        self.typeIDToDateArray = [[NSMutableDictionary alloc] init];
        self.typeIDToText = [[NSMutableDictionary alloc] init];
        self.periodToDates = [[NSMutableDictionary alloc] init];
        [self parseData];
    }
    return self;
}

@end
