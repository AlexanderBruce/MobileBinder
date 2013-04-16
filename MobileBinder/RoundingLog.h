#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RoundingLogManagedObjectProtocol.h"

@interface RoundingLog : NSObject 

@property (nonatomic, strong)  id<RoundingLogManagedObjectProtocol> managedObject;
@property (nonatomic, readonly) int numberOfColumns;
@property (nonatomic, readonly) int numberOfRows;
@property (nonatomic) BOOL saved;

//Returns the row number for the row that was just added
- (int) addRow;

//ABSTRACT
- (NSArray *) getColumnTitles;

- (void) deleteRow: (int) rowNumber;

//Will return empty string rather than null
- (NSString *) contentsForRow: (int) rowNumber column: (int) columnNumber;

- (void) storeContents: (NSString *) contents forRow: (int) rowNumber column: (int) columnNumber;

- (NSArray *) allContentsForColumn: (int) columnNumber;

- (id) initWithManagedObject: (id<RoundingLogManagedObjectProtocol> ) managedObject;

- (void) deleteFromDatabase: (UIManagedDocument *) database;

//Implement further in subclass and then call super
- (void) discardChanges;

// Implement further in subclass and then call super
- (void) saveLogWithCompletition: (void (^)(void)) block;

@end
