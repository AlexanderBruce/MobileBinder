#import "CorrectiveActionModel.h"
#import "EmployeeRecord.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#define TEMPLATE_FILE_NAME @"Corrective Action Notice Template"
#define TEMPLATE_FILE_TYPE @"rtf"

#define CORRECTIVE_ACTION_DOCUMENT_FILE_NAME @"Corrective Action Form.rtf"

@implementation CorrectiveActionModel

- (MFMailComposeViewController *) generateCorrectiveActionDocumentFor: (EmployeeRecord *) employee forBehavior: (Behavior) behavior level: (int) level
{
    NSString *templateContents = [self getTemplateContents];
    [self writeCorrectiveActionDocumentFor:employee forBehavior:behavior level:level usingTemplate:templateContents];
    return [self createMailViewControllerForEmployee:employee];
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
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",
                         documentsDirectory,CORRECTIVE_ACTION_DOCUMENT_FILE_NAME];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    NSString *date = [formatter stringFromDate:[NSDate date]];
    NSString *warning = (level == LEVEL_1_ID) ? @"X" : @"";
    NSString *finalWarning = (level == LEVEL_2_ID) ? @"X" : @"";
    NSString *termination = (level == LEVEL_3_ID) ? @"X" : @"";
    NSString *employeeName = [NSString stringWithFormat:@"%@ %@",employee.firstName,employee.lastName];
    NSString *department = @"Human Resources";//employee.department;
    NSString *violations = [self violationForBehavior:behavior andEmployee:employee];
    NSString *expectedBehavior = [self expectedBehaviorForBehavior:behavior];
    NSString *futureActions = [self futureActionsForLevel:level];
    
    NSString *contents = [NSString stringWithFormat:template,warning,finalWarning,termination,date,employeeName,department,violations,expectedBehavior,futureActions];
    
    [[contents dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
}

- (NSString *) violationForBehavior: (Behavior) behavior andEmployee: (EmployeeRecord *) employee
{
    if(behavior == Absence)
    {
        return [NSString stringWithFormat:@"Absent %d times during the current 12-month rolling calendar",[employee getNumberOfAbsencesInPastYear]];
    }
    else if(behavior == Tardy)
    {
        return [NSString stringWithFormat:@"Tard %d times during the current 12-month rolling calendar",[employee getNumberOfTardiesInPastYear]];
    }
    else
    {
        return [NSString stringWithFormat:@"Missed %d swipes during the current 12-month rolling calendar",[employee getNumberOfMissedSwipesInPastYear]];
    }
}

- (NSString *) expectedBehaviorForBehavior: (Behavior) behavior
{
    if(behavior == Absence) return @"Arrive at your post during all of your designated shifts";
    else if(behavior == Tardy) return @"Arrive promptly at the beginning of your shifts and leave only at the designated times";
    else return @"Ensure that you swipe in at the beginning of your shift and swipe out at the end of your shift";
}

- (NSString *)futureActionsForLevel: (int) level
{
    if(level == LEVEL_1_ID) return @"Further corrective actions up to and including termination";
    else if(level == LEVEL_2_ID) return @"Termination";
    else return @"";
}

-(MFMailComposeViewController *) createMailViewControllerForEmployee: (EmployeeRecord *) employee
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:CORRECTIVE_ACTION_DOCUMENT_FILE_NAME];
        
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
        
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    
    NSString *subject = [NSString stringWithFormat:@"%@ Corrective Action Form",employee.lastName];
    mailer.subject = subject;
    NSString *messageBody = [NSString stringWithFormat:@"This corrective action notice has been auto-generated for your convenience.  Please ensure that %@ %@ recieves this in a timely fashion.",employee.firstName, employee.lastName];
    [mailer setMessageBody:messageBody isHTML:NO];
    [mailer setToRecipients:[NSArray arrayWithObject:@"arp25@duke.edu"]];
    [mailer addAttachmentData:myData mimeType:@"application/msword" fileName:subject];
    return mailer;
}



@end
