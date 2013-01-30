#import "Database.h"

#define DATABASE_PATH @"AttendanceDatabase2"

@interface Database()
@end

@implementation Database

static UIManagedDocument *attendanceDatabase;


+ (void) getAttendanceDatabaseWithDelegate: (id<DatabaseDelegate>) delegate
{
    if(attendanceDatabase)
    {
        [delegate obtainedDatabse:attendanceDatabase];
        return;
    }
        
    NSURL *dataBaseURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    dataBaseURL = [dataBaseURL URLByAppendingPathComponent:DATABASE_PATH];
    attendanceDatabase = [[UIManagedDocument alloc] initWithFileURL:dataBaseURL];
    
    //If the database does not exist, create it
    if (![[NSFileManager defaultManager] fileExistsAtPath:[attendanceDatabase.fileURL path]])
    {
        [attendanceDatabase saveToURL:attendanceDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
         {
             [delegate obtainedDatabse:attendanceDatabase];
         }];
    }
    //If the database exists on disk but is not open, then open it
    else if (attendanceDatabase.documentState == UIDocumentStateClosed)
    {
        [attendanceDatabase openWithCompletionHandler:^(BOOL success)
         {
             [delegate obtainedDatabse:attendanceDatabase];
         }];
    }
    //If the database exists on disk and is open
    else if (attendanceDatabase.documentState == UIDocumentStateNormal)
    {
        [delegate obtainedDatabse:attendanceDatabase];
    }
}

+ (void) saveAttendanceDatabase
{
    [attendanceDatabase saveToURL:attendanceDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {}];

}

@end
