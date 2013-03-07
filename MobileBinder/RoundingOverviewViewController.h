#import <UIKit/UIKit.h>
@class RoundingModel;
@class RoundingLog;

@interface RoundingOverviewViewController : UIViewController

@property (nonatomic, strong) RoundingLog *log;
@property (nonatomic, strong) RoundingModel *model;

@end
