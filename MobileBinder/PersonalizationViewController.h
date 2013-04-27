#import <UIKit/UIKit.h>
#import "SettingsProtocol.h"
#import "BackgroundViewController.h"

/*
 *  Allows the user to personalize their app (colors, backgrounds, fonts...etc)
 */
@interface PersonalizationViewController : BackgroundViewController <SettingsViewController>

@property (nonatomic,weak) id<SettingsDelegate> delegate;

@end
