/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "PredefinedImagesModel.h"

@implementation PredefinedImagesModel

- (int) getNumberOfImages
{
    return 12;
}

- (UIImage *) getImageWithNumber: (int) imageNum
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"Background%d.png",(imageNum % 6)]];
}

- (UIImage *) getThumbnailWithNumber: (int) thumbnailNum
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"Thumbnail%d.png",(thumbnailNum % 6)]];
}

@end
