#import <UIKit/UIKit.h>
#import "BackgroundViewController.h"
#import "SettingsProtocol.h"

/*
 *  Allows the user to select what notifications they recieve from this app
 */
@interface NotificationSettingsViewController : BackgroundViewController  <SettingsViewController>

@property (nonatomic, weak) id<SettingsDelegate> delegate;

@end
