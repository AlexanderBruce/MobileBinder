#import <UIKit/UIKit.h>
@class RoundingLog;
@class RoundingModel;

/*
 *  ABSTRACT CLASS
 *  Displays all rounding logs of a specific type (depending on who is subclassing this)
 */
@interface RoundingAllLogsViewController : UIViewController

/*
 *  ABSTRACT METHOD 
 *  Subclasses should customize the passed-in cell and return it
 */
- (UITableViewCell *) customizeCell: (UITableViewCell *) cell forIndexPath: (NSIndexPath *) indexPath usingRoundingLog: (RoundingLog *) log;

/*
 *  ABSTRACT METHOD
 *  Subclasses should return a rounding model that this view controller can obtain rounding logs from
 */
- (RoundingModel *) createModel;


@end
