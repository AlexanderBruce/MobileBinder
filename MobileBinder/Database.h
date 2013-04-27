#import <Foundation/Foundation.h>

@protocol DatabaseDelegate <NSObject>

/*
 *  Called once the underlying UIManagedDocument has been created/opened.  
 *  Note, however, that if the app goes into a background state after this method has been called, then
 *  the UIManagedDocument may no longer be open.  For this reason you should migrate to use BetterDatabase.m/h
 */
- (void) obtainedDatabase: (UIManagedDocument *) database;

@end

/*
 * THIS IS AN OUTDATED CLASS.  EVENTAULLY, ALL CODE SHOULD BE MIGRATED TO USE BetterDatabase.m/h.  
 *  This class does not provide guarantees that the underlying UIManagedDocument is open when trying to read/write from it.
 */
@interface Database : NSObject

/*
 *  Returns the singleton instance.  Note that this UIManagedDocument may be null, closed or nonexistant.  
 */
+ (UIManagedDocument *) getInstance;

/*
 *  Creates the underlying UIManagedDocument (if necessary), opens it and then calls the appropriate delegate method.  
 *  Note the issues discussed above regarding this UIManagedDocument's state
 */
+ (void) getDatabaseWithDelegate: (id<DatabaseDelegate>) delegate;

/*
 *  Saves the UIManagedDocument associated with this database
 */
+ (void) saveDatabase;

/*
 *  Similar to save: except that it performs a completion block after the save has completed (regardless of whether it was successful or not)
 */
+ (void) saveDatabaseWithCompletion: (void (^) (void)) block;

@end
