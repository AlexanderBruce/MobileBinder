#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
@class RoundingLog;
@class RoundingDocumentGenerator;

@protocol RoundingModelDelegate <NSObject>

/*
 *  Called once the asynchronous method fetchRoundingLogsForFutureUse has finished
 */
- (void) doneRetrievingRoundingLogs;

@end

/*
 *  Manages the retrieval, adding and removing of rounding logs
 */
@interface RoundingModel : NSObject
@property (nonatomic, weak) id<RoundingModelDelegate> delegate;

/*  What type of managed object rounding logs should be retrieved from the database */
@property (nonatomic) Class managedObjectClass;

/*  What type of RoundingLogs does this model contain */
@property (nonatomic) Class roundingLogClass;

/*  The generator that will be used to create physical rounding logs */
@property (nonatomic, strong) RoundingDocumentGenerator *generator;

/*
 *  Add a new log to this model and to the database
 */
- (RoundingLog *) addNewRoundingLog;

/*
 *  Delete a log from this model and from the database
 */
- (void) deleteRoundingLog: (RoundingLog *) log;

/*
 *  Asynchronously retrieves rounding logs and then alerts the delegate
 */
- (void) fetchRoundingLogsForFutureUse;

/*
 *  If the model is initialized (fetchRoundingLogsForFutureUse has finished), this will return an
 *  array of rounding logs
 */
- (NSArray *) getRoundingLogs;

/*
 *  Attaches a physical copy of the passed-in log, to an e-mail (MFMailComposeViewController)
 */
- (MFMailComposeViewController *) generateRoundingDocumentFor: (RoundingLog *) log;

@end
