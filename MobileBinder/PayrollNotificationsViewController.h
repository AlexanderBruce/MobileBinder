#import <UIKit/UIKit.h>
#import "SettingsProtocol.h"

@interface PayrollNotificationsViewController : UITableViewController <SettingsViewController>

@property (nonatomic, weak) id<SettingsDelegate> delegate;

@end
