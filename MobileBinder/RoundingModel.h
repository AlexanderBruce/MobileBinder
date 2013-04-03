#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
@class RoundingLog;
@class RoundingDocumentGenerator;

@protocol RoundingModelDelegate <NSObject>

- (void) doneRetrievingRoundingLogs;

@end

@interface RoundingModel : NSObject

@property (nonatomic, weak) id<RoundingModelDelegate> delegate;
@property (nonatomic) Class managedObjectClass;
@property (nonatomic) Class roundingLogClass;
@property (nonatomic, strong) RoundingDocumentGenerator *generator;

- (RoundingLog *) addNewRoundingLog;

- (void) deleteRoundingLog: (RoundingLog *) log;

- (void) fetchRoundingLogsForFutureUse;

- (NSArray *) getRoundingLogs;

- (MFMailComposeViewController *) generateRoundingDocumentFor: (RoundingLog *) log;

@end
