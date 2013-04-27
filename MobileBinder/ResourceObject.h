/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>

/*
 *  One given URL resource
 */
@interface ResourceObject : NSObject

/*
 *  The title of the webpage (used for display purposes only)
 */
@property (nonatomic, strong) NSString *pageTitle;

/*
 *  The URL that this resource refers to. 
 *  This should be a complete URL (e.g. http://www.example.com )
 */
@property (nonatomic, strong) NSString *webpageURL;

/*
 *  A description of this resource.  This description is also considered a series of keywords
 */
@property (nonatomic, strong) NSString *description;

@end
