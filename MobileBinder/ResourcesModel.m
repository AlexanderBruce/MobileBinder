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
    
}



- (void) filterResourceLinksByString: (NSString *) filterString{
    
}

- (void) stopFilteringResourceLinks{
    
}


@end
