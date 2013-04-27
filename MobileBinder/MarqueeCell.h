/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <UIKit/UIKit.h>
@class MarqueeLabel;

/*
 *  A simple UITableViewCell that has a MarqueeLabel (scrolling UILabel) in it
 */
@interface MarqueeCell : UITableViewCell

/*
 *  Sets the text of the MarqueeLabel in this cell
 */
- (void) setLabelText: (NSString *) text;

@end
