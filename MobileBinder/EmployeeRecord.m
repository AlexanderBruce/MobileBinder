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

- (int) addAbsenceForDate: (NSDate *) date
{
    [self.mutableAbsences addObject:date];
    self.myManagedObject.absences = self.mutableAbsences;
    int count = [self getNumberOfAbsencesInPastYear];
    if(count == LEVEL_1_ABSENCE_THRESHOLD) return LEVEL_1_ID;
    else if(count == LEVEL_2_ABSENCE_THRESHOLD) return LEVEL_2_ID;
    else if(count == LEVEL_3_ABSENCE_THRESHOLD) return LEVEL_3_ID;
    else return -1;
}

- (int) addTardyForDate: (NSDate *) date
{
    [self.mutableTardies addObject:date];
    self.myManagedObject.tardies = self.mutableTardies;
    int count = [self getNumberOfTardiesInPastYear];
    if(count == LEVEL_1_TARDY_THRESHOLD) return LEVEL_1_ID;
    else if(count == LEVEL_2_TARDY_THRESHOLD) return LEVEL_2_ID;
    else if(count == LEVEL_3_TARDY_THRESHOLD) return LEVEL_3_ID;
    else return -1;
}

- (int) addMissedSwipeForDate: (NSDate *) date
{
    [self.mutableMissedSwipes addObject:date];
    self.myManagedObject.missedSwipes = self.mutableMissedSwipes;
    int count = [self getNumberOfMissedSwipesInPastYear];
    if(count == LEVEL_1_SWIPE_THRESHOLD) return LEVEL_1_ID;
    else if(count == LEVEL_2_SWIPE_THRESHOLD) return LEVEL_2_ID;
    else if(count == LEVEL_3_SWIPE_THRESHOLD) return LEVEL_3_ID;
    else return -1;
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

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
    	return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
    	return NO;
    
    return YES;
}

- (int) getNextAbsenceLevel
{
    int absences = [self getNumberOfAbsencesInPastYear];
    if(absences < LEVEL_1_ABSENCE_THRESHOLD) return LEVEL_1_ID;
    else if(absences < LEVEL_2_ABSENCE_THRESHOLD) return LEVEL_2_ID;
    else return LEVEL_3_ID;
}

- (int) getNextTardyLevel
{
    int tardies = [self getNumberOfTardiesInPastYear];
    if(tardies < LEVEL_1_TARDY_THRESHOLD) return LEVEL_1_ID;
    else if(tardies < LEVEL_2_TARDY_THRESHOLD) return LEVEL_2_ID;
    else return LEVEL_3_ID;
}

- (int) getNextMissedSwipeLevel
{
    int swipes = [self getNumberOfMissedSwipesInPastYear];
    if(swipes < LEVEL_1_SWIPE_THRESHOLD) return LEVEL_1_ID;
    else if(swipes < LEVEL_2_SWIPE_THRESHOLD) return LEVEL_2_ID;
    else return LEVEL_3_ID;
}

- (NSString *) getTextForLevel: (int) level
{
    if(level == LEVEL_1_ID) return LEVEL_1_ACTION_NAME;
    else if(level == LEVEL_2_ID) return LEVEL_2_ACTION_NAME;
    else if(level == LEVEL_3_ID) return LEVEL_3_ACTION_NAME;
    else return @"";
}


- (id) initWithManagedObject:(EmployeeRecordManagedObject *)managedObject
{
    if(self = [super init])
    {
        self.firstName = (managedObject.firstName != nil) ? managedObject.firstName : @"";
        self.lastName = (managedObject.lastName != nil)  ? managedObject.lastName : @"";
        self.mutableAbsences = (managedObject.absences != nil) ? [managedObject.absences mutableCopy] : [[NSMutableArray alloc] init];
        self.mutableTardies = (managedObject.tardies != nil) ? [managedObject.tardies mutableCopy] : [[NSMutableArray alloc] init];
        self.mutableMissedSwipes = (managedObject.missedSwipes != nil) ? [managedObject.missedSwipes mutableCopy] : [[NSMutableArray alloc] init];
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
