/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "HomeViewController.h"
#import "PayrollModel.h"
#import "WelcomeViewController.h"
#import "AttendanceModel.h"
#import "GradientButton.h"
#import "UIButton+Disable.h"

#define USED_APP_BEFORE @"firstTimeUsingAppKey"
#define WELCOME_SEGUE @"welcomeSegue"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet GradientButton *attendanceButton;
@end

@implementation HomeViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.attendanceButton disableButton];
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

- (void)viewDidUnload {
    [self setAttendanceButton:nil];
    [super viewDidUnload];
}
@end
