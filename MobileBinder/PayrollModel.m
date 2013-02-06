#import "PayrollModel.h"

@implementation PayrollModel

- (NSArray *) getDatesForTypeID: (int) typeID
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 0;
    for(int i = 0; i < 52; i++)
    {
        [returnArray addObject:[calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0]];
        dayComponent.day = dayComponent.day + typeID;
    }
    return returnArray;
}

@end
