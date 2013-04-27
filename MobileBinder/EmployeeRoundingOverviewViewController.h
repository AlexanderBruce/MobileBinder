#import <UIKit/UIKit.h>
#import "RoundingOverviewViewController.h"
#import "RoundingLog.h"
#import "EmployeeRoundingLog.h"
@class RoundingModel;


/*
 *  Displays the "overview" information about one employee rounding log
 */
@interface EmployeeRoundingOverviewViewController : RoundingOverviewViewController

@property (nonatomic, strong) EmployeeRoundingLog *log; /* The log whose information is displayed */
@property (nonatomic, strong) RoundingModel *model;

@end
