#import <UIKit/UIKit.h>
#import "BackgroundViewController.h"
#import "SettingsProtocol.h"

@interface NotificationSettingsViewController : BackgroundViewController  <SettingsViewController>

@property (nonatomic, weak) id<SettingsDelegate> delegate;

@end
