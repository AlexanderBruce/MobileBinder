#import <Foundation/Foundation.h>
@class EmployeeRecordManagedObject;

@interface EmployeeRecord : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSArray *absences;
@property (nonatomic, strong) NSArray *tardies;
@property (nonatomic, strong) NSArray *other;

- (id) initWithManagedObject:(EmployeeRecordManagedObject *) managedObject;

- (void) addAbsenceForDate: (NSDate *) date;

- (void) addTardyForDate: (NSDate *) date;

- (void) addOtherForDate: (NSDate *) date;

- (int) getNumberOfAbsencesInPastYear;

- (int) getNumberOfTardiesInPastYear;

- (int) getNumberOfOtherInPastYear;

@end
