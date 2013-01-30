#import <UIKit/UIKit.h>

@interface AttendanceCell : UITableViewCell


- (void) updateAbsenceProgress: (float) absenceProgress;

- (void) updateTardyProgress: (float) tardyProgress;

- (void) updateMissedSwipesProgress: (float) missedSwipesProgress;

- (void) updateFirstName: (NSString *) first lastName: (NSString *) last;

@end
