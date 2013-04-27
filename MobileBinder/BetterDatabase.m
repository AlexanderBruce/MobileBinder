/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "BetterDatabase.h"
#import <CoreData/CoreData.h>

#define DATABASE_PATH @"BetterDatabase1"

@interface BetterDatabase ()
- (void)objectsDidChange:(NSNotification *)notification;
- (void)contextDidSave:(NSNotification *)notification;
@property (strong, nonatomic) UIManagedDocument *document;
@end;

@implementation BetterDatabase

static BetterDatabase *_sharedInstance;
static dispatch_semaphore_t lockSemaphore;

//This is thread safe (dispatch_once is synchronous and synchronized)
+ (BetterDatabase *)sharedDocumentHandler
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:DATABASE_PATH];
        
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
        
        // Set our document up for automatic migrations
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        self.document.persistentStoreOptions = options;
        
        // Register for notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(objectsDidChange:)
                                                     name:NSManagedObjectContextObjectsDidChangeNotification
                                                   object:self.document.managedObjectContext];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:self.document.managedObjectContext];
        
        lockSemaphore = dispatch_semaphore_create(1);
        dispatch_retain(lockSemaphore);
    }
    return self;
}

- (void)performWithDocument:(OnDocumentReady)onDocumentReady
{
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {
        [self.document saveToURL:self.document.fileURL
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:^(BOOL success)
         {
             [self.document.managedObjectContext performBlock:^{
                 onDocumentReady(self.document);
             }];
         }];
    } else if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            [self.document.managedObjectContext performBlock:^{
            onDocumentReady(self.document);
        }];
        }];
    } else if (self.document.documentState == UIDocumentStateNormal)
    {
        [self.document.managedObjectContext performBlock:^{
            onDocumentReady(self.document);
        }];
    } else
    {
        [NSException raise:@"Database Exception" format:@"Something went wrong trying to create/open/use the database"];
    }
}

- (void) save: (UIManagedDocument *) document
{
    [self save:document withCompletion:^{}];
}

- (void) save:(UIManagedDocument *)document withCompletion:(void (^)(void))block
{
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        block();
    }];
}

- (void) lock
{

    dispatch_semaphore_wait(lockSemaphore,DISPATCH_TIME_FOREVER);
}

- (void) unlock
{
    dispatch_semaphore_signal(lockSemaphore);
//
}

- (void)objectsDidChange:(NSNotification *)notification
{
#ifdef DEBUG
//  Do something if you want
#endif
}

- (void)contextDidSave:(NSNotification *)notification
{
#ifdef DEBUG
    //  Do something if you want
#endif
}

- (void) dealloc
{
    dispatch_release(lockSemaphore);
}

@end