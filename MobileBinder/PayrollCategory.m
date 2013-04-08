#import "PayrollCategory.h"

@interface PayrollCategory()
@property (nonatomic, strong) NSMutableDictionary *dates;
@end

@implementation PayrollCategory

- (void) addDate: (NSDate *) date forPeriod:(NSString *)period
{
    [self.dates setObject:date forKey:period];
}

- (NSDate *) dateForPeriod:(NSString *)period
{
    return [self.dates objectForKey:period];
}
- (id) init
{
    if(self=[super init])
    {
        self.dates = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
