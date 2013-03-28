#import <UIKit/UIKit.h>
@class RoundingModel;
@class EmployeeRoundingLog;

@interface EmployeeRoundingOverviewViewController : UIViewController

@property (nonatomic, strong) EmployeeRoundingLog *log;
@property (nonatomic, strong) RoundingModel *model;

@end
