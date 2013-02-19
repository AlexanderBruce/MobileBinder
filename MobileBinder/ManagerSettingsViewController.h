#import <UIKit/UIKit.h>
#import "SettingsProtocol.h"

@interface ManagerSettingsViewController : UIViewController <SettingsViewController>

@property (nonatomic,weak) id<SettingsDelegate> delegate;

@end
