/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>

@protocol SettingsDelegate <NSObject>

/*
 *  Called when the user has finished using a SettingsViewController and has saved
 */
- (void) savedSettingsForViewController: (UIViewController *) viewController;

@end

/*
 *  A view controller that has a delegate to report to when it is done being used
 */
@protocol SettingsViewController <NSObject>

@property (nonatomic, weak) id<SettingsDelegate> delegate;

@end
