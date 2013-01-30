#import "EmployeeViewController.h"
#import "EmployeeRecord.h"
#import "IncidentViewController.h"

@interface EmployeeViewController()
@property (weak, nonatomic) IBOutlet UIScrollView *absencesScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *tardiesScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *otherScrollView;
@end

@implementation EmployeeViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[IncidentViewController class]])
    {
        IncidentViewController *dest = segue.destinationViewController;
        dest.employeeRecord = self.employeeRecord;
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.title = self.employeeRecord.lastName;
}

- (void)viewDidUnload
{
    [self setAbsencesScrollView:nil];
    [self setTardiesScrollView:nil];
    [self setOtherScrollView:nil];
    [super viewDidUnload];
}
@end
