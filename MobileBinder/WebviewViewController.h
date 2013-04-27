#import <UIKit/UIKit.h>

/*
 *  A basic view controller that displays a webpage in a UIWebView
 */
@interface WebviewViewController : UIViewController

/*
 *  The complete URL (e.g. http://www.example.com ) that should be displayed
 */
@property (nonatomic, strong) NSString *webpageURL;

@end
