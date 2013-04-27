#import <Foundation/Foundation.h>
@class ResourceObject;

/*
 *  Retrieves, parses and holds a series of ResourceObjects.
 *  This should also be used for adding new resources so that they might persist across runs of the app
 */
@interface ResourcesModel : NSObject

/*
 *  The number of categories or the number of filtered categories (if that option is currently on)
 */
- (int) getNumberOfCategories;

/*
 *  The number of categories regardless of filtering status
 */
- (int) getNumberOfCategoriesWhenUnfiltered;

/*
 *  The number of links that fall into a specific category.
 *  If filtering is on, this will only return the number of links in a given category that match a filter criteria
 */
- (int) getNumberOfLinksForCategory: (int) categoryNum;

/*
 *  Returns the resource object for a specific category and index (row)
 *  If filtering is on, this will require the filtered index
 */
- (ResourceObject *) getResourceForCategory: (int) categoryNum index: (int) index;

/*
 *  Converts a categoryNum into an NSString
 */
- (NSString *) getNameOfCategory: (int) categoryNum;

/*
 *  Converts a categoryNum regardless of filtering status into an NSString
 */
- (NSString *) getNameOfCategoryWhenUnFiltered:(int)categoryNum;

/*
 *  Alters the return values of many other of this classes methods.  
 *  Only resource objects that somehow contain every part of of the filterString are considered valid
 */
- (void) filterResourceLinksByString: (NSString *) filterString;

/*
 *  Stops filtering so that other methods of this class will return all relevant information
 *  It is okay to call this method even if filtering is not currently on
 */
- (void) stopFilteringResourceLinks;

/*
 *  Adds a custom resource object and saves it for permananent storage
 *  This new resource is immediately considered for the rest of this class's methods
 */
- (void) addResourceObjectwithPageTitle:(NSString *) pTitle url:(NSString *) url description:(NSString*) description category:(NSString*)category;

@end
