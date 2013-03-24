//
//  ResourcesModel.m
//  MobileBinder
//
//  Created by Alexander Bruce on 3/24/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import "ResourcesModel.h"
@interface ResourcesModel() 
@property (nonatomic) BOOL usingFilter;
@property (nonatomic, strong) NSMutableArray *resourceLinks;
@property (nonatomic, strong) NSMutableArray *filteredLinks;
@property (nonatomic, strong) NSMutableArray *pageTitles;
@end

@implementation ResourcesModel

-(id)init{
    if(self==[super init])
    {
        
    }
    self.resourceLinks = [[NSMutableArray alloc] init];
    self.filteredLinks = [[NSMutableArray alloc] init];
    self.pageTitles = [[NSMutableArray alloc] init];
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
    NSString *firstLink = @"http://www.google.com/";
    NSString *secondLink = @"http://www.yahoo.com/";
    NSString *thirdLink = @"http://www.apple.com/";
    [self.resourceLinks addObject:firstLink];
    [self.resourceLinks addObject:secondLink];
    [self.resourceLinks addObject:thirdLink];
    [self.pageTitles addObject:@"Google"];
    [self.pageTitles addObject:@"Yahoo"];
    [self.pageTitles addObject:@"Apple"];
    
}

- (NSArray *) getPageTitles
{
    return [self.pageTitles copy];
}




- (void) filterResourceLinksByString: (NSString *) filterString{
    self.usingFilter = YES;
    
}

- (void) stopFilteringResourceLinks
{
    self.usingFilter = NO;
    
}


@end
