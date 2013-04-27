/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <UIKit/UIKit.h>
#import "BackgroundViewController.h"
@class RoundingModel;
@class RoundingLog;

/*
 *  Displays the "overview" information about one rounding log
 */
@interface RoundingOverviewViewController : BackgroundViewController
@property (nonatomic, strong) RoundingModel *model;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) RoundingLog *log;  /* The log whose "overview" information will be displayed */

/*
 *  ABSTRACT METHOD
 *  Subclasses should use this method to save overview information into the rounding log
 */
- (void) storeDataIntoLog;

@end
