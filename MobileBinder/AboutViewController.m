#import "AboutViewController.h"
#import "OutlinedLabel.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    for(UIView *view in self.scrollView.subviews)
    {
        if([view isKindOfClass:[OutlinedLabel class]])
        {
            OutlinedLabel *label = (OutlinedLabel *) view;
            [label customize];
        }
    }
}


- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
