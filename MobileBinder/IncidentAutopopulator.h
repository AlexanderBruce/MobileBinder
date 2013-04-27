#import <Foundation/Foundation.h>
@class EmployeeRecord;

/*
 *  THIS IS A DEMO CLASS
 *  Used to randomly add incidents to a collection of employees
 */
@interface IncidentAutopopulator : NSObject

- (void) populateEmployeeRecords: (NSArray *) employeeRecords;

@end
