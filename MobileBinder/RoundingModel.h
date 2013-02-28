#import <Foundation/Foundation.h>
@class RoundingLog;

@protocol RoundingModelDelegate <NSObject>

- (void) doneRetrievingRoundingLogs;

@end

@interface RoundingModel : NSObject

@property (nonatomic, weak) id<RoundingModelDelegate> delegate;

- (RoundingLog *) addNewRoundingLog;

- (void) deleteRoundingLog: (RoundingLog *) log;

- (void) fetchRoundingLogsForFutureUse;

- (NSArray *) getRoundingLogs;

@end
