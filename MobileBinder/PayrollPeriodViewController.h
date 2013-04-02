#import <UIKit/UIKit.h>
#import "BackgroundViewController.h"

@interface PayrollPeriodViewController : BackgroundViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource> ;

@property (strong, nonatomic) NSMutableArray* possiblePayPeriods;

@end
