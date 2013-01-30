#import <Foundation/Foundation.h>
@class EmployeeRecord;

@protocol AttendanceModelDelegate <NSObject>

- (void) doneRetrievingEmployeeRecords;

@end

@interface AttendanceModel : NSObject
@property (nonatomic, weak) id<AttendanceModelDelegate> delegate;

- (void) addEmployeeRecord: (EmployeeRecord *) record;

- (void) fetchEmployeeRecordsForFutureUse;

- (int) getNumberOfEmployeeRecords;

- (NSArray *) getEmployeeRecords;

@end
