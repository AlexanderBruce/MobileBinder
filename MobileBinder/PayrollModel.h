#import <Foundation/Foundation.h>

@interface PayrollModel : NSObject

- (void) addRemindersForTypeIDs: (NSArray *) toAdd andCancelRemindersForTypeIDs: (NSArray *) toCancel;

@end
