#import "SeniorRoundingDocumentGenerator.h"
#import "SeniorRoundingLog.h"
#import "Constants.h"

#define TEMPLATE_FILE_NAME @"Senior Rounding Document Template"
#define TEMPLATE_FILE_TYPE @"rtf"
#define ROUNDING_DOCUMENT_FILE_NAME @"Senior Rounding Document.rtf"

#define TABLE_PREFACE @"{\\rtf1\\ansi\\deff0\\trowd\\trgaph144"
#define TABLE_ROW @"\\clbrdrt\\brdrs\\clbrdrl\\brdrs\\clbrdrb\\brdrs\\clbrdrr\\brdrs\\cellx2070\\clbrdrt\\brdrs\\clbrdrl\\brdrs\\clbrdrb\\brdrs\\clbrdrr\\brdrs\\cellx4248\\clbrdrt\\brdrs\\clbrdrl\\brdrs\\clbrdrb\\brdrs\\clbrdrr\\brdrs\\cellx6426\\clbrdrt\\brdrs\\clbrdrl\\brdrs\\clbrdrb\\brdrs\\clbrdrr\\brdrs\\cellx8604\\clbrdrt\\brdrs\\clbrdrl\\brdrs\\clbrdrb\\brdrs\\clbrdrr\\brdrs\\cellx10782\\clbrdrt\\brdrs\\clbrdrl\\brdrs\\clbrdrb\\brdrs\\clbrdrr\\brdrs\\cellx12960 %@\\intbl\\cell %@\\intbl\\cell %@\\intbl\\cell %@\\intbl\\cell %@\\intbl\\cell %@\\intbl\\cell\\row"
#define TABLE_EPILOGUE @"}"


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
    
    int numColumns = self.log.numberOfColumns;
    int numRows = self.log.numberOfRows;
    NSMutableArray *logContents = [[NSMutableArray alloc] init];
    for(int r = 0; r < numRows; r++)
    {
        for(int c = 0; c < numColumns; c++)
        {
            [logContents addObject:[self.log contentsForRow:r column:c]];
        }
    }
    NSMutableString *tableTemplate = [TABLE_PREFACE mutableCopy];
    for (int i = 0; i < numRows; i++)
    {
        [tableTemplate appendString:TABLE_ROW];
    }
    [tableTemplate appendString:TABLE_EPILOGUE];
    
    //Add general info and tableTemplate
    template = [NSString stringWithFormat:template, date, unit, name, tableTemplate];
    
    NSRange range = NSMakeRange(0, [logContents count]);
    NSMutableData* data = [NSMutableData dataWithLength: sizeof(id) * [logContents count]];
    
    [logContents getObjects: (__unsafe_unretained id *)data.mutableBytes range:range];
    
    //Add info to table
    NSString* completeFile = [[NSString alloc] initWithFormat: template  arguments: data.mutableBytes];
//    NSString *completeFile = [NSString stringWithFormat:template,@"Hi",@"Joe",@"Bob",@"SMith",@"Mary",@"Mad"];
    
    [[completeFile dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
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
