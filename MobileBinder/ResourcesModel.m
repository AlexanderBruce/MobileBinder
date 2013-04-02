#import "ResourcesModel.h"
#import "ResourceObject.h"

#define RESOURCES_DATA_FILE @"ResourcesData"

@interface ResourcesModel()
@property (nonatomic) BOOL usingFilter;
@property (nonatomic, strong) NSMutableDictionary *resourceLinks;
@property (nonatomic, strong) NSMutableDictionary *filteredLinks;
@end

@implementation ResourcesModel

-(id)init
{
    if(self==[super init])
    {
        self.resourceLinks = [[NSMutableDictionary alloc] init];
        [self retrieveLinks];
    }
    return self;
}

- (int) getNumberOfCategories
{
    if(self.usingFilter) return self.filteredLinks.count;
    return self.resourceLinks.count;
}

- (int) getNumberOfCategoriesWhenUnfiltered
{
    return self.resourceLinks.count;
}

- (int) getNumberOfLinksForCategory: (int) categoryNum
{
    NSDictionary *dict;
    if(self.usingFilter) dict = self.filteredLinks;
    else dict = self.resourceLinks;
    NSArray * sortedKeys = [[dict allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    NSArray * values = [dict objectForKey:[sortedKeys objectAtIndex:categoryNum]];
    return values.count;
}

- (NSString *) getNameOfCategory: (int) categoryNum
{
    NSDictionary *dict;
    if(self.usingFilter) dict = self.filteredLinks;
    else dict = self.resourceLinks;
    NSArray * sortedKeys = [[dict allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    return [sortedKeys objectAtIndex:categoryNum];
}

- (ResourceObject *) getResourceForCategory: (int) categoryNum index: (int) index
{
    NSDictionary *dict;
    if(self.usingFilter) dict = self.filteredLinks;
    else dict = self.resourceLinks;
    NSArray * sortedKeys = [[dict allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    NSArray *values = [dict objectForKey:[sortedKeys objectAtIndex:categoryNum]];
    NSArray *sortedValues = [values sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(ResourceObject *)a pageTitle];
        NSString *second = [(ResourceObject *)b pageTitle];
        return [first compare:second];
    }];
    return [sortedValues objectAtIndex:index];
}

- (void) retrieveLinks
{
    NSString* path = [[NSBundle mainBundle] pathForResource:RESOURCES_DATA_FILE ofType:@""];
    NSArray *lines = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]
                      componentsSeparatedByString:@"\n"];
    NSMutableArray *currentCategory;
    NSString *currentCategoryName;
    for (NSString *line in lines)
    {
        if([line hasPrefix:@"//"]) continue; //Skip comment lines
        if([line hasPrefix:@"##"])
        {
            NSArray *data = [line componentsSeparatedByString:@"##"];
            if(data.count != 5) [NSException raise:NSInvalidArgumentException format:@"Each header must have the form ##Page Title##Page URL##description##"];
            ResourceObject *resourceObj = [[ResourceObject alloc] init];
            resourceObj.pageTitle = [data objectAtIndex:1];
            resourceObj.webpageURL = [data objectAtIndex:2];
            resourceObj.description = [data objectAtIndex:3];
            [currentCategory addObject:resourceObj];
        }
        else if([line hasPrefix:@"!!"])
        {
            if(currentCategory) [self.resourceLinks setObject:currentCategory forKey:currentCategoryName];
            NSArray *data = [line componentsSeparatedByString:@"!!"];
            currentCategory = [[NSMutableArray alloc] init];
            currentCategoryName = [data objectAtIndex:1];
        }
        [self.resourceLinks setObject:currentCategory forKey:currentCategoryName];
    }
}

- (void) filterResourceLinksByString: (NSString *) filterString
{
    self.usingFilter = YES;
    self.filteredLinks = [[NSMutableDictionary alloc] init];
    NSMutableArray *filterArray = (NSMutableArray *)[[filterString componentsSeparatedByString:@" "] mutableCopy];
    [filterArray removeObject:@""];
    for (NSString *key in self.resourceLinks)
    {
        NSArray *values = [self.resourceLinks objectForKey:key];
        NSMutableArray *filteredValues = [[NSMutableArray alloc] init];
        for (ResourceObject *currentLink in values)
        {
            BOOL matchesFilter = YES;
            for (NSString *currentFilter in filterArray)
            {
                NSRange pageRange = [currentLink.pageTitle rangeOfString:currentFilter options:NSCaseInsensitiveSearch];
                NSRange urlRange = [currentLink.webpageURL rangeOfString:currentFilter options:NSCaseInsensitiveSearch];
                NSRange descripRange = [currentLink.description rangeOfString:currentFilter options:NSCaseInsensitiveSearch];
                if(pageRange.location == NSNotFound && urlRange.location == NSNotFound && descripRange.location == NSNotFound)
                {
                    matchesFilter = NO;
                    break;
                }
            }
            if(matchesFilter) [filteredValues addObject:currentLink];
        }
        if(filteredValues.count > 0 ) [self.filteredLinks setObject:filteredValues forKey:key];
    }
}

- (void) stopFilteringResourceLinks
{
    self.usingFilter = NO;
}
@end
