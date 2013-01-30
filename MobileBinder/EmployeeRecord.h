#import <Foundation/Foundation.h>
@class EmployeeRecordManagedObject;

@interface EmployeeRecord : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSArray *absences;
@property (nonatomic, strong) NSArray *tardies;
@property (nonatomic, strong) NSArray *other;

- (id) initWithManagedObject:(EmployeeRecordManagedObject *) managedObject;

- (int) getNumberOfAbsencesInPastYear;

- (int) getNumberOfTardiesInPastYear;

- (int) getNumberOfOtherInPastYear;

@end
