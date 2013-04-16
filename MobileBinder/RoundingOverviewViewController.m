#import "RoundingOverviewViewController.h"
#import "RoundingDetailsViewController.h"
#import "RoundingModel.h"
#import "OutlinedLabel.h"
#import <MessageUI/MFMailComposeViewController.h>


#define ROUNDING_DETAILS_SEGUE @"roundingDetailsSegue"

@interface RoundingOverviewViewController () <UIActionSheetDelegate, UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) MFMailComposeViewController *mailer;
@end

@implementation RoundingOverviewViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[RoundingDetailsViewController class]])
    {
        RoundingDetailsViewController *dest = segue.destinationViewController;
        dest.log = self.log;
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if(!result == MFMailComposeResultCancelled)
    {
        [self.mailer dismissViewControllerAnimated:YES completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else
    {
        [self.mailer dismissViewControllerAnimated:YES completion:^{}];
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
    [self.scrollView endEditing:YES];
    [self saveDataIntoLog];
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
    [self performSegueWithIdentifier:ROUNDING_DETAILS_SEGUE sender:self];
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

- (void) saveDataIntoLog
{
    //ABSTRACT
    [NSException raise:@"Override Error" format:@"Method %@ must be overidden in class %@",NSStringFromSelector(_cmd),self.class];
}

- (IBAction)sharePressed:(UIBarButtonItem *)sender
{
    [self saveDataIntoLog];
    self.mailer = [self.model generateRoundingDocumentFor:self.log];
    self.mailer.mailComposeDelegate = self;
    [self presentModalViewController:self.mailer animated:YES];
}




@end
