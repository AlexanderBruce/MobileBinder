#import "RoundingDocumentGenerator.h"
#import "Constants.h"

@implementation RoundingDocumentGenerator

- (MFMailComposeViewController *) generateRoundingDocumentFor: (RoundingLog *) log
{
    self.log = log;
    NSString *template = [self getTemplate];
    NSString *filePath = [self writeDocumentUsingTemplate: template];
    NSString *subject = [self getSubject];
    NSString *body = [self getBody];
    return [self createMailViewControllerFromFile:filePath subject:subject messageBody:body];
}

-(MFMailComposeViewController *) createMailViewControllerFromFile: (NSString *) fileName subject: (NSString *) subject messageBody: (NSString *) messageBody
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
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

//ABSTRACT
- (NSString *) getTemplate
{
    [NSException raise:@"Override Error" format:@"Method %@ must be overidden in class %@",NSStringFromSelector(_cmd),self.class];
    return nil;
}

//ABSTRACT
- (NSString *) writeDocumentUsingTemplate: (NSString *) template
{
    [NSException raise:@"Override Error" format:@"Method %@ must be overidden in class %@",NSStringFromSelector(_cmd),self.class];
    return nil;
}

//ABSTRACT
- (NSString *) getSubject
{
    [NSException raise:@"Override Error" format:@"Method %@ must be overidden in class %@",NSStringFromSelector(_cmd),self.class];
    return nil;
}

//ABSTRACT
- (NSString *) getBody
{
    [NSException raise:@"Override Error" format:@"Method %@ must be overidden in class %@",NSStringFromSelector(_cmd),self.class];
    return nil;
}

@end
