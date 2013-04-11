#import "AttendanceModel.h"
#import "EmployeeRecord.h"
#import "EmployeeRecordManagedObject.h"
#import "Database.h"
#import "EmployeeAutopopulator.h"


@interface AttendanceModel() <DatabaseDelegate>
@property (nonatomic, strong) UIManagedDocument *database;
@property (nonatomic, strong) NSMutableArray *employeeRecords;
@property (nonatomic, strong) NSMutableArray *filteredRecords;
@property (nonatomic) BOOL usingFilter;
@end

@implementation AttendanceModel

- (void) fetchEmployeeRecordsFromDatabase
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Fetch notifications
        NSFetchRequest *fetchRequest = [NSFetchRequest new];
        fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([EmployeeRecordManagedObject class]) inManagedObjectContext:self.database.managedObjectContext];
        
        NSArray *recordManagedObjects = [self.database.managedObjectContext executeFetchRequest: fetchRequest error: nil];
        self.employeeRecords = [[NSMutableArray alloc] init];
        for (EmployeeRecordManagedObject *currentManagedObject in recordManagedObjects)
        {
            EmployeeRecord *emp = [[EmployeeRecord alloc] initWithManagedObject:currentManagedObject];
            [self.employeeRecords addObject:emp];
        }
        [self sortEmployeeRecords];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isInitialized = YES;
            [self.delegate doneRetrievingEmployeeRecords];
        });
    });
}

- (void) sortEmployeeRecords
{
    self.employeeRecords = [[self.employeeRecords sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(EmployeeRecord *)a lastName];
        NSString *second = [(EmployeeRecord *)b lastName];
        NSComparisonResult lastNameResult = [first compare:second];
        if(lastNameResult != NSOrderedSame) return lastNameResult;
        first = [(EmployeeRecord *)a firstName];
        second = [(EmployeeRecord *)b firstName];
        return [first compare:second];
    }] mutableCopy];
}

- (void) addEmployeeRecord: (EmployeeRecord *) record
{
    if(![self recordExistsByID:record])
    {
        [self.employeeRecords addObject:record];
        EmployeeRecordManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass([EmployeeRecordManagedObject class]) inManagedObjectContext:self.database.managedObjectContext];
        managedObject.firstName = record.firstName;
        managedObject.lastName = record.lastName;
        managedObject.department = record.department;
        managedObject.unit = record.unit;
        managedObject.idNum = record.idNum;
        record.myManagedObject = managedObject;
        [self sortEmployeeRecords];
    }
}

- (void) addEmployeesWithSupervisorID: (NSString *) idNum
{
    EmployeeAutopopulator *autopopulator = [[EmployeeAutopopulator alloc] init];
    NSSet *newEmployees = [autopopulator employeesForManagerID:idNum];
    for (EmployeeRecord *record in newEmployees)
    {
        [self addEmployeeRecord:record];   
    }
}

- (void) deleteEmployeeRecord: (EmployeeRecord *) record
{
    [record deleteFromDatabase:[Database getInstance]];
    [self.employeeRecords removeObject:record];
    [self.filteredRecords removeObject:record];
}

- (void) clearEmployeeRecords
{
    [self clearEmployeeRecordsbySupervisorID:@"##"];
}

- (void) clearEmployeeRecordsbySupervisorID: (NSString *)idNum
{
    NSArray *employees = [self getEmployeeRecords];
    for (EmployeeRecord *emp in employees)
    {
        if ([emp.idNum isEqualToString:idNum] || [@"##" isEqualToString:idNum])
        {
            [self deleteEmployeeRecord:emp];
        }
    }
}

- (void) filterEmployeesByString: (NSString *) filterString
{
    self.usingFilter = YES;
    self.filteredRecords = [[NSMutableArray alloc] init];
    NSMutableArray *filterArray = (NSMutableArray *)[[filterString componentsSeparatedByString:@" "] mutableCopy];
    [filterArray removeObject:@""];
    for (EmployeeRecord *currentRecord in self.employeeRecords)
    {
        BOOL matchesFilter = YES;
        for (NSString *currentFilter in filterArray)
        {
            NSRange firstRange = [currentRecord.firstName rangeOfString:currentFilter options:NSCaseInsensitiveSearch];
            NSRange lastRange = [currentRecord.lastName rangeOfString:currentFilter options:NSCaseInsensitiveSearch];
            NSRange departmentRange = [currentRecord.department rangeOfString:currentFilter options:NSCaseInsensitiveSearch];
            NSRange unitRange = [currentRecord.unit rangeOfString:currentFilter options:NSCaseInsensitiveSearch];
            if(firstRange.location == NSNotFound && lastRange.location == NSNotFound && departmentRange.location == NSNotFound && unitRange.location == NSNotFound)
            {
                matchesFilter = NO;
                break;
            }
        }
        if(matchesFilter) [self.filteredRecords addObject:currentRecord];
    }
}

- (BOOL) recordExistsByName:(EmployeeRecord *)employeeRecord
{
    BOOL ret = NO;
    NSString *wholeName = [NSString stringWithFormat:@"%@ %@",employeeRecord.firstName, employeeRecord.lastName];
    for(EmployeeRecord *emp in self.employeeRecords){
        if ([wholeName isEqualToString:[NSString stringWithFormat:@"%@ %@", emp.firstName, emp.lastName]]) {
            ret = YES;
            break;
        }
    }
    return ret;

}

- (BOOL) recordExistsByID:(EmployeeRecord *)employeeRecord
{
    BOOL ret = NO;
    for(EmployeeRecord *emp in self.employeeRecords){
        NSLog(@"New %@",employeeRecord.idNum);
        NSLog(@"Old %@",emp.idNum);
        if ([employeeRecord.idNum isEqualToString: emp.idNum])
        {
            NSLog(@"EQUAL!!!");
            ret = YES;
            break;
        }
    }
    return ret;
}

- (void) stopFilteringEmployees
{
    self.usingFilter = NO;
}

#pragma mark - DatabaseDelegate
- (void) obtainedDatabase:(UIManagedDocument *)database
{
    self.database = database;
    [self fetchEmployeeRecordsFromDatabase];
}

- (void) fetchEmployeeRecordsForFutureUse
{
    [Database getDatabaseWithDelegate:self];
}

- (int) getNumberOfEmployeeRecords
{
    if(self.usingFilter) return self.filteredRecords.count;
    else return self.employeeRecords.count;
}

- (NSArray *) getEmployeeRecords
{
    if(self.usingFilter) return self.filteredRecords;
    else return self.employeeRecords;
}

- (id) init
{
    if(self = [super init])
    {
        self.isInitialized = NO;
        self.database = [Database getInstance];
    }
    return self;
}

@end
