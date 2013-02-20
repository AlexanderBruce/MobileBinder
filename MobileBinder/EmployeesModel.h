#import <Foundation/Foundation.h>
@class EmployeeRecord;

@protocol EmployeesModelDelegate <NSObject>

- (void) doneRetrievingEmployeeRecords;

@end

@interface EmployeesModel : NSObject
@property (nonatomic, weak) id<EmployeesModelDelegate> delegate;

- (void) addEmployeeRecord: (EmployeeRecord *) record;

- (void) deleteEmployeeRecord: (EmployeeRecord *) record;

- (void) fetchEmployeeRecordsForFutureUse;

- (int) getNumberOfEmployeeRecords;

- (NSArray *) getEmployeeRecords;

- (void) filterEmployeesByString: (NSString *) filterString;

- (void) stopFilteringEmployees;

@end
