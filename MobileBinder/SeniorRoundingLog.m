#import "SeniorRoundingLog.h"
#import "SeniorRoundingLogManagedObject.h"

@interface SeniorRoundingLog()
@property (nonatomic, strong) NSArray *columnTitles;
@property (nonatomic, strong) SeniorRoundingLogManagedObject *managedObject;
@end

@implementation SeniorRoundingLog

- (NSArray *) getColumnTitles
{
    if (!_columnTitles) _columnTitles = [NSArray arrayWithObjects: @"Unit Name",@"Working Well", @"Reward and Recognition", @"Improvement", @"Additional Learnings", @"Follow-Up Action", nil];
    return _columnTitles;
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

- (void) setName:(NSString *)name
{
    _name = name;
    self.managedObject.name = name;
}

- (void) setNotes:(NSString *)notes
{
    _notes = notes;
    self.managedObject.notes = notes;
}


- (id) initWithManagedObject: (SeniorRoundingLogManagedObject *) managedObject
{
    if(self = [super initWithManagedObject:managedObject])
    {        
        self.date = (managedObject.date) ? managedObject.date : [NSDate date];
        self.unit = (managedObject.unit) ? managedObject.unit : @"";
        self.name = (managedObject.name) ? managedObject.name : @"";
        self.notes = (managedObject.notes) ? managedObject.notes : @"";
        self.managedObject = managedObject;
    }
    return self;
}


@end
