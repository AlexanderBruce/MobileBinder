#import "OutlinedLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation OutlinedLabel

@synthesize outlineColor = _outlineColor, outlineWidth = _outlineWidth;
@synthesize verticalAlignment = _verticalAlignment, shadeBlur = _shadeBlur;
@synthesize diffuseShadowColor = _diffuseShadowColor, diffuseShadowOffset = _diffuseShadowOffset;

- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([self shadowColor] && [self shadowOffset].width) {
        [self setOutlineColor:[self shadowColor]];
        [self setOutlineWidth:[self shadowOffset].width];
    }
    [self setShadowColor:[UIColor clearColor]];
    [self setShadowOffset:CGSizeZero];
}

- (void)setText:(NSString *)text
{
    if ([[self text] isEqualToString:text]) return;
    [super setText:text];
}

- (void)setTextColor:(UIColor *)textColor
{
    if (![self textColor] && [textColor isEqual:[UIColor clearColor]]) return;
    if ([[self textColor] isEqual:textColor]) return;
    [super setTextColor:textColor];
}

- (void)setShadeBlur:(CGFloat)shadeBlur
{
    if (shadeBlur == _shadeBlur) return;
    [self willChangeValueForKey:@"shadeBlur"];
    _shadeBlur = shadeBlur;
    [self didChangeValueForKey:@"shadeBlur"];
    [self setNeedsDisplay];
}

- (void)setOutlineWidth:(CGFloat)outlineWidth
{
    if (outlineWidth == [self outlineWidth]) return;
    [self willChangeValueForKey:@"outlineWidth"];
    _outlineWidth = outlineWidth;
    [self didChangeValueForKey:@"outlineWidth"];
    [self setNeedsDisplay];
}

- (void)setVerticalAlignment:(AGKOutlineLabelVerticalAlignment)verticalAlignment
{
    if (_verticalAlignment == verticalAlignment) return;
    [self willChangeValueForKey:@"verticalAlignment"];
    _verticalAlignment = verticalAlignment;
    [self didChangeValueForKey:@"verticalAlignment"];
    [self setNeedsDisplay];
}

- (void)setOutlineColor:(UIColor *)outlineColor
{
    if ([outlineColor isEqual:_outlineColor]) return;
    [self willChangeValueForKey:@"outlineColor"];
    if (outlineColor == [UIColor clearColor]) {
        _outlineColor = nil;
    } else {
        _outlineColor = outlineColor;
    }
    [self didChangeValueForKey:@"outlineColor"];
    [self setNeedsDisplay];
}

- (void)setDiffuseShadowColor:(UIColor *)diffuseShadowColor
{
    if ([diffuseShadowColor isEqual:_diffuseShadowColor]) return;
    [self willChangeValueForKey:@"diffuseShadowColor"];
    if (diffuseShadowColor == [UIColor clearColor]) {
        _diffuseShadowColor = nil;
    } else {
        _diffuseShadowColor = diffuseShadowColor;
    }
    [self didChangeValueForKey:@"diffuseShadowColor"];
    [self setNeedsDisplay];
}

- (void)setDiffuseShadowOffset:(CGSize )diffuseShadowOffset
{
    if (CGSizeEqualToSize(diffuseShadowOffset, _diffuseShadowOffset)) return;
    [self willChangeValueForKey:@"diffuseShadowOffset"];
    _diffuseShadowOffset = diffuseShadowOffset;
    [self didChangeValueForKey:@"diffuseShadowOffset"];
    [self setNeedsDisplay];
}

- (BOOL)setupForStroke:(CGContextRef)context
{
    CGContextSetLineJoin(context, kCGLineJoinBevel);
    CGContextSetLineCap(context, kCGLineCapSquare);
    BOOL willStroke = NO;
    CGContextSetLineWidth(context, MAX(0, [self outlineWidth] * 2));
    if ([self outlineColor] && [self outlineWidth] > 0) {
        CGContextSetFillColorWithColor(context, [[self outlineColor] CGColor]);
        CGContextSetStrokeColorWithColor(context, [[self outlineColor] CGColor]);
        willStroke = YES;
    } else {
        CGContextSetFillColorWithColor(context, [[self textColor] CGColor]);
        CGContextSetStrokeColorWithColor(context, [[UIColor clearColor] CGColor]);
    }
    if ([self diffuseShadowColor] != nil) {
        CGContextSetShadowWithColor(context, [self diffuseShadowOffset], [self shadeBlur], [[self diffuseShadowColor] CGColor]);
        willStroke = YES;
    }
    return willStroke;
}

- (void)drawTextInRect:(CGRect)rect
{
    if (![[self text] length]) return;
    CGContextRef c = UIGraphicsGetCurrentContext();
    if ([self outlineColor] && [self outlineWidth] > 0) {
        rect = CGRectInset(rect, [self outlineWidth] * 2, [self outlineWidth] * 2);
    }
    if ([self numberOfLines] == 1) {
        CGFloat fontSize = 10;
        CGSize resultingSize = [[self text] sizeWithFont:[self font]
                                             minFontSize:[self minimumFontSize]
                                          actualFontSize:&fontSize
                                                forWidth:rect.size.width
                                           lineBreakMode:[self lineBreakMode]];
        CGPoint point = rect.origin;
        switch ([self verticalAlignment]) {
            case AGKOutlineLabelVerticalAlignmentTop:
                break;
            case AGKOutlineLabelVerticalAlignmentBottom:
                point.y += rect.size.height - resultingSize.height;
                break;
            case AGKOutlineLabelVerticalAlignmentMiddle:
                point.y += floor((rect.size.height - resultingSize.height) / 2);
                break;
        }
        switch ([self textAlignment]) {
            case UITextAlignmentLeft:
                break;
            case UITextAlignmentRight:
                point.x += rect.size.width - resultingSize.width;
                break;
            default:
                point.x += floor((rect.size.width - resultingSize.width) / 2);
                break;
        }
        if ([self setupForStroke:c]) {
            CGContextSetTextDrawingMode(c, kCGTextFillStroke);
            [[self text] drawAtPoint:point
                            forWidth:rect.size.width
                            withFont:[self font]
                         minFontSize:[self minimumFontSize]
                      actualFontSize:&fontSize
                       lineBreakMode:[self lineBreakMode]
                  baselineAdjustment:[self baselineAdjustment]];
        }
        CGContextSetShadow(c, CGSizeZero, 0);
        CGContextSetStrokeColorWithColor(c, [[UIColor clearColor] CGColor]);
        CGContextSetFillColorWithColor(c, [[self textColor] CGColor]);
        CGContextSetTextDrawingMode(c, kCGTextFillStroke);
        [[self text] drawAtPoint:point
                        forWidth:rect.size.width
                        withFont:[self font]
                     minFontSize:[self minimumFontSize]
                  actualFontSize:&fontSize
                   lineBreakMode:[self lineBreakMode]
              baselineAdjustment:[self baselineAdjustment]];
    } else {
        CGSize resultingSize = [[self text] sizeWithFont:[self font]
                                       constrainedToSize:rect.size
                                           lineBreakMode:[self lineBreakMode]];
        CGRect resultingRect = rect;
        resultingRect.size.height = resultingSize.height;
        switch ([self verticalAlignment]) {
            case AGKOutlineLabelVerticalAlignmentTop:
                break;
            case AGKOutlineLabelVerticalAlignmentBottom:
                resultingRect.origin.y += rect.size.height - resultingSize.height;
                break;
            case AGKOutlineLabelVerticalAlignmentMiddle:
                resultingRect.origin.y += floor((rect.size.height - resultingSize.height) / 2);
                break;
        }
        if ([self setupForStroke:c]) {
            CGContextSetTextDrawingMode(c, kCGTextFillStroke);
            [[self text] drawInRect:resultingRect
                           withFont:[self font]
                      lineBreakMode:[self lineBreakMode]
                          alignment:[self textAlignment]];
        }
        CGContextSetStrokeColorWithColor(c, [[UIColor clearColor] CGColor]);
        CGContextSetFillColorWithColor(c, [[self textColor] CGColor]);
        CGContextSetTextDrawingMode(c, kCGTextFillStroke);
        [[self text] drawInRect:resultingRect
                       withFont:[self font]
                  lineBreakMode:[self lineBreakMode]
                      alignment:[self textAlignment]];
    }
}

@end
