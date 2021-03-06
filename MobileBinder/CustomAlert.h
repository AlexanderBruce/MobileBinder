/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <UIKit/UIKit.h>

/*
 *  Similar to UIAlertView, except that this allows you to set the UIAlertView's background and stroke colors
 */
@interface CustomAlert : UIAlertView

/*
 *  Sets the background and stroke color of all CustomAlert instances that are created after this method has been called
 */
+ (void) setBackgroundColor:(UIColor *) background 
            withStrokeColor:(UIColor *) stroke;

@end