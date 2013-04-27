#import <UIKit/UIKit.h>

/*
 *  A UILabel where you can select a different color to outline the text in.
 *  For example, white text with black outlines may be useful when used in a BackgroundViewController (with an unknown background color/image)
 */
@interface OutlinedLabel : UILabel

typedef enum _ASIAuthenticationType {
	AGKOutlineLabelVerticalAlignmentTop = 0,
    AGKOutlineLabelVerticalAlignmentBottom = 1,
    AGKOutlineLabelVerticalAlignmentMiddle = 2
} AGKOutlineLabelVerticalAlignment;

@property (nonatomic, strong) UIColor *outlineColor;
@property (nonatomic) CGFloat outlineWidth;
@property (nonatomic) AGKOutlineLabelVerticalAlignment verticalAlignment;
@property (nonatomic) CGFloat shadeBlur;
@property (nonatomic, strong) UIColor * diffuseShadowColor;
@property (nonatomic) CGSize diffuseShadowOffset;

- (void) customize;

@end
