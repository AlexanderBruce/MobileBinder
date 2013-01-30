#import <UIKit/UIKit.h>

@interface AttendanceCell : UITableViewCell


- (void) updateAbsenceProgress: (float) absenceProgress;

- (void) updateTardyProgress: (float) tardyProgress;

- (void) updateOtherProgress: (float) otherProgress;

- (void) updateFirstName: (NSString *) first lastName: (NSString *) last;

@end
