#import <Foundation/Foundation.h>
@class EmployeeRecord;
@class EmployeesModel;

@interface EmployeeViewController : UIViewController

@property (nonatomic, strong) EmployeeRecord *employeeRecord;

@property (nonatomic, strong) EmployeesModel *myModel;

@end
