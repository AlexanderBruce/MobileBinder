#import "BackgroundViewController.h"
#import "Constants.h"

@interface BackgroundViewController ()

@end

@implementation BackgroundViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadBackgroundImage];
}

- (void) loadBackgroundImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:BACKGROUND_IMAGE_FILENAME];
    UIImage *image = [UIImage imageWithContentsOfFile:getImagePath];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}


@end
