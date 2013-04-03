#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RoundingLogManagedObjectProtocol.h"


@interface EmployeeRoundingLogManagedObject : NSManagedObject <RoundingLogManagedObjectProtocol>

@property (nonatomic, retain) NSString * employeeName;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSString * leader;
@property (nonatomic, retain) NSString * keyFocus;
@property (nonatomic, retain) NSString * keyReminders;
@property (nonatomic, retain) id contents;

@end
