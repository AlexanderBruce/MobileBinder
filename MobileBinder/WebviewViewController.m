#import "WebviewViewController.h"

@interface WebviewViewController () <UIWebViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@end

@implementation WebviewViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.webview.delegate = self;
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webpageURL]];
    [self.webview loadRequest:requestObj];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Failed to connect" message:@"Please ensure that you are connected to the Internet" delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:@"Try Again", nil] show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) //Go back
    {
        [self.delegate doneViewingWebpage];
    }
    else if (buttonIndex == 1) //Try Again
    {
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webpageURL]];
        [self.webview loadRequest:requestObj];
    }
}

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    [self.delegate doneViewingWebpage];
}

- (void)viewDidUnload
{
    [self setWebview:nil];
    [super viewDidUnload];
}
@end
