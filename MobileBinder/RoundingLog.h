/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RoundingLogManagedObjectProtocol.h"

/*
 *  ABSTRACT CLASS
 *  Represents a single rounding log
 */
@interface RoundingLog : NSObject 

/*
 *  The underlying CoreData object
 */
@property (nonatomic, strong)  id<RoundingLogManagedObjectProtocol> managedObject;
@property (nonatomic, readonly) int numberOfColumns;
@property (nonatomic, readonly) int numberOfRows;

/* Has all of information in this or deleted from this rounding log been saved */
@property (nonatomic) BOOL saved;  

/*
 *  Adds a new row to this rounding log and returns the number of the row that was just added
 */
- (int) addRow;

/*
 *  ABSTRACT METHOD
 *  Subclasses should return an array of NSStrings of column titles
 */
- (NSArray *) getColumnTitles;

/*
 *  Deletes a given row number from this rounding log
 */
- (void) deleteRow: (int) rowNumber;

/*
 *  Returns the contents of a given rounding table row and column
 *  Note, will return an empty string rather than null if no data is found
 */
- (NSString *) contentsForRow: (int) rowNumber column: (int) columnNumber;

/*
 *  Stores a string in a given rounding table row and column
 */
- (void) storeContents: (NSString *) contents forRow: (int) rowNumber column: (int) columnNumber;

/*
 *  Returns an array of NSStrings of all rows of a given column
 */
- (NSArray *) allContentsForColumn: (int) columnNumber;

/*
 *  If this object has an underlying CoreData object, delete it from the given UIManagedDocument
 */
- (void) deleteFromDatabase: (UIManagedDocument *) database;

/*
 *  Remove all unsaved changes from this rounding log
 *  Subclasses should implement this further and then call super
 */
- (void) discardChanges;

/*
 *  Save this log into the underlying CoreData managed object
 *  Subclasses should implement this further and then call super
 */
- (void) saveLogWithCompletition: (void (^)(void)) block;

/*
 *  Initialize this object using data from an underlying CoreData object
 */
- (id) initWithManagedObject: (id<RoundingLogManagedObjectProtocol> ) managedObject;

@end
