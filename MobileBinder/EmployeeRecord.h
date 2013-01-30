#import <Foundation/Foundation.h>
@class EmployeeRecordManagedObject;

@interface EmployeeRecord : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong, readonly) NSArray *absences;
@property (nonatomic, strong, readonly) NSArray *tardies;
@property (nonatomic, strong, readonly) NSArray *missedSwipes;

@property (nonatomic, strong) EmployeeRecordManagedObject *myManagedObject;

- (id) initWithManagedObject:(EmployeeRecordManagedObject *) managedObject;

- (void) addAbsenceForDate: (NSDate *) date;

- (void) addTardyForDate: (NSDate *) date;

- (void) addMissedSwipeForDate: (NSDate *) date;

- (void) removeAbsence: (NSDate *) date;

- (void) removeTardy: (NSDate *) date;

- (void) removeMissedSwipes: (NSDate *) date;

- (int) getNumberOfAbsencesInPastYear;

- (int) getNumberOfTardiesInPastYear;

- (int) getNumberOfMissedSwipesInPastYear;

@end
