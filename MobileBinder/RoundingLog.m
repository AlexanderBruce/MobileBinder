#import "RoundingLog.h"
#import "RoundingLogManagedObject.h"
#import "Database.h"

@interface RoundingLog()
@property (nonatomic, strong) NSMutableArray *rows; //Contains dictionaries of column numbers to column contents
@property (nonatomic, strong) RoundingLogManagedObject *managedObject;
@end

@implementation RoundingLog

- (NSArray *) columnTitles
{
    if (!_columnTitles) _columnTitles = [NSArray arrayWithObjects: @"Employee Name",@"Personal Connection",@"Working Well?",@"Recognition for Others",@"Process Opprtunities",@"Tools & Equipment",@"Follow-up Actions",nil];
    return _columnTitles;
}

- (int) numberOfColumns
{
    return self.columnTitles.count;
}

- (int) numberOfRows
{
    return self.rows.count;
}

- (void) setDate:(NSDate *)date
{
    _date = date;
    self.managedObject.date = date;
}

- (void) setUnit:(NSString *)unit
{
    _unit = unit;
    self.managedObject.unit = unit;
}

- (void) setLeader:(NSString *)leader
{
    _leader = leader;
    self.managedObject.leader = leader;
}

- (void) setKeyFocus:(NSString *)keyFocus
{
    _keyFocus = keyFocus;
    self.managedObject.keyFocus = keyFocus;
}

- (void) setKeyReminders:(NSString *)keyReminders
{
    _keyReminders = keyReminders;
    self.managedObject.keyReminders = keyReminders;
}

- (int) addRow
{
    [self.rows addObject:[[NSMutableDictionary alloc] init]];
    return self.rows.count - 1;
}

- (void) deleteRow:(int)rowNumber
{
    if(rowNumber < self.rows.count && rowNumber >= 0)
    {
        [self.rows removeObjectAtIndex:rowNumber];
    }
}

- (void) storeContents: (NSString *) contents forRow: (int) rowNumber column: (int) columnNumber
{
    if(rowNumber > self.rows.count)
    {
        [NSException raise:@"Invalid row number" format:@"You have tried to store contents in a row (%d) that is strictly greater than the current number of rows",rowNumber];
    }
    if(rowNumber == self.rows.count)
    {
        [self.rows addObject:[[NSMutableDictionary alloc] init]];
    }
    NSMutableDictionary *rowDictionary = [self.rows objectAtIndex:rowNumber];
    [rowDictionary setObject:contents forKey:[NSNumber numberWithInt: columnNumber]];
    self.managedObject.contents = self.rows;
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
    [database saveToURL:database.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){}];
}


- (id) initWithManagedObject: (RoundingLogManagedObject *) managedObject
{
    if(self = [super init])
    {
        self.rows = [[NSMutableArray alloc] init];
        
        self.date = (managedObject.date) ? managedObject.date : nil;
        self.unit = (managedObject.unit) ? managedObject.unit : @"";
        self.leader = (managedObject.leader) ? managedObject.leader : @"";
        self.keyFocus = (managedObject.keyFocus) ? managedObject.keyFocus : @"";
        self.keyReminders = (managedObject.keyReminders) ? managedObject.keyReminders : @"";
        
        self.managedObject = managedObject;
    }
    return self;
}
@end
