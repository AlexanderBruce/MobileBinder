#import <UIKit/UIKit.h>
#import "SettingsProtocol.h"

@interface PersonalizationViewController : UIViewController <SettingsViewController>

@property (nonatomic,weak) id<SettingsDelegate> delegate;

@end
