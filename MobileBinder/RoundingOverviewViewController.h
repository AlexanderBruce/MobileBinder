#import <UIKit/UIKit.h>
#import "BackgroundViewController.h"
@class RoundingModel;
@class RoundingLog;

@interface RoundingOverviewViewController : BackgroundViewController
@property (nonatomic, strong) RoundingModel *model;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) RoundingLog *log;

//ABSTRACT
- (void) storeDataIntoLog;

@end
