#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RoundingLogManagedObject : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSString * leader;
@property (nonatomic, retain) NSString * keyFocus;
@property (nonatomic, retain) NSString * keyReminders;
@property (nonatomic, retain) id contents;

@end
