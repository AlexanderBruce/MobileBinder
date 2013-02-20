#import "AttendanceCell.h"
#import "EmployeeRecord.h"

#define LEVEL_1_COLOR [UIColor greenColor]
#define LEVEL_2_COLOR [UIColor yellowColor]
#define LEVEL_3_COLOR [UIColor redColor]

@interface AttendanceCell()
@property (weak, nonatomic) IBOutlet UIProgressView *absencesProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *tardiesProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *missedSwipesProgressView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *depLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@end

@implementation AttendanceCell

- (void) updateFirstName: (NSString *) first lastName: (NSString *) last department: (NSString *) dep
{
    self.firstNameLabel.text = first;
    self.lastNameLabel.text = last;
    self.depLabel.text = dep;
}

- (void) updateAbsenceProgress:(float)absenceProgress withLevel:(int)level
{
    self.absencesProgressView.progress = absenceProgress;
    self.absencesProgressView.progressTintColor = [self colorForLevel:level];
}

-(void) updateTardyProgress:(float)tardyProgress withLevel:(int)level
{
    self.tardiesProgressView.progress = tardyProgress;
    self.tardiesProgressView.progressTintColor = [self colorForLevel:level];
}

-(void) updateMissedSwipesProgress:(float)missedSwipesProgress withLevel:(int)level
{
    self.missedSwipesProgressView.progress = missedSwipesProgress;
    self.missedSwipesProgressView.progressTintColor = [self colorForLevel:level];
}

- (UIColor *) colorForLevel: (int) level
{
    if(level == LEVEL_1_ID) return LEVEL_1_COLOR;
    else if(level == LEVEL_2_ID) return LEVEL_2_COLOR;
    else if(level == LEVEL_3_ID) return LEVEL_3_COLOR;
    else return [UIColor blackColor];
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
