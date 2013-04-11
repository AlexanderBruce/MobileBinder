#import <Foundation/Foundation.h>

@protocol PayrollModelDelegate <NSObject>

- (void) doneInitializingPayrollModel;

@end

typedef enum Mode {
    BiweeklyMode = 0,
    MonthlyMode = 1
} Mode;

@interface PayrollModel : NSObject

@property (nonatomic) Mode mode;

- (void) addRemindersForTypeIDs: (NSArray *) toAdd andCancelRemindersForTypeIDs: (NSArray *) toCancel completion: (void (^) (void)) block;

- (NSArray *) getPeriods;

- (NSArray *) getCategories;

- (NSDate *) getDateForCategoryNum: (int) categoryNum period: (NSString *) period;

- (void) initializeModelWithDelegate: (id<PayrollModelDelegate>) delegate;

@end
