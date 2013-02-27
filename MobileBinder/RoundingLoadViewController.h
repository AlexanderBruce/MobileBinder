#import <UIKit/UIKit.h>
@class RoundingLog;
@class RoundingModel;

@protocol RoundingLoadDelegate <NSObject>

- (void) selectedRoundingLog: (RoundingLog *) log;

@end

@interface RoundingLoadViewController : UIViewController

@property (nonatomic, strong) RoundingModel *model;

@property (nonatomic, weak) id<RoundingLoadDelegate> delegate;

@end
