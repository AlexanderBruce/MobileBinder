#import "AttendanceViewController.h"
#import "AttendanceCell.h"
#import "AttendanceModel.h"
#import "AddEmployeeViewController.h"
#import "EmployeeRecord.h"
#import "EmployeeViewController.h"

#define CUSTOM_CELL_NIB @"AttendanceCell"
#define CUSTOM_CELL_IDENTIFIER @"AttendanceCellIdentifier"
#define VIEW_EMPLOYEE_RECORD_SEGUE @"viewEmployeeRecordSegue"
#define CELL_HEIGHT 119

#define MAX_ABSENCES 8.0
#define MAX_TARDIES 8.0
#define MAX_OTHER 8.0

@interface AttendanceViewController () <UITableViewDataSource, UITableViewDelegate, AttendanceModelDelegate,AddEmployeeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) AttendanceModel *myModel;
@property (nonatomic, strong) EmployeeRecord *selectedEmployeeRecord;
@end

@implementation AttendanceViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[AddEmployeeViewController class]])
    {
        AddEmployeeViewController *dest = segue.destinationViewController;
        dest.delegate = self;
    }
    else if([segue.destinationViewController isKindOfClass:[EmployeeViewController class]])
    {
        EmployeeViewController *dest = segue.destinationViewController;
        dest.employeeRecord = self.selectedEmployeeRecord;
    }
}

#pragma mark - AddEmployeeDelegate
- (void) canceledAddEmployeeViewController
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) addedNewEmployeeRecord: (EmployeeRecord *) record
{
    [self.myModel addEmployeeRecord:record];
    [self.myTableView reloadData];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - AttendanceModelDelegate

- (void) doneRetrievingEmployeeRecords
{
    [self.myTableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttendanceCell *cell = [tableView dequeueReusableCellWithIdentifier:CUSTOM_CELL_IDENTIFIER];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSArray *employeeRecords = [self.myModel getEmployeeRecords];
    EmployeeRecord *recordForRow = [employeeRecords objectAtIndex:indexPath.row];
    [cell updateAbsenceProgress:[recordForRow getNumberOfAbsencesInPastYear] / MAX_ABSENCES];
    [cell updateTardyProgress:([recordForRow getNumberOfTardiesInPastYear] + 1) / MAX_TARDIES];
    [cell updateOtherProgress:([recordForRow getNumberOfOtherInPastYear] + 2) / MAX_OTHER];
    [cell updateFirstName:recordForRow.firstName lastName:recordForRow.lastName];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myModel getNumberOfEmployeeRecords];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedEmployeeRecord = [[self.myModel getEmployeeRecords] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:VIEW_EMPLOYEE_RECORD_SEGUE sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    UINib* customCellNib = [UINib nibWithNibName:CUSTOM_CELL_NIB bundle:nil];
    [self.myTableView registerNib: customCellNib forCellReuseIdentifier:CUSTOM_CELL_IDENTIFIER];
    self.myModel = [[AttendanceModel alloc] init];
    self.myModel.delegate = self;
    [self.myModel fetchEmployeeRecordsForFutureUse];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.myTableView reloadData];
}


- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [super viewDidUnload];
}
@end
