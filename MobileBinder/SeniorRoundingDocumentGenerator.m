#import "SeniorRoundingDocumentGenerator.h"
#import "SeniorRoundingLog.h"
#import "Constants.h"

#define TEMPLATE_FILE_NAME @"Senior Rounding Document Template"
#define TEMPLATE_FILE_TYPE @"rtf"
#define ROUNDING_DOCUMENT_FILE_NAME @"Senior Rounding Document.rtf"

@interface SeniorRoundingDocumentGenerator()
@property (nonatomic, strong) SeniorRoundingLog *log;

@end

@implementation SeniorRoundingDocumentGenerator

- (MFMailComposeViewController *) generateRoundingDocumentFor: (RoundingLog *) log
{
    if(![log isKindOfClass:[SeniorRoundingLog class]])
    {
        [NSException raise:@"Document Generation Error" format:@"Trying to generate a rounding document from a non senior rounding log"];
    }
    self.log = (SeniorRoundingLog *) log;
    NSString* templatePath = [[NSBundle mainBundle] pathForResource:TEMPLATE_FILE_NAME
                                                             ofType:TEMPLATE_FILE_TYPE];
    NSString *templateContents = [NSString stringWithContentsOfFile:templatePath
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    [self writeDocumentUsingTemplate: templateContents];
    NSString *subject = [NSString stringWithFormat:@"Senior Rounding Log"];
    NSString *messageBody = [NSString stringWithFormat:@"This Senior Rounding Log has been generated for your convenience."];
    return [self createMailViewControllerWithSubject:subject messageBody:messageBody];
}

- (void) writeDocumentUsingTemplate: (NSString *) template
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",
                          documentsDirectory,ROUNDING_DOCUMENT_FILE_NAME];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    NSString *date = [formatter stringFromDate:self.log.date];
    NSString *unit = self.log.unit;
    NSString *name = self.log.name;
    NSString *contents = [NSString stringWithFormat:template,date,unit,name];
    [[contents dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
}

-(MFMailComposeViewController *) createMailViewControllerWithSubject: (NSString *) subject messageBody: (NSString *) messageBody
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:ROUNDING_DOCUMENT_FILE_NAME];
    
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
