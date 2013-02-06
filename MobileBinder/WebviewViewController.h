#import <UIKit/UIKit.h>

@protocol WebviewViewControllerDelegate <NSObject>

- (void) doneViewingWebpage;

@end

@interface WebviewViewController : UIViewController
@property (nonatomic, strong) NSString *webpageURL;
@property (nonatomic, weak) id<WebviewViewControllerDelegate> delegate;
@end
