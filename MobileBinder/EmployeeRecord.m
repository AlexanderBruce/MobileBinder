#import "EmployeeRecord.h"
#import "EmployeeRecordManagedObject.h"

@interface EmployeeRecord()
@property (nonatomic, strong) EmployeeRecordManagedObject *myManagedObject;
@end

@implementation EmployeeRecord

- (void) saveInContext: (NSManagedObjectContext *) context
{
    if(!self.myManagedObject)
    {
        self.myManagedObject = [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass([EmployeeRecordManagedObject class]) inManagedObjectContext:self.database.managedObjectContext];
    }
    self.myManagedObject.firstName = self.firstName;
    self.myManagedObject.lastName = self.lastName;
    self.myManagedObject.absences = self.absences;
    self.myManagedObject.tardies = self.tardies;
    self.myManagedObject.other = self.other;
}

- (void) addAbsenceForDate: (NSDate *) date
{
    
}

- (void) addTardyForDate: (NSDate *) date
{
    
}

- (void) addOtherForDate: (NSDate *) date
{
    
}

- (int) getNumberOfAbsencesInPastYear
{
    return self.absences.count;
}

- (int) getNumberOfTardiesInPastYear
{
    return self.tardies.count;
}

- (int) getNumberOfOtherInPastYear
{
    return self.other.count;
}

- (id) initWithManagedObject:(EmployeeRecordManagedObject *)managedObject
{
    if(self = [super init])
    {
        self.firstName = managedObject.firstName;
        self.lastName = managedObject.lastName;
        self.absences = managedObject.absences;
        self.tardies = managedObject.tardies;
        self.other = managedObject.other;
        self.myManagedObject = managedObject;
    }
    return self;
}
@end
