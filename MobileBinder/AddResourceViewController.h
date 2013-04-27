/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <UIKit/UIKit.h>
#import "BackgroundViewController.h"

@class ResourcesModel;

/*
 *  Allows a user to add custom resources
 */
@interface AddResourceViewController : BackgroundViewController

/*
 *  The model that custom resources are added to, in order that they might persist
 */
@property (strong,nonatomic) ResourcesModel * myModel;

@end
