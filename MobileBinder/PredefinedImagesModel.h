#import <Foundation/Foundation.h>

@interface PredefinedImagesModel : NSObject

- (int) getNumberOfImages;

- (UIImage *) getImageWithNumber: (int) imageNum;

- (UIImage *) getThumbnailWithNumber: (int) thumbnailNum;

@end
