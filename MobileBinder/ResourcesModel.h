#import <Foundation/Foundation.h>
@class ResourceObject;

@interface ResourcesModel : NSObject

- (int) getNumberOfCategories;

- (int) getNumberOfCategoriesWhenUnfiltered;

- (int) getNumberOfLinksForCategory: (int) categoryNum;

- (ResourceObject *) getResourceForCategory: (int) categoryNum index: (int) index;

- (NSString *) getNameOfCategory: (int) categoryNum;

- (void) filterResourceLinksByString: (NSString *) filterString;

- (void) stopFilteringResourceLinks;



@end
