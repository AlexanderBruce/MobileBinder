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
        
//        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//        context.parentContext = self.document.managedObjectContext.parentContext;
//        self.document.managedObjectContext = context;
        

        
//        self.document.managedObjectContext.concurrencyType = NSPrivateQueueConcurrencyType;
        
        lockSemaphore = dispatch_semaphore_create(1);
        dispatch_retain(lockSemaphore);
    }
    return self;
}

- (void)performWithDocument:(OnDocumentReady)onDocumentReady
{
//    NSLog(@"Perform with document");
//    void (^OnDocumentDidLoad)(BOOL) = ^(BOOL success) {
//        onDocumentReady(self.document);
//    };
    
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

//- (id) performWithDocumentAndReturn:(id (^)(UIManagedDocument *))onDocumentReady
//{
//    __block id returnValue;
//    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {
//        [self.document saveToURL:self.document.fileURL
//                forSaveOperation:UIDocumentSaveForCreating
//               completionHandler:^(BOOL success)
//         {
//             [self.document.managedObjectContext performBlockAndWait:^{
//                 returnValue = onDocumentReady(self.document);
//             }];
//         }];
//    } else if (self.document.documentState == UIDocumentStateClosed) {
//        [self.document openWithCompletionHandler:^(BOOL success) {
//            NSLog(@"self.doc.manobjcon = %@",self.document.managedObjectContext);
//            [self.document.managedObjectContext performBlockAndWait:^{
//                returnValue = onDocumentReady(self.document);
//            }];
//        }];
//    } else if (self.document.documentState == UIDocumentStateNormal)
//    {
//        NSLog(@"self.doc.manobjcon = %@",self.document.managedObjectContext);
//        [self.document.managedObjectContext performBlockAndWait:^{
//            returnValue = onDocumentReady(self.document);
//        }];
//    } else
//    {
//        [NSException raise:@"Database Exception" format:@"Something went wrong trying to create/open/use the database"];
//    }
//    return returnValue;
//}

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
    NSLog(@"NSManagedObjects did change.");
#endif
}

- (void)contextDidSave:(NSNotification *)notification
{
#ifdef DEBUG
    NSLog(@"NSManagedContext did save.");
#endif
}

- (void) dealloc
{
    dispatch_release(lockSemaphore);
}

@end