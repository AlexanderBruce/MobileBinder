#import "EmployeeRoundingLog.h"
#import "EmployeeRoundingLogManagedObject.h"

@interface EmployeeRoundingLog()
@property (nonatomic, strong) NSArray *columnTitles;
@property (nonatomic, strong) EmployeeRoundingLogManagedObject *managedObject;
@end

@implementation EmployeeRoundingLog

- (NSArray *) getColumnTitles
{
    if (!_columnTitles) _columnTitles = [NSArray arrayWithObjects: @"Employee Name",@"Personal Connection",@"Working Well?",@"Recognition for Others",@"Process Opprtunities",@"Tools & Equipment",@"Follow-up Actions",nil];
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

- (id) initWithManagedObject: (EmployeeRoundingLogManagedObject *) managedObject
{
    if(self = [super initWithManagedObject:managedObject])
    {        
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
