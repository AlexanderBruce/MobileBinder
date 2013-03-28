#import "ResourcesModel.h"
#import "ResourceObject.h"

#define RESOURCES_DATA_FILE @"ResourcesData"

@interface ResourcesModel()
@property (nonatomic) BOOL usingFilter;
@property (nonatomic, strong) NSMutableArray *resourceLinks;
@property (nonatomic, strong) NSMutableArray *filteredLinks;
@end

@implementation ResourcesModel

-(id)init
{
    if(self==[super init])
    {
        self.resourceLinks = [[NSMutableArray alloc] init];
        [self retrieveLinks];
    }
    return self;
}


- (int) getNumberOfResourceLinks
{
    if(self.usingFilter) return self.filteredLinks.count;
    return self.resourceLinks.count;
}

- (NSArray *) getResourceLinks
{
    if(self.usingFilter) return self.filteredLinks;
    else return self.resourceLinks;
}

- (void) retrieveLinks
{
    NSString* path = [[NSBundle mainBundle] pathForResource:RESOURCES_DATA_FILE ofType:@""];
    NSArray *lines = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]
                      componentsSeparatedByString:@"\n"];
    
    for (NSString *line in lines)
    {
        if([line hasPrefix:@"//"]) continue; //Skip comment lines
        if([line hasPrefix:@"##"])
        {
            NSArray *data = [line componentsSeparatedByString:@"##"];
            if(data.count != 4) [NSException raise:NSInvalidArgumentException format:@"Each header must have the form ##Page Title##Page URL##"];
            ResourceObject *resourceObj = [[ResourceObject alloc] init];
            resourceObj.pageTitle = [data objectAtIndex:1];
            resourceObj.webpageURL = [data objectAtIndex:2];
            [self.resourceLinks addObject:resourceObj];
        }
    }
}

- (void) filterResourceLinksByString: (NSString *) filterString
{
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
