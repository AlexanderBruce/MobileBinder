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
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:USED_APP_BEFORE])
    {
        [defaults setBool:YES forKey:USED_APP_BEFORE];
        [defaults synchronize];
        [self performSegueWithIdentifier:WELCOME_SEGUE sender:self];
    }
    
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    notif.timeZone = [NSTimeZone defaultTimeZone];
    notif.alertBody = [NSString stringWithFormat:@"Hi Alex"];
    notif.hasAction = YES;
    
//    notif.fireDate = [[NSDate date] dateByAddingTimeInterval:10] ; //get x minute after
//    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
//    
//    UILocalNotification *notif1 = [[UILocalNotification alloc] init];
//    notif1.timeZone = [NSTimeZone defaultTimeZone];
//    notif1.alertBody = [NSString stringWithFormat:@"Hi Alex"];
//    notif1.hasAction = YES;
//    
//    notif1.fireDate = [[NSDate date] dateByAddingTimeInterval:10] ; //get x minute after
//    [[UIApplication sharedApplication] scheduleLocalNotification:notif1];
}

@end
