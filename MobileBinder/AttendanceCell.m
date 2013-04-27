/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "AttendanceCell.h"
#import "EmployeeRecord.h"

#define LEVEL_1_COLOR [UIColor greenColor]
#define LEVEL_2_COLOR [UIColor yellowColor]
#define LEVEL_3_COLOR [UIColor redColor]

#define LABEL_FORMAT @"(%d)"

@interface AttendanceCell()
@property (weak, nonatomic) IBOutlet UIProgressView *absencesProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *tardiesProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *missedSwipesProgressView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *depLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *absencesLabel;
@property (weak, nonatomic) IBOutlet UILabel *tardiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *missedSwipesLabel;
@end

@implementation AttendanceCell

- (void) updateFirstName: (NSString *) first lastName: (NSString *) last department: (NSString *) department
{
    self.firstNameLabel.text = first;
    self.lastNameLabel.text = last;
    self.depLabel.text = department;
}

- (void) updateNumAbsence:(int)numAbsences progress:(float)absenceProgress level:(int)level
{
    self.absencesProgressView.progress = absenceProgress;
    self.absencesProgressView.progressTintColor = [self colorForLevel:level];
    self.absencesLabel.text = [NSString stringWithFormat:LABEL_FORMAT,numAbsences];
}

-(void) updateNumTardy:(int)numTardy progress:(float)tardyProgress level:(int)level
{
    self.tardiesProgressView.progress = tardyProgress;
    self.tardiesProgressView.progressTintColor = [self colorForLevel:level];
    self.tardiesLabel.text = [NSString stringWithFormat:LABEL_FORMAT,numTardy];
}

-(void) updateNumMissedSwipes:(int)numMissedSwipes progress:(float)missedSwipesProgress level:(int)level
{
    self.missedSwipesProgressView.progress = missedSwipesProgress;
    self.missedSwipesProgressView.progressTintColor = [self colorForLevel:level];
    self.missedSwipesLabel.text = [NSString stringWithFormat:LABEL_FORMAT,numMissedSwipes];
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
