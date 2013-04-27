/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "RoundingOverviewViewController.h"
#import "RoundingDetailsViewController.h"
#import "RoundingModel.h"
#import "OutlinedLabel.h"
#import "RoundingLog.h"


#define ROUNDING_DETAILS_SEGUE @"roundingDetailsSegue"

@interface RoundingOverviewViewController () <UIActionSheetDelegate, UIGestureRecognizerDelegate>
@end

@implementation RoundingOverviewViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[RoundingDetailsViewController class]])
    {
        RoundingDetailsViewController *dest = segue.destinationViewController;
        dest.log = self.log;
        dest.model = self.model;
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    for (UIView *view in self.scrollView.subviews)
    {
        if([view isKindOfClass:[OutlinedLabel class]])
        {
            OutlinedLabel *label = (OutlinedLabel *) view;
            [label customize];
        }
    }
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.delegate = self;
    [self.scrollView addGestureRecognizer:gestureRecognizer];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (![[self.navigationController viewControllers] containsObject:self])
    {
        // We were removed from the navigation controller's view controller stack
        // thus, we can infer that the back button was pressed
        // Actions when next button is pressed are handled elsewhere
        [self.scrollView endEditing:YES];
        [self storeDataIntoLog];
        [self.log saveLogWithCompletition:^{}];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) keyboardWillBeHidden
{
    self.scrollView.scrollEnabled = NO;
}

- (void) hideKeyboard
{
    [self.view endEditing:YES];
}

- (IBAction)nextPressed:(id)sender
{
    [self.scrollView endEditing:YES];
    [self storeDataIntoLog];
    [self.log saveLogWithCompletition:^{
        [self performSegueWithIdentifier:ROUNDING_DETAILS_SEGUE sender:self];
    }];
}

- (IBAction)deletePressed:(id)sender
{
    [self.view endEditing:YES];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Are you sure you want to delete this rounding log?"] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
    [sheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.destructiveButtonIndex)
    {
        [self.model deleteRoundingLog: self.log];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) storeDataIntoLog
{
    //ABSTRACT
    [NSException raise:@"Override Error" format:@"Method %@ must be overidden in class %@",NSStringFromSelector(_cmd),self.class];
}




@end
