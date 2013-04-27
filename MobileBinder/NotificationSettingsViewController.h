/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <UIKit/UIKit.h>
#import "BackgroundViewController.h"
#import "SettingsProtocol.h"

/*
 *  Allows the user to select what notifications they recieve from this app
 */
@interface NotificationSettingsViewController : BackgroundViewController  <SettingsViewController>

@property (nonatomic, weak) id<SettingsDelegate> delegate;

@end
