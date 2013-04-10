#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ReminderManagedObject : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * fireDate;
@property (nonatomic, retain) NSNumber * typeID;
@property (nonatomic, retain) NSNumber *uniqueID;

@end
