#import <UIKit/UIKit.h>

@interface AttendanceCell : UITableViewCell


- (void) updateAbsenceProgress: (float) absenceProgress withLevel: (int) level;

- (void) updateTardyProgress: (float) tardyProgress withLevel: (int) level;

- (void) updateMissedSwipesProgress: (float) missedSwipesProgress withLevel: (int) level;

- (void) updateFirstName: (NSString *) first lastName: (NSString *) last;

@end
