#import <Foundation/Foundation.h>
@class EmployeeRecordManagedObject;

#define LEVEL_1_ACTION_NAME @"Written Warning"
#define LEVEL_1_ID 1
#define LEVEL_1_ABSENCE_THRESHOLD 7
#define LEVEL_1_TARDY_THRESHOLD 8
#define LEVEL_1_SWIPE_THRESHOLD 8

#define LEVEL_2_ACTION_NAME @"Final Written Warning"
#define LEVEL_2_ID 2
#define LEVEL_2_ABSENCE_THRESHOLD 8
#define LEVEL_2_TARDY_THRESHOLD 10
#define LEVEL_2_SWIPE_THRESHOLD 10

#define LEVEL_3_ACTION_NAME @"Termination"
#define LEVEL_3_ID 3
#define LEVEL_3_ABSENCE_THRESHOLD 9
#define LEVEL_3_TARDY_THRESHOLD 12
#define LEVEL_3_SWIPE_THRESHOLD 12

#define MAX_ABSENCES 9.0
#define MAX_TARDIES 12.0
#define MAX_MISSED_SWIPES 12.0

@interface EmployeeRecord : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic, strong) NSString *idNum;

@property (nonatomic, strong) EmployeeRecordManagedObject *myManagedObject;

- (id) initWithManagedObject:(EmployeeRecordManagedObject *) managedObject;

- (void) deleteFromDatabase: (UIManagedDocument *) database;

- (int) getNextAbsenceLevel;

- (int) getNextTardyLevel;

- (int) getNextMissedSwipeLevel;


/* Returns a level ID if and only if the employee has reached a NEW level. Returns a negative number otherwise */
- (int) addAbsence: (NSDate *) date error: (NSError **) error;

/* Returns a level ID if and only if the employee has reached a NEW level. Returns a negative number otherwise */
- (int) addTardy: (NSDate *) date error: (NSError **) error;

/* Returns a level ID if and only if the employee has reached a NEW level. Returns a negative number otherwise */
- (int) addMissedSwipe: (NSDate *) date error: (NSError **) error;


- (void) removeAbsence: (NSDate *) date;

- (void) removeTardy: (NSDate *) date;

- (void) removeAllMissedSwipes: (NSDate *) date;

- (NSArray *) getAbsencesInPastYear;

- (NSArray *) getTardiesInPastYear;

- (NSArray *) getMissedSwipesInPastYear;


@end
