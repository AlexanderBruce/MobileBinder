#import <UIKit/UIKit.h>

@interface AttendanceCell : UITableViewCell


- (void) updateNumAbsence: (int) numAbsences progress: (float) absenceProgress level: (int) level;

- (void) updateNumTardy: (int) numTardy progress: (float) tardyProgress level: (int) level;

- (void) updateNumMissedSwipes: (int) numMissedSwipes progress: (float) missedSwipesProgress level: (int) level;

- (void) updateFirstName: (NSString *) first lastName: (NSString *) last department: (NSString *) dep;

@end
