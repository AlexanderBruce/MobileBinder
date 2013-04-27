#import <UIKit/UIKit.h>

/*
 *  A table view cell used for displaying overview information about one employee record
 */
@interface AttendanceCell : UITableViewCell

/*
 *  Update the cell to reflect how many absences an employee record has, how far they have progressed towards termination
 *  and what absence level this employee record is at
 */
- (void) updateNumAbsence: (int) numAbsences progress: (float) absenceProgress level: (int) level;

/*
 *  Update the cell to reflect how many tardies an employee record has, how far they have progressed towards termination
 *  and what tardy level this employee record is at
 */
- (void) updateNumTardy: (int) numTardy progress: (float) tardyProgress level: (int) level;

/*
 *  Update the cell to reflect how many missed swipes an employee record has, how far they have progressed towards termination
 *  and what missed swipe level this employee record is at
 */
- (void) updateNumMissedSwipes: (int) numMissedSwipes progress: (float) missedSwipesProgress level: (int) level;

/*
 *  Update the cell to reflect personal details about an employee record
 */
- (void) updateFirstName: (NSString *) first lastName: (NSString *) last department: (NSString *) dep;

@end
