#import "HomeViewController.h"
#import "MarqueeLabel.h"
#import "PayrollModel.h"
#import "WelcomeViewController.h"

#define USED_APP_BEFORE @"firstTimeUsingAppKey"
#define WELCOME_SEGUE @"welcomeSegue"

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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:USED_APP_BEFORE])
    {
        [defaults setBool:YES forKey:USED_APP_BEFORE];
        [defaults synchronize];
        [self performSegueWithIdentifier:WELCOME_SEGUE sender:self];
    }
}

@end
