//
//  ResourcesModel.h
//  MobileBinder
//
//  Created by Alexander Bruce on 3/24/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourcesModel : NSObject

- (int) getNumberOfResourceLinks;

- (NSArray *) getResourceLinks;

- (NSArray *) getPageTitles;

- (void) filterResourceLinksByString: (NSString *) filterString;

- (void) stopFilteringResourceLinks;



@end
