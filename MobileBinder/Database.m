#import "Database.h"

#define DATABASE_PATH @"Database60"

@interface Database()
@end

@implementation Database

static UIManagedDocument *database;

+ (UIManagedDocument *) getInstance
{
    return database;
}

+ (void) getDatabaseWithDelegate: (id<DatabaseDelegate>) delegate
{
    NSLog(@"Getting database");
    if(database)
    {
        [delegate obtainedDatabase:database];
        return;
    }
        
    NSURL *dataBaseURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    dataBaseURL = [dataBaseURL URLByAppendingPathComponent:DATABASE_PATH];
    database = [[UIManagedDocument alloc] initWithFileURL:dataBaseURL];
    
    //If the database does not exist, create it
    if (![[NSFileManager defaultManager] fileExistsAtPath:[database.fileURL path]])
    {
        [database saveToURL:database.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
         {
             [delegate obtainedDatabase:database];
         }];
    }
    //If the database exists on disk but is not open, then open it
    else if (database.documentState == UIDocumentStateClosed)
    {
        [database openWithCompletionHandler:^(BOOL success)
         {
             [delegate obtainedDatabase:database];
         }];
    }
    //If the database exists on disk and is open
    else if (database.documentState == UIDocumentStateNormal)
    {
        [delegate obtainedDatabase:database];
    }
    NSLog(@"Done getting database");
}

+ (void) saveDatabase
{
    [database saveToURL:database.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
    }];
}

+ (void) saveDatabaseWithCompletion: (void (^) (void)) block
{
    [database saveToURL:database.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        block();
    }];
}


@end
