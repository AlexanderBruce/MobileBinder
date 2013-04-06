#import "WebviewViewController.h"
#import "ASIWebPageRequest.h"
#import "ASIDownloadCache.h"

typedef enum {
    UnFinished,
    Failed,
    Succeeded
} ConnectionStatus;

#define FAILED_TO_CONNECT_ALERT_TITLE @"Failed to Connect"
#define FAILED_TO_CONNECT_ALERT_MESSAGE @"Please ensure that you are connected to the Internet"
#define FAILED_TO_CONNECT_ALERT_CANCEL_BUTTON_TITLE @"Go Back"
#define FAILED_TO_CONNECT_ALERT_BUTTON_1_TITLE @"Try Again"
#define FAILED_TO_CONNECT_ALERT_TAG 2

#define OFFLINE_MODE_ALERT_TITLE @"Offline Mode"
#define OFFLINE_MODE_ALERT_MESSAGE @"You are viewing an old version of this webpage"
#define OFFLINE_MODE_ALERT_CANCEL_BUTTON_TITLE @"Okay"
#define OFFLINE_MODE_ALERT_TAG 3

@interface WebviewViewController () <UIWebViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic ,strong) ASIWebPageRequest *request;
@property (nonatomic) ConnectionStatus webviewConnectionStatus;
@property (nonatomic) ConnectionStatus cachingConnectionStatus;
@property (nonatomic, strong) NSString *cachingResponse; //May be null if cachingConnection is not finished or if cachingConnection fails
@property (atomic, strong) NSLock *lock;
@end

@implementation WebviewViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.webview.delegate = self;
    [self startConnections];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self request] setDelegate:nil];
    [[self request] cancel];
}

- (void) startConnections
{
    [self.lock lock];
    self.webview.alpha = 0;
    self.webviewConnectionStatus = UnFinished;
    self.cachingConnectionStatus = Failed;
    NSString *urlString =[self.webpageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webview loadRequest:requestObj];
//    [self loadURL:[NSURL URLWithString:self.webpageURL]];
    [self.lock unlock];
//    NSLog(@"|%@|",[NSString localizedNameOfStringEncoding:5]);
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *str = [NSString stringWithContentsOfFile:
//     [defaults objectForKey:@"AmazonPath"] encoding:5 error:nil];
//    NSLog(@"URL = %@",[defaults URLForKey:@"AmazonURL"]);
//    NSLog(@"Path = %@",[defaults objectForKey:@"AmazonPath"]);
////    NSLog(@"Contents = %@",str);
//    
//    [self.webview loadData:[str dataUsingEncoding:NSUTF8StringEncoding] MIMEType:@"application/xhtml+xml" textEncodingName:@"utf-8" baseURL:[defaults URLForKey:@"AmazonURL"]];

}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [self.loadingIndicator startAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Finished");
    [self.lock lock];
    self.webviewConnectionStatus = Succeeded;
    [self.loadingIndicator stopAnimating];
    self.webview.alpha = 1;
    [self.lock unlock];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Failed %@",error.localizedDescription);
    [self.lock lock];
    self.webviewConnectionStatus = Failed;
    if(self.cachingConnectionStatus == Failed)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FAILED_TO_CONNECT_ALERT_TITLE message:FAILED_TO_CONNECT_ALERT_MESSAGE
                                   delegate:self cancelButtonTitle:FAILED_TO_CONNECT_ALERT_CANCEL_BUTTON_TITLE otherButtonTitles:FAILED_TO_CONNECT_ALERT_BUTTON_1_TITLE, nil];
        alert.tag = FAILED_TO_CONNECT_ALERT_TAG;
        [alert show];
    }
    else if(self.cachingConnectionStatus == Succeeded)
    {
        self.webview.alpha = 1;
        [self.webview loadHTMLString:self.cachingResponse baseURL:[self.request url]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:OFFLINE_MODE_ALERT_TITLE message:OFFLINE_MODE_ALERT_MESSAGE
                                                       delegate:self cancelButtonTitle:OFFLINE_MODE_ALERT_CANCEL_BUTTON_TITLE otherButtonTitles:nil];
        alert.tag = OFFLINE_MODE_ALERT_TAG;
        [alert show];
    }
    [self.lock unlock];
}

- (void)webPageFetchFailed:(ASIHTTPRequest *)theRequest
{
    [self.lock lock];
    self.cachingConnectionStatus = Failed;
    if(self.webviewConnectionStatus == Failed)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FAILED_TO_CONNECT_ALERT_TITLE message:FAILED_TO_CONNECT_ALERT_MESSAGE
                                                       delegate:self cancelButtonTitle:FAILED_TO_CONNECT_ALERT_CANCEL_BUTTON_TITLE otherButtonTitles:FAILED_TO_CONNECT_ALERT_BUTTON_1_TITLE, nil];
        alert.tag = FAILED_TO_CONNECT_ALERT_TAG;
        [alert show];
    }
    [self.lock unlock];
}

- (void)webPageFetchSucceeded:(ASIHTTPRequest *)theRequest
{
    [self.lock lock];
    self.cachingConnectionStatus = Succeeded;
    self.cachingResponse = [NSString stringWithContentsOfFile:
                            [theRequest downloadDestinationPath] encoding:[theRequest responseEncoding] error:nil];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:theRequest.downloadDestinationPath forKey:@"AmazonPath"];
////    NSLog(@"Path = %@",theRequest.downloadDestinationPath);
//    NSLog(@"URL = %@", theRequest.url);
////    NSLog(@"Encoding = %u",theRequest.responseEncoding);
////    NSLog(@"Contents = %@",self.cachingResponse);
//    [defaults setURL:theRequest.url forKey:@"AmazonURL"];
//    [defaults synchronize];
    if(self.webviewConnectionStatus == Failed)
    {
        self.webview.alpha = 1;
        [self.webview loadHTMLString:self.cachingResponse baseURL:[self.request url]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:OFFLINE_MODE_ALERT_TITLE message:OFFLINE_MODE_ALERT_MESSAGE
                                                       delegate:self cancelButtonTitle:OFFLINE_MODE_ALERT_CANCEL_BUTTON_TITLE otherButtonTitles:nil];
        alert.tag = OFFLINE_MODE_ALERT_TAG;
        [alert show];
    }
    [self.lock unlock];
}


- (void)loadURL:(NSURL *)url
{
    // Assume request is a property of our controller
    // First, we'll cancel any in-progress page load
    [[self request] setDelegate:nil];
    [[self request] cancel];
    
    [self setRequest:[ASIWebPageRequest requestWithURL:url]];
    [[self request] setDelegate:self];
    [[self request] setDidFailSelector:@selector(webPageFetchFailed:)];
    [[self request] setDidFinishSelector:@selector(webPageFetchSucceeded:)];
    
    // Tell the request to embed external resources directly in the page
    [[self request] setUrlReplacementMode:ASIReplaceExternalResourcesWithData];
    
    // It is strongly recommended you use a download cache with ASIWebPageRequest
    // When using a cache, external resources are automatically stored in the cache
    // and can be pulled from the cache on subsequent page loads
    [[self request] setDownloadCache:[ASIDownloadCache sharedCache]];
    self.request.cachePolicy = ASIFallbackToCacheIfLoadFailsCachePolicy;
    // Ask the download cache for a place to store the cached data
    // This is the most efficient way for an ASIWebPageRequest to store a web page
    [[self request] setDownloadDestinationPath:
     [[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:[self request]]];
    
    
    [[self request] startAsynchronous];
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
