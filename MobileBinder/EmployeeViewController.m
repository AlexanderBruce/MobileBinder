#import "EmployeeViewController.h"
#import "EmployeeRecord.h"
#import "IncidentViewController.h"

#define GAP_BETWEEN_LIST_ITEMS 2

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

- (void) viewWillAppear:(BOOL)animated
{
    [self showAbsences];
}

- (void) showAbsences
{
    NSArray *absenceDates = self.employeeRecord.absences;
    NSLog(@"%d absences", absenceDates.count);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    double xOrigin = 0;
    double yOrigin = 0;
    double width = self.absencesScrollView.frame.size.width;
    double height = 40;
    for (NSDate *currentAbsence in absenceDates)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, width, height)];
        label.text = [formatter stringFromDate:currentAbsence];
        yOrigin += height + GAP_BETWEEN_LIST_ITEMS;
        [self.absencesScrollView addSubview:label];
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
