#import <UIKit/UIKit.h>
#import "BackgroundViewController.h"
#import "RoundingOverviewViewController.h"
#import "SeniorRoundingLog.h"
#import "RoundingLog.h"

/*
 *   Displays "overview" information about a single senior rounding log
 */
@interface SeniorRoundingOverviewViewController : RoundingOverviewViewController
@property (nonatomic, strong) SeniorRoundingLog *log;
@end
