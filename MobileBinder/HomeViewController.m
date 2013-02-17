#import "HomeViewController.h"
#import "MarqueeLabel.h"
#import "PayrollModel.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface HomeViewController () <MFMailComposeViewControllerDelegate>
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
    [self writeToTextFile];
}

-(void) writeToTextFile
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/textfile.rtf",
                          documentsDirectory];
    //create content - four lines of text
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Hello World"];
    [str setAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:[UIFont systemFontSize]]} range:[@"Hello World" rangeOfString:@"World"]];
    
    
    //save content to the documents directory

    [self sendContent];
    
}


//Method retrieves content from documents directory and
//displays it in an alert
-(void) sendContent
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    if ([MFMailComposeViewController canSendMail])
    {
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"textfile.rtf"];
        
        NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    
        mailer.mailComposeDelegate = self;
    
        [mailer setSubject:@"Vehicle Expenses from myConsultant"];
    
        NSLog(@"|%@|",[[NSString alloc] initWithData:myData
                                           encoding:NSUTF8StringEncoding]);
        NSString *emailBody = [[NSString alloc] initWithData:myData
                                                    encoding:NSUTF8StringEncoding];
        [mailer setMessageBody:emailBody isHTML:NO];
    
        [mailer addAttachmentData:myData mimeType:@"text/plain" fileName:@"expenses"];
    
        [self presentModalViewController:mailer animated:YES];
    
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                    message:@"Your device doesn't support the composer sheet"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}
@end
