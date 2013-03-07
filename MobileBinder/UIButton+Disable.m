/*
 * Created by Andrew Patterson
 * Copyright (c) 2012 Prometheus Group. All rights reserved.
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
