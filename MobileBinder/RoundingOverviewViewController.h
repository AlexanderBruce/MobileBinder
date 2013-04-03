#import <UIKit/UIKit.h>
@class RoundingModel;
@class RoundingLog;

@interface RoundingOverviewViewController : UIViewController
@property (nonatomic, strong) RoundingModel *model;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) RoundingLog *log;

//ABSTRACT
- (void) saveDataIntoLog;

@end
