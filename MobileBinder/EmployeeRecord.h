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

/*
 *  Represents a single employee
 */
@interface EmployeeRecord : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *idNum;  /* This employee's unique ID */

/*
 *  The underlying CoreData object
 */
@property (nonatomic, strong) EmployeeRecordManagedObject *myManagedObject;

/*
 *  Initialize this employee record using data from an underlying employee record
 */
- (id) initWithManagedObject:(EmployeeRecordManagedObject *) managedObject;

/*
 *  If this employee record has an underlying managed object, delete it from a database
 */
- (void) deleteFromDatabase: (UIManagedDocument *) database;

/*
 *  Returns the level that will be reached with the next absence
 */
- (int) getNextAbsenceLevel;

/*
 *  Returns the level that will be reached with the next tardy
 */
- (int) getNextTardyLevel;

/*
 *  Returns the level that will be reached with the next missed swipe
 */
- (int) getNextMissedSwipeLevel;

/*
 *  Add a new absence to this employee record
 *  Returns a level ID if and only if the employee has reached a NEW level. Returns a negative number otherwise
 */
- (int) addAbsence: (NSDate *) date error: (NSError **) error;

/*
 *  Add a new tardy to this employee record
 *  Returns a level ID if and only if the employee has reached a NEW level. Returns a negative number otherwise
 */
- (int) addTardy: (NSDate *) date error: (NSError **) error;

/*
 *  Add a new missed swipe to this employee record
 *  Returns a level ID if and only if the employee has reached a NEW level. Returns a negative number otherwise
 */- (int) addMissedSwipe: (NSDate *) date error: (NSError **) error;

/*
 *  Removes the first absence with this NSDate
 */
- (void) removeAbsence: (NSDate *) date;

/*
 *  Removes the first tardy with this NSDate
 */
- (void) removeTardy: (NSDate *) date;

/*
 *  Removes the first missed swipe with this NSDate
 */
- (void) removeAllMissedSwipes: (NSDate *) date;

/*
 *  Returns an array of NSDates of all the absences within the past 12-month rolling calendar
 */
- (NSArray *) getAbsencesInPastYear;

/*
 *  Returns an array of NSDates of all the tardies within the past 12-month rolling calendar
 */
- (NSArray *) getTardiesInPastYear;

/*
 *  Returns an array of NSDates of all the missed swipes within the past 12-month rolling calendar
 */
- (NSArray *) getMissedSwipesInPastYear;


@end
