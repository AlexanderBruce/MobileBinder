#import "Database.h"

#define DATABASE_PATH @"Database106"

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
    @synchronized([Database class])
    {
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
    }
}

+ (void) saveDatabase
{
    [database saveToURL:database.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
    }];
}

+ (void) saveDatabaseWithCompletion: (void (^) (void)) block
{
    dispatch_queue_t callerQueue = dispatch_get_current_queue();
    dispatch_retain(callerQueue);

    [database saveToURL:database.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        dispatch_async(callerQueue, ^{
            block();
            dispatch_release(callerQueue);
        });
    }];
}

+ (void) runBlock:(void (^)())block{
    NSLog(@"Thread 2 = %@",[NSThread currentThread]);
	block();
}


@end
