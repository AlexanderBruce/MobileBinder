#import "CorrectiveActionModel.h"
#import "EmployeeRecord.h"

#define TEMPLATE_FILE_NAME @"Corrective Action Notice Template"
#define TEMPLATE_FILE_TYPE @"rtf"

@implementation CorrectiveActionModel

- (void) generateCorrectiveActionDocumentFor: (EmployeeRecord *) employee forBehavior: (Behavior) behavior level: (int) level
{
    NSString *templateContents = [self getTemplateContents];
    [self writeCorrectiveActionDocumentFor:employee forBehavior:behavior level:level usingTemplate:templateContents];
    
}

- (NSString *) getTemplateContents
{
    NSString* templatePath = [[NSBundle mainBundle] pathForResource:TEMPLATE_FILE_NAME
                                                             ofType:TEMPLATE_FILE_TYPE];
    NSString *templateContents = [NSString stringWithContentsOfFile:templatePath
                                                           encoding:NSUTF8StringEncoding
                                                            error:nil];
    return templateContents;
}

- (void) writeCorrectiveActionDocumentFor: (EmployeeRecord *) employee forBehavior: (Behavior) behavior level: (int) level usingTemplate: (NSString *) template
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/discipline1.rtf",
                         documentsDirectory];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    NSString *date = [formatter stringFromDate:[NSDate date]];
    NSString *warning = (level == LEVEL_1_ID) ? @"X" : @"";
    NSString *finalWarning = (level == LEVEL_2_ID) ? @"X" : @"";
    NSString *termination = (level == LEVEL_3_ID) ? @"X" : @"";
    NSString *employeeName = [NSString stringWithFormat:@"%@ %@",employee.firstName,employee.lastName];
    NSString *department = employee.depar;
    NSString *violations = @"Absent 7 times during the current 12-month rolling calendar";
    NSString *expectedBehavior = @"Arrive promptly to your post during your designated shifts";
    NSString *futureActions = @"Further corrective actions up to and including termination";
    
    NSString *contents = [NSString stringWithFormat:contentsTemplate,warning,finalWarning,termination,date,employee,department,violations,expectedBehavior,futureActions];
    
    
    [[contents dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileName atomically:YES];

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
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"discipline1.rtf"];
        
        NSData *myData = [NSData dataWithContentsOfFile:filePath];
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Vehicle Expenses from myConsultant"];
        [mailer setToRecipients:[NSArray arrayWithObject:@"arp25@duke.edu"]];
        
        [mailer addAttachmentData:myData mimeType:@"application/msword" fileName:@"Discipline"];
        
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
    [self dismissModalViewControllerAnimated:NO];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"discipline1.rtf"];
    
    
    NSURL *rtfUrl = [NSURL URLWithString:[filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:rtfUrl];
    NSLog(@"%@",request);
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    [webView loadRequest:request];
}


@end
