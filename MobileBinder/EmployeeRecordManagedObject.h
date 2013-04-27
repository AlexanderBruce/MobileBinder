#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


/*
 *  The underlying CoreData object of an EmployeeRecord
 */
@interface EmployeeRecordManagedObject : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSString *idNum;
@property (nonatomic, copy) id absences;
@property (nonatomic, copy) id tardies;
@property (nonatomic, copy) id missedSwipes;

@end
