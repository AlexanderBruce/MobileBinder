//This is a very important comment
#import <UIKit/UIKit.h>
@class EmployeeRecord;

@protocol AddEmployeeDelegate <NSObject>

- (void) canceledAddEmployeeViewController;

- (void) addedNewEmployeeRecord: (EmployeeRecord *) record;

@end

@interface AddEmployeeViewController : UIViewController
@property (nonatomic, weak) id<AddEmployeeDelegate> delegate;
@end