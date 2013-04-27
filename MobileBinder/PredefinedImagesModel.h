/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>

/*
 *  Retrieves and stores background images that are built into the app
 */
@interface PredefinedImagesModel : NSObject

/*
 *  Returns the number of predefined images
 */
- (int) getNumberOfImages;

/*
 *  Returns the full sized image with a specific number
 */
- (UIImage *) getImageWithNumber: (int) imageNum;

/*
 *  Returns a small thumbnail of the image with a specific number
 */
- (UIImage *) getThumbnailWithNumber: (int) thumbnailNum;

@end
