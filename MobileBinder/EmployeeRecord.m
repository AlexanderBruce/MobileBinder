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
    self.myManagedObject.absences = [self.mutableAbsences copy];
}

- (void) addTardyForDate: (NSDate *) date
{
    [self.mutableTardies addObject:date];
    self.myManagedObject.tardies = [self.mutableTardies copy];
}

- (void) addMissedSwipeForDate: (NSDate *) date
{
    [self.mutableMissedSwipes addObject:date];
    self.myManagedObject.missedSwipes = [self.mutableMissedSwipes copy];
}

- (void) removeAbsence: (NSDate *) date
{
    [self.mutableAbsences removeObject:date];
    self.myManagedObject.absences = [self.mutableAbsences copy];
}

- (void) removeTardy: (NSDate *) date
{
    [self.mutableTardies removeObject:date];
    self.myManagedObject.tardies = [self.mutableTardies copy];
}

- (void) removeMissedSwipes: (NSDate *) date
{
    [self.mutableMissedSwipes removeObject:date];
    self.myManagedObject.missedSwipes = [self.mutableMissedSwipes copy];
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

- (int) getNextAbsenceLevel
{
    int absences = [self getNumberOfAbsencesInPastYear];
    if(absences < LEVEL_1_ABSENCE_THRESHOLD) return 1;
    else if(absences < LEVEL_2_ABSENCE_THRESHOLD) return 2;
    else return 3;
}

- (int) getNextTardyLevel
{
    int tardies = [self getNumberOfTardiesInPastYear];
    if(tardies < LEVEL_1_TARDY_THRESHOLD) return 1;
    else if(tardies < LEVEL_2_TARDY_THRESHOLD) return 2;
    else return 3;
}

- (int) getNextMissedSwipeLevel
{
    int swipes = [self getNumberOfMissedSwipesInPastYear];
    if(swipes < LEVEL_1_SWIPE_THRESHOLD) return 1;
    else if(swipes < LEVEL_2_SWIPE_THRESHOLD) return 2;
    else return 3;
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
