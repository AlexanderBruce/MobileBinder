#import <Foundation/Foundation.h>
@class ResourceObject;

@interface ResourcesModel : NSObject

- (int) getNumberOfCategories;

- (int) getNumberOfCategoriesWhenUnfiltered;

- (int) getNumberOfLinksForCategory: (int) categoryNum;

- (ResourceObject *) getResourceForCategory: (int) categoryNum index: (int) index;

- (NSString *) getNameOfCategory: (int) categoryNum;

- (NSString *) getNameOfCategoryWhenUnFiltered:(int)categoryNum;

- (void) filterResourceLinksByString: (NSString *) filterString;

- (void) stopFilteringResourceLinks;

- (void) addResourceObjectwithPageTitle:(NSString *) pTitle url:(NSString *) url description:(NSString*) description category:(NSString*)category;



@end
