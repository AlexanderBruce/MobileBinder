#import "DisciplinaryActionModel.h"
#import "EmployeeRecord.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Constants.h"

#define CORRECTIVE_ACTION_TEMPLATE_FILE_NAME @"Corrective Action Notice Template"
#define TERMINATION_PROPOSAL_TEMPLATE_FILE_NAME @"Termination Notice Template"

#define TEMPLATE_FILE_TYPE @"rtf"

#define DISCIPLINARY_ACTION_DOCUMENT_FILE_NAME @"Disciplinary Action Form.rtf"

//If any more types of documents are added, it would be useful to make this into a hierarchy with a factory
@interface DisciplinaryActionModel()
@property (nonatomic, strong) EmployeeRecord *employee;
@property (nonatomic) Behavior behavior;
@property (nonatomic) int level;
@end

@implementation DisciplinaryActionModel

- (MFMailComposeViewController *) generateDisciplinaryActionDocumentFor: (EmployeeRecord *) employee forBehavior: (Behavior) behavior level: (int) level
{
    self.employee = employee;
    self.behavior = behavior;
    self.level = level;
    if(level == LEVEL_3_ID)
    {
        return [self generateTerminationProposal];
    }
    else
    {
        return [self generateCorrectiveActionDocument];
    }
}

- (MFMailComposeViewController *) generateCorrectiveActionDocument
{
    NSString* templatePath = [[NSBundle mainBundle] pathForResource:CORRECTIVE_ACTION_TEMPLATE_FILE_NAME
                                                             ofType:TEMPLATE_FILE_TYPE];
    NSString *templateContents = [NSString stringWithContentsOfFile:templatePath
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    [self writeCorrectiveActionDocumentUsingTemplate: templateContents];
    NSString *subject = [NSString stringWithFormat:@"%@ Corrective Action Form",self.employee.lastName];
    NSString *messageBody = [NSString stringWithFormat:@"This corrective action notice has been auto-generated for your convenience.  Please ensure that %@ %@ recieves this in a timely fashion.",self.employee.firstName, self.employee.lastName];
    return [self createMailViewControllerWithSubject:subject messageBody:messageBody];
}

- (MFMailComposeViewController *) generateTerminationProposal
{
    NSString* templatePath = [[NSBundle mainBundle] pathForResource:TERMINATION_PROPOSAL_TEMPLATE_FILE_NAME
                                                             ofType:TEMPLATE_FILE_TYPE];
    NSString *templateContents = [NSString stringWithContentsOfFile:templatePath
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    [self writeTerminationProposalUsingTemplate:templateContents];
    NSString *subject = [NSString stringWithFormat:@"%@ Termination Proposal",self.employee.lastName];
    NSString *messageBody = [NSString stringWithFormat:@"This termination proposal has been auto-generated for your convenience.  Please ensure that %@ %@ recieves this in a timely fashion.",self.employee.firstName, self.employee.lastName];
    return [self createMailViewControllerWithSubject:subject messageBody:messageBody];
}

- (void) writeTerminationProposalUsingTemplate: (NSString *) template
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",
                          documentsDirectory,DISCIPLINARY_ACTION_DOCUMENT_FILE_NAME];
    
    NSString *contents = [NSString stringWithFormat:template,self.employee.firstName, self.employee.lastName];
    [[contents dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
}


- (void) writeCorrectiveActionDocumentUsingTemplate: (NSString *) template
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",
                         documentsDirectory,DISCIPLINARY_ACTION_DOCUMENT_FILE_NAME];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    NSString *date = [formatter stringFromDate:[NSDate date]];
    NSString *warning = (self.level == LEVEL_1_ID) ? @"X" : @"";
    NSString *finalWarning = (self.level == LEVEL_2_ID) ? @"X" : @"";
    NSString *termination = (self.level == LEVEL_3_ID) ? @"X" : @"";
    NSString *employeeName = [NSString stringWithFormat:@"%@ %@",self.employee.firstName,self.employee.lastName];
    NSString *department = self.employee.department;
    NSString *violations = [self violationForBehavior:self.behavior andEmployee:self.employee];
    NSString *futureActions = [self futureActionsForLevel:self.level];
    
    NSString *contents = [NSString stringWithFormat:template,warning,finalWarning,termination,date,employeeName,department,violations,futureActions];
    
    [[contents dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
}

- (NSString *) violationForBehavior: (Behavior) behavior andEmployee: (EmployeeRecord *) employee
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    if(behavior == Absence)
    {
        NSArray *absences = employee.absences;
        NSMutableString *datesString = [[NSMutableString alloc] init];
        for (NSDate *date in absences)
        {
            if(datesString.length > 0) [datesString appendString:@", "];
            [datesString appendFormat:@"%@",[formatter stringFromDate:date]];
        }
        return [NSString stringWithFormat:@"Absent %d times during the current 12-month rolling calendar: %@",[employee getNumberOfAbsencesInPastYear],datesString];
    }
    else if(behavior == Tardy)
    {
        return [NSString stringWithFormat:@"Tard %d times during the current 12-month rolling calendar",[employee getNumberOfTardiesInPastYear]];
    }
    else
    {
        NSArray *missedSwipes = employee.missedSwipes;
        NSMutableString *datesString = [[NSMutableString alloc] init];
        for (NSDate *date in missedSwipes)
        {
            if(datesString.length > 0) [datesString appendString:@", "];
            [datesString appendFormat:@"%@",[formatter stringFromDate:date]];
        }
        return [NSString stringWithFormat:@"Missed %d swipes during the current 12-month rolling calendar: %@",[employee getNumberOfMissedSwipesInPastYear]];
    }
}


- (NSString *)futureActionsForLevel: (int) level
{
    if(level == LEVEL_1_ID) return @"Final Written Warning";
    else if(level == LEVEL_2_ID) return @"Termination";
    else return @"";
}

-(MFMailComposeViewController *) createMailViewControllerWithSubject: (NSString *) subject messageBody: (NSString *) messageBody
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:DISCIPLINARY_ACTION_DOCUMENT_FILE_NAME];
        
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
        
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    
    mailer.subject = subject;
    [mailer setMessageBody:messageBody isHTML:NO];
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:MANAGER_EMAIL_KEY];
    if(email)
    {
        [mailer setToRecipients:[NSArray arrayWithObject:email]];
    }
    [mailer addAttachmentData:myData mimeType:@"application/msword" fileName:subject];
    return mailer;
}



@end
