#import "EmployeeRoundingLog.h"
#import "EmployeeRoundingLogManagedObject.h"

@interface EmployeeRoundingLog()
@property (nonatomic, strong) NSArray *columnTitles;
@property (nonatomic, strong) EmployeeRoundingLogManagedObject *managedObject;
@end

@implementation EmployeeRoundingLog

- (NSArray *) getColumnTitles
{
    if (!_columnTitles) _columnTitles = [NSArray arrayWithObjects: @"Date",@"Personal Connection",@"Working Well?",@"Recognition for Others",@"Process Opportunities",@"Tools & Equipment",@"Follow-up Actions",nil];
    return _columnTitles;
}

- (void) setEmployeeName:(NSString *)employeeName
{
    _employeeName = employeeName;
    self.managedObject.employeeName = _employeeName;
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
        self.employeeName = (managedObject.employeeName) ? managedObject.employeeName : @"";
        self.unit = (managedObject.unit) ? managedObject.unit : @"";
        self.leader = (managedObject.leader) ? managedObject.leader : @"";
        self.keyFocus = (managedObject.keyFocus) ? managedObject.keyFocus : @"";
        self.keyReminders = (managedObject.keyReminders) ? managedObject.keyReminders : @"";
        
        self.managedObject = managedObject;
    }
    return self;
}


@end
