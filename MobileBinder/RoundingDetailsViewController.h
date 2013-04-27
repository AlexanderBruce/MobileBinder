#import <UIKit/UIKit.h>
@class RoundingLog;
@class RoundingModel;

/*
 *  Displays the table portion of a single rounding log and allow the user to edit it 
 */
@interface RoundingDetailsViewController : UIViewController

/*
 *  The log whose table should be displayed and edited
 */
@property (nonatomic, strong) RoundingLog *log;

/*
 *  The model where the displayed rounding log comes from
 */
@property (nonatomic, strong) RoundingModel *model;

@end
