/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "UIButton+Disable.h"

@implementation UIButton (Disable)

- (void) disableButton
{
    self.enabled = NO;
    self.alpha = 0.6f;
}

- (void) enableButton
{
    self.enabled = YES;
    self.alpha = 1;
}

@end
