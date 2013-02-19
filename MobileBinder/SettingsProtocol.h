#import <Foundation/Foundation.h>

@protocol SettingsDelegate <NSObject>

- (void) savedSettingsForViewController: (UIViewController *) viewController;

@end

@protocol SettingsViewController <NSObject>

@property (nonatomic, weak) id<SettingsDelegate> delegate;

@end
