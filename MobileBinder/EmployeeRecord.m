#import "EmployeeRecord.h"
#import "EmployeeRecordManagedObject.h"

@interface EmployeeRecord()
@end

@implementation EmployeeRecord


- (void) addAbsenceForDate: (NSDate *) date
{
    NSMutableArray *mutable = [self.absences mutableCopy];
    [mutable addObject:date];
    self.absences = mutable;
    self.myManagedObject.absences = self.absences;
}

- (void) addTardyForDate: (NSDate *) date
{
    NSMutableArray *mutable = [self.tardies mutableCopy];
    [mutable addObject:date];
    self.tardies = mutable;
    self.myManagedObject.tardies = self.tardies;
}

- (void) addOtherForDate: (NSDate *) date
{
    NSMutableArray *mutable = [self.other mutableCopy];
    [mutable addObject:date];
    self.other = mutable;
    self.myManagedObject.other = self.other;
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
        self.firstName = (managedObject.firstName != nil) ? managedObject.firstName : @"";
        self.lastName = (managedObject.lastName != nil)  ? managedObject.lastName : @"";
        self.absences = (managedObject.absences != nil) ? managedObject.absences : [[NSMutableArray alloc] init];
        self.tardies = (managedObject.tardies != nil) ? managedObject.tardies : [[NSMutableArray alloc] init];
        self.other = (managedObject.absences != nil) ? managedObject.other : [[NSMutableArray alloc] init];
        self.myManagedObject = managedObject;
    }
    return self;
}

- (id) init
{
    if(self = [super init])
    {
        self.absences = [[NSMutableArray alloc] init];
        self.tardies = [[NSMutableArray alloc] init];
        self.other = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
