#import "AttendanceCell.h"

@interface AttendanceCell()
@property (weak, nonatomic) IBOutlet UIProgressView *absencesProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *tardiesProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *missedSwipesProgressView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@end

@implementation AttendanceCell

- (void) updateFirstName: (NSString *) first lastName: (NSString *) last
{
    self.firstNameLabel.text = first;
    self.lastNameLabel.text = last;
}

- (void) updateAbsenceProgress: (float) absenceProgress
{
    self.absencesProgressView.progress = absenceProgress;
}

- (void) updateTardyProgress: (float) tardyProgress
{
    self.tardiesProgressView.progress = tardyProgress;
}

- (void) updateMissedSwipesProgress: (float) missedSwipesProgress
{
    self.missedSwipesProgressView.progress = missedSwipesProgress;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}

@end
