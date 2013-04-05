#import <UIKit/UIKit.h>
#import "SettingsProtocol.h"
#import "BackgroundViewController.h"

@interface PersonalizationViewController : BackgroundViewController <SettingsViewController>

@property (nonatomic,weak) id<SettingsDelegate> delegate;

@end
