#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
@class RoundingLog;

@interface SeniorRoundingDocumentGenerator : NSObject

- (MFMailComposeViewController *) generateRoundingDocumentFor: (RoundingLog *) log;

@end
