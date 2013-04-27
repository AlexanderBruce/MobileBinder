#import <Foundation/Foundation.h>

/*
 *  A CoreData object that can be used as the underlying backing of a rounding log
 */
@protocol RoundingLogManagedObjectProtocol <NSObject>

@property (nonatomic, retain) id contents;

@end
