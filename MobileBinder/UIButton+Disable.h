/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <UIKit/UIKit.h>

/*
 * Allows a button to be disabled and enabled
 */
@interface UIButton (Disable)

/*
 *  Disable user interaction on this button and change its appearance to reflect this
 */
- (void) disableButton;

/*
 *  Enable user interaction on this button and restore its appearance
 */
- (void) enableButton;

@end
