/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
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
    [database saveToURL:database.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        block();
    }];
}

@end
