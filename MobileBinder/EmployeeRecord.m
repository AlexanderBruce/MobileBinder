#import "EmployeeRecord.h"
#import "EmployeeRecordManagedObject.h"

@interface EmployeeRecord()
@property (nonatomic, strong) NSMutableArray *allAbsences;
@property (nonatomic, strong) NSMutableArray *allTardies;
@property (nonatomic, strong) NSMutableArray *allMissedSwipes;
@property (nonatomic, strong) NSMutableArray *absencesInPastYear;
@property (nonatomic, strong) NSMutableArray *tardiesInPastYear;
@property (nonatomic, strong) NSMutableArray *missedSwipesInPastYear;
@end

@implementation EmployeeRecord

- (void) setFirstName:(NSString *)firstName
{
    _firstName = firstName;
    self.myManagedObject.firstName = _firstName;
}

- (void) setLastName:(NSString *)lastName
{
    _lastName = lastName;
    self.myManagedObject.lastName = _lastName;
}

- (void) setDepartment:(NSString *)department
{
    _department = department;
    self.myManagedObject.department = _department;
}

- (void) setUnit:(NSString *)unit
{
    _unit = unit;
    self.myManagedObject.unit = _unit;
}

- (void) setIdNum:(NSString *)idNum
{
    _idNum = idNum;
    NSLog(@"Setting IDNUM");
    self.myManagedObject.idNum = _idNum;
}

- (NSArray *) getAbsencesInPastYear
{
    return self.absencesInPastYear;
}

- (NSArray *) getTardiesInPastYear
{
    return self.tardiesInPastYear;
}

- (NSArray *) getMissedSwipesInPastYear
{
    return self.missedSwipesInPastYear;
}

- (int) addAbsence: (NSDate *) date
{
    [self.allAbsences addObject:date];
    self.myManagedObject.absences = self.allAbsences;
    self.absencesInPastYear = [[NSMutableArray alloc] init];
    for (NSDate *date in self.allAbsences) {
        if([EmployeeRecord dateIsWithinPastYear:date]) [self.absencesInPastYear addObject:date];
    }
    
    int count = [self getAbsencesInPastYear].count;
    if(count == LEVEL_1_ABSENCE_THRESHOLD) return LEVEL_1_ID;
    else if(count == LEVEL_2_ABSENCE_THRESHOLD) return LEVEL_2_ID;
    else if(count == LEVEL_3_ABSENCE_THRESHOLD) return LEVEL_3_ID;
    else return -1;
}

- (int) addTardy: (NSDate *) date
{
    [self.allTardies addObject:date];
    self.myManagedObject.tardies = self.allTardies;
    self.tardiesInPastYear = [[NSMutableArray alloc] init];
    for (NSDate *date in self.allTardies) {
        if([EmployeeRecord dateIsWithinPastYear:date]) [self.tardiesInPastYear addObject:date];
    }
    int count = [self getTardiesInPastYear].count;
    if(count == LEVEL_1_TARDY_THRESHOLD) return LEVEL_1_ID;
    else if(count == LEVEL_2_TARDY_THRESHOLD) return LEVEL_2_ID;
    else if(count == LEVEL_3_TARDY_THRESHOLD) return LEVEL_3_ID;
    else return -1;
}

- (int) addMissedSwipe: (NSDate *) date
{
    [self.allMissedSwipes addObject:date];
    self.myManagedObject.missedSwipes = self.allMissedSwipes;
    self.missedSwipesInPastYear = [[NSMutableArray alloc] init];
    for (NSDate *date in self.missedSwipesInPastYear) {
        if([EmployeeRecord dateIsWithinPastYear:date]) [self.missedSwipesInPastYear addObject:date];
    }
    int count = [self getMissedSwipesInPastYear].count;
    if(count == LEVEL_1_SWIPE_THRESHOLD) return LEVEL_1_ID;
    else if(count == LEVEL_2_SWIPE_THRESHOLD) return LEVEL_2_ID;
    else if(count == LEVEL_3_SWIPE_THRESHOLD) return LEVEL_3_ID;
    else return -1;
}

- (void) removeAbsence: (NSDate *) date
{
    [self.allAbsences removeObject:date];
    [self.absencesInPastYear removeObject:date];
    self.myManagedObject.absences = self.allAbsences;
}

- (void) removeTardy: (NSDate *) date
{
    [self.allTardies removeObject:date];
    [self.tardiesInPastYear removeObject:date];
    self.myManagedObject.tardies = self.allTardies;
}

- (void) removeAllMissedSwipes: (NSDate *) date
{
    [self.allMissedSwipes removeObject:date];
    [self.missedSwipesInPastYear removeObject:date];
    self.myManagedObject.missedSwipes = self.allMissedSwipes;
}

+ (BOOL)dateIsWithinPastYear:(NSDate*)date
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    dayComponent.day = -365;
    NSDateComponents *comps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
    
    NSDate *yearAgo = [calendar dateFromComponents:comps];
    
    yearAgo = [calendar dateByAddingComponents:dayComponent toDate:yearAgo options:0];
    return ([yearAgo compare:date] == NSOrderedAscending);
}

- (int) getNextAbsenceLevel
{
    int absencesInPastYear = [self getAbsencesInPastYear].count;
    if(absencesInPastYear < LEVEL_1_ABSENCE_THRESHOLD) return LEVEL_1_ID;
    else if(absencesInPastYear < LEVEL_2_ABSENCE_THRESHOLD) return LEVEL_2_ID;
    else return LEVEL_3_ID;
}

- (int) getNextTardyLevel
{
    int tardiesInPastYear = [self getTardiesInPastYear].count;
    if(tardiesInPastYear< LEVEL_1_TARDY_THRESHOLD) return LEVEL_1_ID;
    else if(tardiesInPastYear < LEVEL_2_TARDY_THRESHOLD) return LEVEL_2_ID;
    else return LEVEL_3_ID;
}

- (int) getNextMissedSwipeLevel
{
    int missedSwipesInPastYear = [self getMissedSwipesInPastYear].count;
    if(missedSwipesInPastYear < LEVEL_1_SWIPE_THRESHOLD) return LEVEL_1_ID;
    else if(missedSwipesInPastYear< LEVEL_2_SWIPE_THRESHOLD) return LEVEL_2_ID;
    else return LEVEL_3_ID;
}

- (void) deleteFromDatabase: (UIManagedDocument *) database
{
    if(!self.myManagedObject) return; //If not saved to disk, then don't need to do anything
    [database.managedObjectContext deleteObject:self.myManagedObject];
    self.myManagedObject = nil;
    [database saveToURL:database.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){}];
}


- (id) initWithManagedObject:(EmployeeRecordManagedObject *)managedObject
{
    if(self = [super init])
    {
        self.firstName = (managedObject.firstName != nil) ? managedObject.firstName : @"";
        self.lastName = (managedObject.lastName != nil)  ? managedObject.lastName : @"";
        self.department = (managedObject.department != nil) ? managedObject.department : @"";
        self.unit = (managedObject.unit != nil)  ? managedObject.unit : @"";
        self.idNum = (managedObject.idNum != nil) ? managedObject.idNum : @"";
        NSLog(@"Read from managed object idNum = %@",self.idNum);
        self.allAbsences = (managedObject.absences != nil) ? [managedObject.absences mutableCopy] : [[NSMutableArray alloc] init];
        self.allTardies = (managedObject.tardies != nil) ? [managedObject.tardies mutableCopy] : [[NSMutableArray alloc] init];
        self.allMissedSwipes = (managedObject.missedSwipes != nil) ? [managedObject.missedSwipes mutableCopy] : [[NSMutableArray alloc] init];
        self.myManagedObject = managedObject;
        
        self.absencesInPastYear = [[NSMutableArray alloc] init];
        for (NSDate *date in self.allAbsences) {
            if([EmployeeRecord dateIsWithinPastYear:date]) [self.absencesInPastYear addObject:date];
        }
        
        self.tardiesInPastYear = [[NSMutableArray alloc] init];
        for (NSDate *date in self.allTardies) {
            if([EmployeeRecord dateIsWithinPastYear:date]) [self.tardiesInPastYear addObject:date];
        }
        
        self.missedSwipesInPastYear = [[NSMutableArray alloc] init];
        for (NSDate *date in self.missedSwipesInPastYear) {
            if([EmployeeRecord dateIsWithinPastYear:date]) [self.missedSwipesInPastYear addObject:date];
        }
        
    }
    return self;
}

- (BOOL) isEqual:(id)object
{
    if([object isKindOfClass:[self class]])
    {
        EmployeeRecord *other = (EmployeeRecord *) object;
        if(other.idNum.length > 0 && self.idNum.length > 0)
        {
            return ([self.idNum isEqualToString:other.idNum]);
        }
        else if(other.idNum == nil && self.idNum == nil)
        {
            NSString *selfStrForHashing = [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
            NSString *otherStrForHashing = [NSString stringWithFormat:@"%@ %@",other.firstName,other.lastName];
            return ([selfStrForHashing isEqualToString:otherStrForHashing]);
        }
    }
    return NO;
}

- (NSUInteger) hash
{
    if(self.idNum != nil && self.idNum.length > 0) return [self.idNum hash];
    else
    {
        NSString *strForHashing = [NSString stringWithFormat:@"%@ %@",self.firstName, self.lastName];
        return [strForHashing hash];
    }
}


- (id) init
{
    if(self = [super init])
    {
        self.allAbsences = [[NSMutableArray alloc] init];
        self.allTardies = [[NSMutableArray alloc] init];
        self.allMissedSwipes = [[NSMutableArray alloc] init];
        self.absencesInPastYear = [[NSMutableArray alloc] init];
        self.tardiesInPastYear = [[NSMutableArray alloc] init];
        self.missedSwipesInPastYear = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
