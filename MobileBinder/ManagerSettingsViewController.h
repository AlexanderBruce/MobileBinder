/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <UIKit/UIKit.h>
#import "SettingsProtocol.h"

/*
 *  Allows the user to input information about the manager that is using the app
 */
@interface ManagerSettingsViewController : UIViewController <SettingsViewController>

@property (nonatomic,weak) id<SettingsDelegate> delegate;

@end
