//This is a very important comment
#import <UIKit/UIKit.h>
@class EmployeeRecord;

@protocol AddEmployeeDelegate <NSObject>
@optional
- (void) canceledAddEmployeeViewController;

- (void) addedNewEmployeeRecord: (EmployeeRecord *) record;

- (void) editedEmployeedRecord;
@end

@interface AddEmployeeViewController : UIViewController
@property (nonatomic, weak) id<AddEmployeeDelegate> delegate;
@property (nonatomic, strong) EmployeeRecord *myRecord;
@end
