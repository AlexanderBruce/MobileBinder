#import "RoundingLog.h"
#import "EmployeeRoundingLogManagedObject.h"
#import "Database.h"
#import "RoundingLogManagedObjectProtocol.h"

@interface RoundingLog()
@property (nonatomic, strong) NSMutableArray *rows; //Contains dictionaries of column numbers to column contents
@end

@implementation RoundingLog

//ABSTRACT
- (NSArray *) getColumnTitles
{
    [NSException raise:@"Override Error" format:@"Method %@ must be overidden in class %@",NSStringFromSelector(_cmd),self.class];
    return nil;
}

- (int) numberOfColumns
{
    return [self getColumnTitles].count;
}

- (int) numberOfRows
{
    return self.rows.count;
}

- (void) discardChanges
{
    self.rows = (self.managedObject.contents) ? self.managedObject.contents : [[NSMutableArray alloc] init];
    self.saved = YES;
}

- (void) saveLogWithCompletition:(void (^)(void))block
{
    self.managedObject.contents = self.rows;
    self.saved = YES;
    [Database saveDatabaseWithCompletion:block];
}


- (int) addRow
{
    [self.rows addObject:[[NSMutableDictionary alloc] init]];
    self.saved = NO;
    return self.rows.count - 1;
}

- (void) deleteRow:(int)rowNumber
{
    if(rowNumber < self.rows.count && rowNumber >= 0)
    {
        [self.rows removeObjectAtIndex:rowNumber];
    }
    self.saved = NO;
}

- (void) storeContents: (NSString *) contents forRow: (int) rowNumber column: (int) columnNumber
{
    if(rowNumber >= self.rows.count)
    {
        [NSException raise:@"Invalid row number" format:@"You have tried to store contents in a row (%d) that is strictly greater than the current number of rows",rowNumber];
    }

    NSMutableDictionary *rowDictionary = [self.rows objectAtIndex:rowNumber];
    [rowDictionary setObject:contents forKey:[NSNumber numberWithInt: columnNumber]];
    self.saved = NO;
}

- (NSString *) contentsForRow: (int) rowNumber column: (int) columnNumber
{
    if(rowNumber >= self.rows.count) return @"";
    NSDictionary *rowDictionary = [self.rows objectAtIndex:rowNumber];
    NSString *columnContents = [rowDictionary objectForKey:[NSNumber numberWithInt:columnNumber]];
    if(!columnContents) columnContents = @"";
    return columnContents;
}

- (NSArray *) allContentsForColumn: (int) columnNumber
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSDictionary *currentRow in self.rows)
    {
        NSString *contents = [currentRow objectForKey:[NSNumber numberWithInt:columnNumber]];
        if(contents) [result addObject:contents];
        else [result addObject: @""];
    }
    return result;
}

- (void) deleteFromDatabase: (UIManagedDocument *) database
{
    if(!self.managedObject) return; //If not saved to disk, then don't need to do anything
    [database.managedObjectContext deleteObject:self.managedObject];
    self.managedObject = nil;
    self.saved = NO;
    [database saveToURL:database.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
    }];
}


- (id) initWithManagedObject: (id<RoundingLogManagedObjectProtocol> ) managedObject
{
    if(self = [super init])
    {
        self.rows = (managedObject.contents) ? managedObject.contents : [[NSMutableArray alloc] init];

        //IMPLEMENT FURTHER IN SUBCLASSES
        
        self.managedObject = managedObject;
        self.saved = YES;
    }
    return self;
}
@end
