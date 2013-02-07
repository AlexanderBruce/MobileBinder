#import <Foundation/Foundation.h>

@interface Constants : NSObject

#define IS_4_INCH_SCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/*
 * Progress Indicator
 */
#define PROGRESS_INDICATOR_LABEL_FONT_SIZE 23.5f
#define PROGRESS_INDICATOR_DETAIL_FONT_SIZE 16.0f
#define PROGRESS_INDICATOR_GREY_COLOR 0.24f
#define PROGRESS_INDICATOR_OPACITY 0.97f
#define PROGRESS_INDICATOR_FONT @"Georgia"


@end
