#import <Foundation/Foundation.h>
@class EmployeeRecord;

@protocol AttendanceModelDelegate <NSObject>

- (void) doneRetrievingEmployeeRecords;

@end

@interface AttendanceModel : NSObject
@property (nonatomic, weak) id<AttendanceModelDelegate> delegate;

- (void) addEmployeeRecord: (EmployeeRecord *) record;

- (void) deleteEmployeeRecord: (EmployeeRecord *) record;

- (void) clearEmployeeRecords;

- (void) clearEmployeeRecordsbySupervisorID: (NSString *)idNum;

- (void) fetchEmployeeRecordsForFutureUse;

- (void) addEmployeesWithSupervisorID: (NSString *) idNum;

- (int) getNumberOfEmployeeRecords;

- (NSArray *) getEmployeeRecords;

- (void) filterEmployeesByString: (NSString *) filterString;

- (void) stopFilteringEmployees;

- (BOOL) recordExistsByName: (EmployeeRecord *) employeeRecord;

- (BOOL) recordExistsByID: (EmployeeRecord *) employeeRecord;



@end
