#import <Foundation/Foundation.h>
@class EmployeeRecord;
@class AttendanceModel;

@interface EmployeeViewController : UIViewController

@property (nonatomic, strong) EmployeeRecord *employeeRecord;

@property (nonatomic, strong) AttendanceModel *myModel;

@end
