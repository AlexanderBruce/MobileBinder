#import <UIKit/UIKit.h>
#import "BackgroundViewController.h"
@class AttendanceModel;
@class EmployeeRecord;

@protocol AddEmployeeDelegate <NSObject>
@optional
- (void) canceledAddEmployeeViewController;

- (void) addedNewEmployeeRecord: (EmployeeRecord *) record;

- (void) editedEmployeedRecord;
@end

@interface AddEmployeeViewController : BackgroundViewController
@property (nonatomic, weak) id<AddEmployeeDelegate> delegate;
@property (nonatomic, strong) EmployeeRecord *myRecord;
@property (nonatomic, strong) AttendanceModel *myModel;
@end
