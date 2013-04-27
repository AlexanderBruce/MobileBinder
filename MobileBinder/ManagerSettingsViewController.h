#import <UIKit/UIKit.h>
#import "SettingsProtocol.h"

/*
 *  Allows the user to input information about the manager that is using the app
 */
@interface ManagerSettingsViewController : UIViewController <SettingsViewController>

@property (nonatomic,weak) id<SettingsDelegate> delegate;

@end
