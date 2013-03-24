//
//  ResourcesModel.m
//  MobileBinder
//
//  Created by Alexander Bruce on 3/24/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import "ResourcesModel.h"
#import "ResourceObject.h"
@interface ResourcesModel() 
@property (nonatomic) BOOL usingFilter;
@property (nonatomic, strong) NSMutableArray *resourceLinks;
@property (nonatomic, strong) NSMutableArray *filteredLinks;
@end

@implementation ResourcesModel

-(id)init{
    if(self==[super init])
    {
        
    }
    self.resourceLinks = [[NSMutableArray alloc] init];
    [self makeLinks];
    return self;
}


- (int) getNumberOfResourceLinks{
    if(self.usingFilter) return self.filteredLinks.count;
    return self.resourceLinks.count;
    
}

- (NSArray *) getResourceLinks{
    if(self.usingFilter) return self.filteredLinks;
    else return self.resourceLinks;
}

- (void) makeLinks
{
    ResourceObject *first = [[ResourceObject alloc]init];
    first.webpageURL = @"http://www.google.com";
    first.pageTitle = @"Google";
    [self.resourceLinks addObject:first];
    
    ResourceObject *second = [[ResourceObject alloc]init];
    second.webpageURL = @"http://www.apple.com";
    second.pageTitle = @"Apple";
    [self.resourceLinks addObject:second];
    
    ResourceObject *third = [[ResourceObject alloc]init];
    third.webpageURL = @"http://www.yahoo.com";
    third.pageTitle = @"Yahoo";
    [self.resourceLinks addObject:third];

}





- (void) filterResourceLinksByString: (NSString *) filterString{
    self.usingFilter = YES;
        self.filteredLinks = [[NSMutableArray alloc] init];
    NSMutableArray *filterArray = (NSMutableArray *)[[filterString componentsSeparatedByString:@" "] mutableCopy];
    [filterArray removeObject:@""];
    for (ResourceObject *currentLink in self.resourceLinks)
    {
        BOOL matchesFilter = YES;
        for (NSString *currentFilter in filterArray)
        {
            NSRange pageRange = [currentLink.pageTitle rangeOfString:currentFilter options:NSCaseInsensitiveSearch];
            NSRange urlRange = [currentLink.webpageURL rangeOfString:currentFilter options:NSCaseInsensitiveSearch];
            

            if(pageRange.location == NSNotFound && urlRange.location == NSNotFound )
            {
                matchesFilter = NO;
                break;
            }
        }
        if(matchesFilter) [self.filteredLinks addObject:currentLink];
    }

    
}

- (void) stopFilteringResourceLinks
{
    self.usingFilter = NO;
    
}


@end
