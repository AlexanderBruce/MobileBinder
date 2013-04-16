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

- (void) discardChanges
{
    self.employeeName = self.managedObject.employeeName;
    self.unit = self.managedObject.unit;
    self.leader = self.managedObject.leader;
    self.keyFocus = self.managedObject.keyFocus;
    self.keyReminders = self.managedObject.keyReminders;
    [super discardChanges];
}

- (void) saveLogWithCompletition:(void (^)(void))block
{
    self.managedObject.employeeName = self.employeeName;
    self.managedObject.unit = self.unit;
    self.managedObject.leader = self.leader;
    self.managedObject.keyFocus = self.keyFocus;
    self.managedObject.keyReminders = self.keyReminders;
    [super saveLogWithCompletition:block];
}

- (void) setEmployeeName:(NSString *)employeeName
{
    _employeeName = employeeName;
    self.saved = NO;
}

- (void) setUnit:(NSString *)unit
{
    _unit = unit;
    self.saved = NO;
}

- (void) setLeader:(NSString *)leader
{
    _leader = leader;
    self.saved = NO;
}

- (void) setKeyFocus:(NSString *)keyFocus
{
    _keyFocus = keyFocus;
    self.saved = NO;
}

- (void) setKeyReminders:(NSString *)keyReminders
{
    _keyReminders = keyReminders;
    self.saved = NO;
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
