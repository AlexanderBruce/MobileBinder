/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "UITextViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITextViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textView = [self createTextView];
        [self.contentView addSubview:self.textView];
    }
    return self;
}

- (UITextView *) createTextView
{
    UITextView * textView = [[UITextView alloc] init];
    
    float xOrigin = 3;
    float yOrigin = 3;
    float width = self.contentView.frame.size.width - (2 * xOrigin);
    float height = self.contentView.frame.size.height - (2 * yOrigin);
    textView.frame = CGRectMake(xOrigin, yOrigin, width, height);
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textView.layer.cornerRadius = 5;
    textView.clipsToBounds = YES;
    return textView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
