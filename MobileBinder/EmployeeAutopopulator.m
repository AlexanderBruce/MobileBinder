#import "EmployeeAutopopulator.h"
#import "EmployeeRecord.h"
#define EMPLOYEE_DATA_FILE @"employee_data.csv"

@implementation EmployeeAutopopulator

- (NSSet *) employeesForManagerID: (NSString *) idNum
{
    NSString* path = [[NSBundle mainBundle] pathForResource:EMPLOYEE_DATA_FILE ofType:@""];
    NSArray* lines = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]
                      componentsSeparatedByString:@"\r"];
    BOOL *isMangersEmployees = NO;
    NSMutableSet* employees = [[NSMutableSet alloc] init];
    for(NSString* line in lines)
    {
        NSArray* lineValues = [line componentsSeparatedByString:@","];
        NSString *firstValue = [lineValues objectAtIndex:0];
        if ([firstValue isEqualToString:idNum])
        {
            isMangersEmployees = YES;
        }
        else if ((![firstValue isEqualToString:@""]) && (![firstValue isEqualToString:idNum]))
        {
            isMangersEmployees = NO;
        }
        //This condition might short-circuit at lineValues.count > 22
        else if(isMangersEmployees && [firstValue isEqualToString:@""] && lineValues.count > 22 && ![[lineValues objectAtIndex:22] isEqualToString:@""])
        {
            NSArray* employeeName = [[lineValues objectAtIndex:22]componentsSeparatedByString:@" "];
            EmployeeRecord *employee = [[EmployeeRecord alloc]init];
            [employee setFirstName:[[employeeName objectAtIndex:0]capitalizedString]];
            [employee setLastName:[[employeeName lastObject]capitalizedString]];
            [employee setIdNum:[lineValues objectAtIndex:22]];
            [employees addObject:employee];
        }
    }
    return employees;
    
}

@end
