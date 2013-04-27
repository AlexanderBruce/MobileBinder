/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "PayrollCategory.h"

@interface PayrollCategory()
@property (nonatomic, strong) NSMutableDictionary *dates;
@property (nonatomic, strong) NSString *notificationText;
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

- (NSArray *) getDates
{
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    for (NSString *key in self.dates)
    {
        [dates addObject:[self.dates objectForKey:key]];
    }
    
    NSArray *sortedDates = [dates sortedArrayUsingComparator:^(id date1, id date2) {
                                                return [date1 compare:date2];
                                            }];
    return sortedDates;
}

- (NSString *) getNotificationText
{
    if(self.notificationText.length > 0) return self.notificationText;
    else return self.name;
}

- (void) setNotificationText: (NSString *) notificationText
{
    _notificationText = notificationText;
}

- (void) setFireTime:(NSDate *)fireTime
{
    _fireTime  = fireTime;
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
