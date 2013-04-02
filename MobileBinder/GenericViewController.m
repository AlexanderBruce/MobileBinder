#import "GenericViewController.h"

@interface GenericViewController ()

@end

@implementation GenericViewController

- (void) viewDidLoad
{
    [super viewDidLoad];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"BackgroundImage"];
    UIImage* image = [UIImage imageWithData:imageData];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
//    self.view.backgroundColor = [UIColor customGroupTableViewBackgroundColor];
}


@end
