#import <UIKit/UIKit.h>
#import "SettingsProtocol.h"

@interface CustomizationViewController : UIViewController <SettingsViewController>

@property (nonatomic,weak) id<SettingsDelegate> delegate;

@end
