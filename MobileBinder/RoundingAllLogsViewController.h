#import <UIKit/UIKit.h>
@class RoundingLog;
@class RoundingModel;

@interface RoundingAllLogsViewController : UIViewController

//ABSTRACT METHOD
- (UITableViewCell *) customizeCell: (UITableViewCell *) cell forIndexPath: (NSIndexPath *) indexPath usingRoundingLog: (RoundingLog *) log;

//ABSTRACT METHOD
- (RoundingModel *) createModel;


@end
