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
