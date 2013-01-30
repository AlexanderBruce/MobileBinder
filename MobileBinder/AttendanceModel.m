#import "AttendanceModel.h"
#import "EmployeeRecord.h"
#import "EmployeeRecordManagedObject.h"

#define DATABASE_PATH @"AttendanceDatabase2"

@interface AttendanceModel()
@property (nonatomic, strong) UIManagedDocument *database;
@property (nonatomic, strong) NSMutableArray *employeeRecords;
@end

@implementation AttendanceModel

- (void) createAndOpenDatabase
{
    NSURL *dataBaseURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    dataBaseURL = [dataBaseURL URLByAppendingPathComponent:DATABASE_PATH];
    self.database = [[UIManagedDocument alloc] initWithFileURL:dataBaseURL];
    
    //If the database does not exist, create it
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.database.fileURL path]])
    {
        [self.database saveToURL:self.database.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
        {
            [self fetchEmployeeRecordsFromDatabase];
        }];
    }
    //If the database exists on disk but is not open, then open it
    else if (self.database.documentState == UIDocumentStateClosed)
    {
        [self.database openWithCompletionHandler:^(BOOL success)
        {
            [self fetchEmployeeRecordsFromDatabase];
        }];
    }
    //If the database exists on disk and is open
    else if (self.database.documentState == UIDocumentStateNormal)
    {
        [self fetchEmployeeRecordsFromDatabase];
    }
}

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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate doneRetrievingEmployeeRecords];
        });
    });
}

- (void) addEmployeeRecord: (EmployeeRecord *) record
{
    [self.employeeRecords addObject:record];
    EmployeeRecordManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass([EmployeeRecordManagedObject class]) inManagedObjectContext:self.database.managedObjectContext];
    managedObject.firstName = record.firstName;
    managedObject.lastName = record.lastName;
    [self.database saveToURL:self.database.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success)\
     {}];

}

- (void) fetchEmployeeRecordsForFutureUse
{
    [self createAndOpenDatabase];
}

- (int) getNumberOfEmployeeRecords
{
    return self.employeeRecords.count;
}

- (NSArray *) getEmployeeRecords
{
    return self.employeeRecords;
}

@end
