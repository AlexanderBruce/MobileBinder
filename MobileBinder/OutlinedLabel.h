#import <UIKit/UIKit.h>

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

@end
