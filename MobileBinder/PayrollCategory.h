#import <Foundation/Foundation.h>

@interface PayrollCategory : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic) int typeID;

- (void) addDate: (NSDate *) date forPeriod: (NSString *) period;

- (NSDate *) dateForPeriod: (NSString *) period;
@end
