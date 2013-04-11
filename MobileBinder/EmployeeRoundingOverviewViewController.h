#import <UIKit/UIKit.h>
#import "RoundingOverviewViewController.h"
@class RoundingModel;
#import "RoundingLog.h"
#import "EmployeeRoundingLog.h"

@interface EmployeeRoundingOverviewViewController : RoundingOverviewViewController

@property (nonatomic, strong) EmployeeRoundingLog *log;
@property (nonatomic, strong) RoundingModel *model;

@end
