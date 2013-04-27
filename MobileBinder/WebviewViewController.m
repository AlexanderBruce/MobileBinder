/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "WebviewViewController.h"


#define FAILED_TO_CONNECT_ALERT_TITLE @"Failed to Connect"
#define FAILED_TO_CONNECT_ALERT_MESSAGE @"Please ensure that you are connected to the Internet"
#define FAILED_TO_CONNECT_ALERT_CANCEL_BUTTON_TITLE @"Go Back"
#define FAILED_TO_CONNECT_ALERT_BUTTON_1_TITLE @"Try Again"
#define FAILED_TO_CONNECT_ALERT_TAG 2

@interface WebviewViewController () <UIWebViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end

@implementation WebviewViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.webview.delegate = self;
    [self startConnections];

}

- (void) startConnections
{
    self.webview.alpha = 0;
    self.loadingIndicator.alpha = 1;
    NSString *urlString =[self.webpageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.loadingIndicator startAnimating];
    [self.webview loadRequest:requestObj];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingIndicator stopAnimating];
    self.webview.alpha = 1;
    self.loadingIndicator.alpha = 0;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.loadingIndicator.alpha = 0;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FAILED_TO_CONNECT_ALERT_TITLE message:FAILED_TO_CONNECT_ALERT_MESSAGE
                                   delegate:self cancelButtonTitle:FAILED_TO_CONNECT_ALERT_CANCEL_BUTTON_TITLE otherButtonTitles:FAILED_TO_CONNECT_ALERT_BUTTON_1_TITLE, nil];
    alert.tag = FAILED_TO_CONNECT_ALERT_TAG;
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == FAILED_TO_CONNECT_ALERT_TAG)
    {
        if(buttonIndex == alertView.cancelButtonIndex)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self startConnections];
        }
    }
}

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setWebview:nil];
    [self setLoadingIndicator:nil];
    [super viewDidUnload];
}






@end
