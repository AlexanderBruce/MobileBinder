/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "MarqueeCell.h"
#import "MarqueeLabel.h"

@interface MarqueeCell()
@property (nonatomic, strong) MarqueeLabel *label;
@end

@implementation MarqueeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.label = [[MarqueeLabel alloc] initWithFrame:self.textLabel.frame rate:60 andFadeLength:0.07];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        float xOrigin = 10;
        float yOrigin = 0;
        float width = self.contentView.frame.size.width - 2 * xOrigin;
        float height = self.contentView.frame.size.height - 2 * yOrigin;
        self.label.frame = CGRectMake(xOrigin, yOrigin, width, height);
        self.label.font = [UIFont systemFontOfSize:16];
        //    label.labelize = YES;
        self.label.tapToScroll = YES;
        self.label.marqueeType = MLContinuous;
        self.label.textAlignment = UITextAlignmentLeft;
        self.label.continuousMarqueeSeparator = @"          ";
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void) setLabelText: (NSString *) text
{
    self.label.text = text;
}

@end
