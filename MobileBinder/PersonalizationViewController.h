/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <UIKit/UIKit.h>
#import "SettingsProtocol.h"
#import "BackgroundViewController.h"

/*
 *  Allows the user to personalize their app (colors, backgrounds, fonts...etc)
 */
@interface PersonalizationViewController : BackgroundViewController <SettingsViewController>

@property (nonatomic,weak) id<SettingsDelegate> delegate;

@end
