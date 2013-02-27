#import <Foundation/Foundation.h>

@protocol RoundingModelDelegate <NSObject>

- (void) doneRetrievingRoundingLogs;

@end

@interface RoundingModel : NSObject
@property (nonatomic, weak) id<RoundingModelDelegate> delegate;

- (void) fetchRoundingLogsForFutureUse;

- (NSArray *) getRoundingLogs;

@end
