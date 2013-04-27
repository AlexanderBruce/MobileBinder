#import <Foundation/Foundation.h>

/*
 *  Retrieves a collection of employees who have a specific manager
 */
@interface EmployeeAutopopulator : NSObject

/*
 *  Returns a set of EmployeeRecords for employees who have a manager with a given ID
 */
- (NSSet *) employeesForManagerID: (NSString *) idNum;

@end
