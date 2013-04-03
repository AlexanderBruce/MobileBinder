#import "EmployeeRoundingDocumentGenerator.h"
#import "EmployeeRoundingLog.h"

#define TEMPLATE_FILE_NAME @"Employee Rounding Document Template"
#define TEMPLATE_FILE_TYPE @"rtf"
#define ROUNDING_DOCUMENT_FILE_NAME @"Employee Rounding Document.rtf"

#define TABLE_ROW @"\\clbrdrt\\brdrs\\clbrdrl\\brdrs\\clbrdrb\\brdrs\\clbrdrr\\brdrs\\cellx1657\\clbrdrt\\brdrs\\clbrdrl\\brdrs\\clbrdrb\\brdrs\\clbrdrr\\brdrs\\cellx3775\\clbrdrt\\brdrs\\clbrdrl\\brdrs\\clbrdrb\\brdrs\\clbrdrr\\brdrs\\cellx6445\\clbrdrt\\brdrs\\clbrdrl\\brdrs\\clbrdrb\\brdrs\\clbrdrr\\brdrs\\cellx9105\\clbrdrt\\brdrs\\clbrdrl\\brdrs\\clbrdrb\\brdrs\\clbrdrr\\brdrs\\cellx10811\\clbrdrt\\brdrs\\clbrdrl\\brdrs\\clbrdrb\\brdrs\\clbrdrr\\brdrs\\cellx12744\\clbrdrt\\brdrs\\clbrdrl\\brdrs\\clbrdrb\\brdrs\\clbrdrr\\brdrs\\cellx14222 %@\\intbl\\cell %@\\intbl\\cell %@\\intbl\\cell %@\\intbl\\cell %@\\intbl\\cell %@\\intbl\\cell %@\\intbl\\cell\\row"

@interface EmployeeRoundingDocumentGenerator()
@property (nonatomic, strong) EmployeeRoundingLog *log;
@end

@implementation EmployeeRoundingDocumentGenerator

- (NSString *) getTemplate
{
    NSString* templatePath = [[NSBundle mainBundle] pathForResource:TEMPLATE_FILE_NAME
                                                             ofType:TEMPLATE_FILE_TYPE];
    NSString *templateContents = [NSString stringWithContentsOfFile:templatePath
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    return templateContents;
}

- (NSString *) writeDocumentUsingTemplate: (NSString *) template
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",
                          documentsDirectory,ROUNDING_DOCUMENT_FILE_NAME];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    NSString *employeeName = self.log.employeeName;
    NSString *unit = self.log.unit;
    NSString *leader = self.log.leader;
    NSString *keyFocus = self.log.keyFocus;
    NSString *keyReminders = self.log.keyReminders;
    
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
    template = [NSString stringWithFormat:template, employeeName, unit, leader, keyFocus, keyReminders, tableTemplate];
    
    NSRange range = NSMakeRange(0, [logContents count]);
    NSMutableData* data = [NSMutableData dataWithLength: sizeof(id) * [logContents count]];
    
    [logContents getObjects: (__unsafe_unretained id *)data.mutableBytes range:range];
    
    //Add info to table
    NSString* completeFile = [[NSString alloc] initWithFormat: template  arguments: data.mutableBytes];
    //    NSString *completeFile = [NSString stringWithFormat:template,@"Hi",@"Joe",@"Bob",@"SMith",@"Mary",@"Mad"];
    
    [[completeFile dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
    return ROUNDING_DOCUMENT_FILE_NAME;
}

- (NSString *) getSubject
{
    return @"Employee Rounding Log";
}

- (NSString *) getBody
{
    return [NSString stringWithFormat:@"This rounding log has been generated for your convenience."];
}




@end
