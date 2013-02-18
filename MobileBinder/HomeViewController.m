#import "HomeViewController.h"
#import "MarqueeLabel.h"
#import "PayrollModel.h"


@interface HomeViewController ()
@property (nonatomic, strong) MarqueeLabel *reminderLabel;

@end

@implementation HomeViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.reminderLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 70) rate:50.0 andFadeLength:0.5f];
    self.reminderLabel.text = @"";
    self.reminderLabel.marqueeType = MLContinuous;
    [self.view addSubview:self.reminderLabel];
}

@end
