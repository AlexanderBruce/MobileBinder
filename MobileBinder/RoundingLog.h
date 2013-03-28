#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RoundingLogManagedObjectProtocol.h"

@interface RoundingLog : NSObject 

@property (nonatomic, strong)  id<RoundingLogManagedObjectProtocol> managedObject;
@property (nonatomic, readonly) int numberOfColumns;
@property (nonatomic, readonly) int numberOfRows;

//Returns the row number for the row that was just added
- (int) addRow;

//ABSTRACT
- (NSArray *) getColumnTitles;

- (void) deleteRow: (int) rowNumber;

- (NSString *) contentsForRow: (int) rowNumber column: (int) columnNumber;

- (void) storeContents: (NSString *) contents forRow: (int) rowNumber column: (int) columnNumber;

- (NSArray *) allContentsForColumn: (int) columnNumber;

- (id) initWithManagedObject: (id<RoundingLogManagedObjectProtocol> ) managedObject;

- (void) deleteFromDatabase: (UIManagedDocument *) database;

@end
