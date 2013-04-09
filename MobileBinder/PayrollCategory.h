#import <Foundation/Foundation.h>

@interface PayrollCategory : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic) int typeID;
@property (nonatomic, strong) NSDate *fireTime;

- (void) addDate: (NSDate *) date forPeriod: (NSString *) period;

- (NSDate *) dateForPeriod: (NSString *) period;

//Return array is sorted by soonest (or furthest in past) date to farthest away date
- (NSArray *) getDates;

- (void) setNotificationText: (NSString *) notificationText;

- (NSString *) getNotificationText;

@end
