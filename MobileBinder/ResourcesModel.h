#import <Foundation/Foundation.h>

@interface ResourcesModel : NSObject

- (int) getNumberOfResourceLinks;

- (NSArray *) getResourceLinks;

- (void) filterResourceLinksByString: (NSString *) filterString;

- (void) stopFilteringResourceLinks;



@end
