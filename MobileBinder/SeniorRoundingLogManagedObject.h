#import <CoreData/CoreData.h>
#import "RoundingLogManagedObjectProtocol.h"

/*
 *  The CoreData object that backs a SeniorRoundingLog
 */
@interface SeniorRoundingLogManagedObject : NSManagedObject <RoundingLogManagedObjectProtocol>

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) id contents;

@end
