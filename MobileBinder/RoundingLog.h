#import <Foundation/Foundation.h>
@class RoundingLogManagedObject;

@interface RoundingLog : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *leader;
@property (nonatomic, strong) NSString *keyFocus;
@property (nonatomic, strong) NSString *keyReminders;

@property (nonatomic, strong) NSArray *columnTitles;

//Returns the row number for the row that was just added
- (int) addRow;

- (NSString *) contentsForRow: (int) rowNumber column: (int) columnNumber;

- (void) storeContents: (NSString *) contents forRow: (int) rowNumber column: (int) columnNumber;

- (NSArray *) allContentsForColumn: (int) columnNumber;

- (id) initWithManagedObject: (RoundingLogManagedObject *) managedObject;

- (void) deleteFromDatabase: (UIManagedDocument *) database;

@end
