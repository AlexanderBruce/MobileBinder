#import "HomeViewController.h"
#import "PayrollModel.h"
#import "WelcomeViewController.h"
#import "AttendanceModel.h"

#define USED_APP_BEFORE @"firstTimeUsingAppKey"
#define WELCOME_SEGUE @"welcomeSegue"

@interface HomeViewController ()
@end

@implementation HomeViewController


- (void) viewDidAppear:(BOOL)animated
{
//    AttendanceModel *model = [[AttendanceModel alloc] init];
//    [model addEmployeesWithSupervisorID:@"00130925"];
    
    
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
