#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
@class RoundingLog;
@class SeniorRoundingDocumentGenerator;

@protocol RoundingModelDelegate <NSObject>

- (void) doneRetrievingRoundingLogs;

@end

@interface RoundingModel : NSObject

@property (nonatomic, weak) id<RoundingModelDelegate> delegate;
@property (nonatomic) Class managedObjectClass;
@property (nonatomic) Class roundingLogClass;
@property (nonatomic, strong) SeniorRoundingDocumentGenerator *generator;

- (RoundingLog *) addNewRoundingLog;

- (void) deleteRoundingLog: (RoundingLog *) log;

- (void) fetchRoundingLogsForFutureUse;

- (NSArray *) getRoundingLogs;

- (MFMailComposeViewController *) generateRoundingDocumentFor: (RoundingLog *) log;

@end
