#import <Foundation/Foundation.h>

#define BIWEEKLY_PAY_PERIOD_ID 2

@interface PayrollModel : NSObject

- (void) addRemindersForTypeIDs: (NSArray *) toAdd andCancelRemindersForTypeIDs: (NSArray *) toCancel;


@end
