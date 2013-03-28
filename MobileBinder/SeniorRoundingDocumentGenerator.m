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
    int numberOfColumns = [self.log getColumnTitles].count;
    NSString *v00 = [self.log contentsForRow:0 column:0];
    NSString *v01 = [self.log contentsForRow:0 column:1];
    NSString *v02 = [self.log contentsForRow:0 column:2];
    NSString *v03 = [self.log contentsForRow:0 column:3];
    NSString *v04 = [self.log contentsForRow:0 column:4];
    NSString *v05 = [self.log contentsForRow:0 column:5];
    NSString *v10 = [self.log contentsForRow:1 column:0];
    NSString *v11 = [self.log contentsForRow:1 column:1];
    NSString *v12 = [self.log contentsForRow:1 column:2];
    NSString *v13 = [self.log contentsForRow:1 column:3];
    NSString *v14 = [self.log contentsForRow:1 column:4];
    NSString *v15 = [self.log contentsForRow:1 column:5];
    NSString *v20 = [self.log contentsForRow:2 column:0];
    NSString *v21 = [self.log contentsForRow:2 column:1];
    NSString *v22 = [self.log contentsForRow:2 column:2];
    NSString *v23 = [self.log contentsForRow:2 column:3];
    NSString *v24 = [self.log contentsForRow:2 column:4];
    NSString *v25 = [self.log contentsForRow:2 column:5];

    
    NSString *contents = [NSString stringWithFormat:template,date,unit,name,v00,v01,v02,v03,v04,v05,v10,v11,v12,v13,v14,v15,v20,v21,v22,v23,v24,v25];
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
