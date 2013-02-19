#import "PayrollModel.h"

#define PAYROLL_DATA_FILE @"PayrollData"

#define DATE_FORMAT_CODE @"dd-MM"

@interface PayrollModel()
@property (nonatomic,strong) NSMutableDictionary *typeIDToDateArray;
@end

@implementation PayrollModel

- (void) addRemindersForTypeIDs: (NSArray *) toAdd andCancelRemindersForTypeIDs: (NSArray *) toCancel
{
    
}

- (NSArray *) getDatesForTypeID: (int) typeID
{
    return [self.typeIDToDateArray objectForKey:[NSNumber numberWithInt:typeID]];
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
        }
        else
        {
            NSDate *date = [formatter dateFromString:line];
            if(date)
            {
                [datesForTypeID addObject:date];
            }
        }
    }
}

- (id) init
{
    if(self = [super init])
    {
        self.typeIDToDateArray = [[NSMutableDictionary alloc] init];
        [self parseData];
    }
    return self;
}

@end
