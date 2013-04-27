#import <Foundation/Foundation.h>
@class EmployeeRecord;

/*
 *  Because the employee database is open asynchronously, this delegate is called when the AttendanceModel is ready to be used
 */
@protocol AttendanceModelDelegate <NSObject>

/*
 *  Called when the asynchronous method fetchEmployeeRecordsForFutureUse has finished
 */
- (void) doneRetrievingEmployeeRecords;

@end

/*
 *  Manages connections with the employee record database
 */
@interface AttendanceModel : NSObject

/*
 *  The object that will be called when the asyncrhonous method fetchEmployeeRecordsForFutureUse has finished
 */
@property (nonatomic, weak) id<AttendanceModelDelegate> delegate;

/*
 *  Has the method fetchEmployeeRecordsForFutureUse been called and has it finished fetching employee records
 */
@property (nonatomic) BOOL isInitialized;

/*
 *  Add a new employee record to the database
 *  This does NOT save the database
 */
- (void) addEmployeeRecord: (EmployeeRecord *) record;

/*
 *  Delete an employee record from the database
 *  There is no guarantee that this will save the database
 */
- (void) deleteEmployeeRecord: (EmployeeRecord *) record;

/*
 *  I do not believe these methods are currently used
 */
- (void) clearEmployeeRecords;
- (void) clearEmployeeRecordsbySupervisorID: (NSString *)idNum;

/*
 *  Call this method to asynchronously initialize the AttendanceModel.  Once initialization has finished, the delegate is alerted
 *  You MUST explicitly call this method (init doesn't call it).  
 *  Calling other methods of this class before this method has finished will have undefined behavior
 */
- (void) fetchEmployeeRecordsForFutureUse;

/*
 *  Asynchronously imports employees who have a specific supervisor
 */
- (void) addEmployeesWithSupervisorID: (NSString *) idNum completition: (void (^) (void)) block;

/*
 *  If the AttendanceModel isInitialized, this will return the number of employee records (or number of filtered employee records, if applicable)
 */
- (int) getNumberOfEmployeeRecords;

/*
 *  If the AttendanceModel isInitialized, this will return all employee records (or number of filtered employee reords, if applicable)
 */
- (NSArray *) getEmployeeRecords;

/*
 *  Begin filtering the employee records
 */
- (void) filterEmployeesByString: (NSString *) filterString;

/*
 *  Stop filtering employee records
 *  Note, it is safe to call this method, even if you are not currently calling filtering
 */
- (void) stopFilteringEmployees;

/*
 *  If the AttendanceModel isInitialized, returns if an employee record in the model has the same first and last name
 */
- (BOOL) recordExistsByName: (EmployeeRecord *) employeeRecord;

/*
 *  If the AttendanceModel isInitialized, returns if an employee record in the model has the same idNum
 */
- (BOOL) recordExistsByID: (EmployeeRecord *) employeeRecord;



@end
