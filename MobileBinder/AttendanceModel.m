#import "AttendanceModel.h"
#import "EmployeeRecord.h"
#import "EmployeeRecordManagedObject.h"
#import "Database.h"


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
            [self.employeeRecords addObject:[[EmployeeRecord alloc] initWithManagedObject:currentManagedObject]];
        }
        [self sortEmployeeRecords];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate doneRetrievingEmployeeRecords];
        });
    });
}

- (void) sortEmployeeRecords
{
    self.employeeRecords = [[self.employeeRecords sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(EmployeeRecord *)a lastName];
        NSString *second = [(EmployeeRecord *)b lastName];
        return [first compare:second];
    }] mutableCopy];
}

- (void) addEmployeeRecord: (EmployeeRecord *) record
{
    [self.employeeRecords addObject:record];
    EmployeeRecordManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass([EmployeeRecordManagedObject class]) inManagedObjectContext:self.database.managedObjectContext];
    managedObject.firstName = record.firstName;
    managedObject.lastName = record.lastName;
    record.myManagedObject = managedObject;
    [self sortEmployeeRecords];
    [Database saveAttendanceDatabase];
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
            if(firstRange.location == NSNotFound && lastRange.location == NSNotFound)
            {
                matchesFilter = NO;
                break;
            }
        }
        if(matchesFilter) [self.filteredRecords addObject:currentRecord];
    }
}

- (void) stopFilteringEmployees
{
    self.usingFilter = NO;
}

#pragma mark - DatabaseDelegate
- (void) obtainedDatabse:(UIManagedDocument *)database
{
    self.database = database;
    [self fetchEmployeeRecordsFromDatabase];
}

- (void) fetchEmployeeRecordsForFutureUse
{
    [Database getAttendanceDatabaseWithDelegate:self];
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

@end
