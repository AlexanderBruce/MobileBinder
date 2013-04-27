/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <UIKit/UIKit.h>

/*
 *  A view controller that displays a background image (found in documents directory at BACKGROUND_IMAGE_FILENAME).  
 *  Simply extend this class in order to display the image as the background of your view controller
 */
@interface BackgroundViewController : UIViewController

/*
 *  Call this method to reload the background image from BACKGROUND_IMAGE_FILENAME 
 *  and update all instances of BackgroundViewController.  For example, you would call this if the user selects a new
 *  image to be used as the background
 */
+ (void) refreshBackground;

@end
