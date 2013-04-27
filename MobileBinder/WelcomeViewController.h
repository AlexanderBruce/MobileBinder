/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <UIKit/UIKit.h>
#import "SettingsProtocol.h"

/*
 *  The view controller that prompts the user to fill in basic settings of the app (in order to maximize the app's functionality)
 */
@interface WelcomeViewController : UIViewController <SettingsDelegate>

@end
