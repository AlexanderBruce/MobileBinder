#import "EmployeeRecord.h"
#import "EmployeeRecordManagedObject.h"

@implementation EmployeeRecord

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
    }
    return self;
}
@end
