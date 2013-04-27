/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>

typedef void (^OnDocumentReady) (UIManagedDocument *document);

/*
 *  Interacts with a CoreData UIManagedDocument.  This class has stronger guarantees (than Database.m/h) that the UIManagedDocument will be open
 *  when it is used.  Eventually, all code throughout this project should be migrated to use this class rather than (Database.m/h)
 */
@interface BetterDatabase : NSObject

/*
 *  Obtain the singleton instance.  However, you must then call performWithDocument: in order to guarantee that the underlying
 *  CoreData database is open
 */
+ (BetterDatabase *) sharedDocumentHandler;

/*
 *  Call this method on the singleton instance in order to ensure that it is open and ready for reading & writing.  
 *  This method will open (or create) the UIManagedDocument and then call the block passed into this method (onDocumentReady)
 */
- (void)performWithDocument:(OnDocumentReady)onDocumentReady;

/*
 *  Saves the UIManagedDocument associated with this database
 */
- (void) save: (UIManagedDocument *) document;

/*
 *  Similar to save: except that it performs a completion block after the save has completed (regardless of whether it was successful or not)
 */
- (void) save: (UIManagedDocument *) document withCompletion: (void (^) (void)) block;

/*
 *  When multiple threads/queues may be trying to access the underlying UIManagedDocument, you should lock in order to ensure thread saftey
 */
- (void) lock;

/*
 *  Unlocks the underlying UIManagedDocument (see lock above).  
 *  This does NOT have to be called from the same thread/queue that locked the database
 */
- (void) unlock;

@end