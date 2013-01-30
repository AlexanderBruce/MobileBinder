#import "EmployeeRecord.h"
#import "EmployeeRecordManagedObject.h"

@interface EmployeeRecord()
@property (nonatomic, strong) NSMutableArray *mutableAbsences;
@property (nonatomic, strong) NSMutableArray *mutableTardies;
@property (nonatomic, strong) NSMutableArray *mutableMissedSwipes;
@end

@implementation EmployeeRecord

- (NSArray *) absences
{
    return [self.mutableAbsences copy];
}

- (NSArray *) tardies
{
    return [self.mutableTardies copy];
}

- (NSArray *) missedSwipes
{
    return [self.mutableMissedSwipes copy];
}


- (void) addAbsenceForDate: (NSDate *) date
{
    [self.mutableAbsences addObject:date];
    self.myManagedObject.absences = self.mutableAbsences;
}

- (void) addTardyForDate: (NSDate *) date
{
    [self.mutableTardies addObject:date];
    self.myManagedObject.tardies = self.mutableTardies;
}

- (void) addMissedSwipeForDate: (NSDate *) date
{
    [self.mutableMissedSwipes addObject:date];
    self.myManagedObject.missedSwipes = self.mutableMissedSwipes;
}

- (void) removeAbsence: (NSDate *) date
{
    [self.mutableAbsences removeObject:date];
    self.myManagedObject.absences = self.mutableAbsences;
}

- (void) removeTardy: (NSDate *) date
{
    [self.mutableTardies removeObject:date];
    self.myManagedObject.tardies = self.mutableTardies;
}

- (void) removeMissedSwipes: (NSDate *) date
{
    [self.mutableMissedSwipes removeObject:date];
    self.myManagedObject.missedSwipes = self.mutableMissedSwipes;
}

- (int) getNumberOfAbsencesInPastYear
{
    return self.mutableAbsences.count;
}

- (int) getNumberOfTardiesInPastYear
{
    return self.mutableTardies.count;
}

- (int) getNumberOfMissedSwipesInPastYear
{
    return self.mutableMissedSwipes.count;
}

- (id) initWithManagedObject:(EmployeeRecordManagedObject *)managedObject
{
    if(self = [super init])
    {
        self.firstName = (managedObject.firstName != nil) ? managedObject.firstName : @"";
        self.lastName = (managedObject.lastName != nil)  ? managedObject.lastName : @"";
        self.mutableAbsences = (managedObject.absences != nil) ? [managedObject.absences mutableCopy] : [[NSMutableArray alloc] init];
        self.mutableTardies = (managedObject.tardies != nil) ? [managedObject.tardies mutableCopy] : [[NSMutableArray alloc] init];
        self.mutableMissedSwipes = (managedObject.absences != nil) ? [managedObject.missedSwipes mutableCopy] : [[NSMutableArray alloc] init];
        self.myManagedObject = managedObject;
    }
    return self;
}

- (id) init
{
    if(self = [super init])
    {
        self.mutableAbsences = [[NSMutableArray alloc] init];
        self.mutableTardies = [[NSMutableArray alloc] init];
        self.mutableMissedSwipes = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
