#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
@class RoundingLog;


@interface RoundingDocumentGenerator : NSObject

#define TABLE_PREFACE @"{\\rtf1\\ansi\\deff0\\trowd\\trgaph144"

#define TABLE_EPILOGUE @"}"

@property (nonatomic, strong) RoundingLog *log;

- (MFMailComposeViewController *) generateRoundingDocumentFor: (RoundingLog *) log;

//ABSTRACT
- (NSString *) getTemplate;

//ABSTRACT
- (NSString *) writeDocumentUsingTemplate: (NSString *) template;

//ABSTRACT
- (NSString *) getSubject;

//ABSTRACT
- (NSString *) getBody;

@end
