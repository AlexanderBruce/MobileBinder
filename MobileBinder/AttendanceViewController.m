#import "AttendanceViewController.h"
#import "AttendanceCell.h"
#import "AttendanceModel.h"
#import "AddEmployeeViewController.h"
#import "EmployeeRecord.h"
#import "EmployeeViewController.h"
#import "testNotification.h"

#define CUSTOM_CELL_NIB @"AttendanceCell"
#define CUSTOM_CELL_IDENTIFIER @"AttendanceCellIdentifier"
#define VIEW_EMPLOYEE_RECORD_SEGUE @"viewEmployeeRecordSegue"
#define CELL_HEIGHT 119



@interface AttendanceViewController () <UITableViewDataSource, UITableViewDelegate, AttendanceModelDelegate,AddEmployeeDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) AttendanceModel *myModel;
@property (nonatomic, strong) EmployeeRecord *selectedEmployeeRecord;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
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
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - AttendanceModelDelegate

- (void) doneRetrievingEmployeeRecords
{
    self.addButton.enabled = YES;
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttendanceCell *cell = [tableView dequeueReusableCellWithIdentifier:CUSTOM_CELL_IDENTIFIER];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSArray *employeeRecords = [self.myModel getEmployeeRecords];
    EmployeeRecord *recordForRow = [employeeRecords objectAtIndex:indexPath.row];
    [cell updateFirstName:recordForRow.firstName lastName:recordForRow.lastName department: recordForRow.department];
    
    int absenceLevel = [recordForRow getNextAbsenceLevel];
    [cell updateAbsenceProgress:[recordForRow getNumberOfAbsencesInPastYear] / MAX_ABSENCES withLevel:absenceLevel];
    
    int tardyLevel = [recordForRow getNextTardyLevel];
    [cell updateTardyProgress:([recordForRow getNumberOfTardiesInPastYear]) / MAX_TARDIES withLevel:tardyLevel];
    
    int missedSwipeLevel = [recordForRow getNextMissedSwipeLevel];
    [cell updateMissedSwipesProgress:([recordForRow getNumberOfMissedSwipesInPastYear]) / MAX_MISSED_SWIPES withLevel:missedSwipeLevel];
    
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

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.mySearchBar setShowsCancelButton:YES animated:YES];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.mySearchBar setShowsCancelButton:NO animated:YES];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.mySearchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.mySearchBar resignFirstResponder];
    [self.myModel filterEmployeesByString:searchBar.text];
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        [self.mySearchBar resignFirstResponder];
        [self.myModel stopFilteringEmployees];
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.addButton.enabled = NO;
    UINib* customCellNib = [UINib nibWithNibName:CUSTOM_CELL_NIB bundle:nil];
    [self.myTableView registerNib: customCellNib forCellReuseIdentifier:CUSTOM_CELL_IDENTIFIER];
    self.myModel = [[AttendanceModel alloc] init];
    self.myModel.delegate = self;
    [self.myModel fetchEmployeeRecordsForFutureUse];
    self.mySearchBar.delegate = self;
    testNotification* b = [[testNotification alloc] init];
    [b scheduleNotification];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setMySearchBar:nil];
    [self setAddButton:nil];
    [super viewDidUnload];
}
@end
