#import "EmployeeViewController.h"
#import "EmployeeRecord.h"
#import "Database.h"
#import "IncidentViewController.h"
#import "AddEmployeeViewController.h"
#import "AttendanceModel.h"

#define ABSENCES_SECTION 0
#define ABSENCES_HEADER @"Unscheduled Absences"

#define TARDIES_SECTION 1
#define TARDIES_HEADER @"Tardies"

#define SWIPES_SECTION 2
#define SWIPES_HEADER @"Missed Swipes"

#define INCIDENT_SECTION 3
#define INCIDENT_SEGUE @"reportIncidentSegue"

#define EDIT_EMPLOYEE_SECTION 3
#define EDIT_EMPLOYEE_SEGUE @"EditEmployeeSegue"

#define DELETE_SECTION 4

#define DEFAULT_CELL_HEIGHT 38
#define INCIDENT_CELL_HEIGHT 42

@interface EmployeeViewController() <UITableViewDataSource, UITableViewDelegate, AddEmployeeDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, strong) NSMutableArray *expandedSections;
@end

@implementation EmployeeViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[IncidentViewController class]])
    {
        IncidentViewController *dest = segue.destinationViewController;
        dest.employeeRecord = self.employeeRecord;
    }
    else if([segue.destinationViewController isKindOfClass:[AddEmployeeViewController class]])
    {
        AddEmployeeViewController *dest = segue.destinationViewController;
        dest.myRecord = self.employeeRecord;
        dest.delegate = self;
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == DELETE_SECTION)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Delete Cell"];
        if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Delete Cell"];
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"Delete Button.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
        cell.backgroundView = backgroundImage;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = @"Delete Employee";
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrototypeCell"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == INCIDENT_SECTION)
    {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"Report an incident";
        }
        else
        {
            cell.textLabel.text = @"Change Employee Info";
        }
    }

    else
    {
        BOOL sectionIsExpanded = [self.expandedSections containsObject:[NSNumber numberWithInt:indexPath.section]];
        int numOfDataCellsInExpandedMode = 0;

        if(indexPath.section == ABSENCES_SECTION)
        {
            NSArray *absences = self.employeeRecord.absences;
            numOfDataCellsInExpandedMode = absences.count;
            if(sectionIsExpanded && indexPath.row > 0)
            {
                NSDate *absenceForRow = [absences objectAtIndex:indexPath.row - 1];
                cell.textLabel.text = [formatter stringFromDate:absenceForRow];
            }
            else if(absences.count == 0)
            {
                cell.textLabel.text = @"No absences reported";
            }
        }
        else if(indexPath.section == TARDIES_SECTION)
        {
            NSArray *tardies = self.employeeRecord.tardies;
            numOfDataCellsInExpandedMode = tardies.count;
            if(sectionIsExpanded && indexPath.row > 0)
            {
                NSDate *tardyForRow = [tardies objectAtIndex:indexPath.row - 1];
                cell.textLabel.text = [formatter stringFromDate:tardyForRow];
            }
            else if(tardies.count == 0)
            {
                cell.textLabel.text = @"No tardies reported";
            }
        }
        else if(indexPath.section == SWIPES_SECTION)
        {
            NSArray *swipes = self.employeeRecord.missedSwipes;
            numOfDataCellsInExpandedMode = swipes.count;
            if(sectionIsExpanded && indexPath.row > 0)
            {
                NSDate *swipeForRow = [swipes objectAtIndex:indexPath.row - 1];
                cell.textLabel.text = [formatter stringFromDate:swipeForRow];
            }
            else if(swipes.count == 0)
            {
                cell.textLabel.text = @"No missed swipes reported";
            }
        }
        
        if(numOfDataCellsInExpandedMode > 0 && indexPath.row == 0)
        {
            if(sectionIsExpanded)
            {
                cell.textLabel.text = @"Collapse";
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Up_Arrow.png"]];
            }
            else
            {
                cell.textLabel.text = [NSString stringWithFormat: @"View All (%d)",numOfDataCellsInExpandedMode];
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Down_Arrow.png"]];
            }
        }
    }
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == ABSENCES_SECTION)
    {
        return ABSENCES_HEADER;
    }
    else if(section == TARDIES_SECTION)
    {
        return TARDIES_HEADER;
    }
    else if(section == SWIPES_SECTION)
    {
        return SWIPES_HEADER;
    }
    else return @"";
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL sectionIsExpanded = [self.expandedSections containsObject:[NSNumber numberWithInt:section]];
    if(section == ABSENCES_SECTION)
    {
        return (sectionIsExpanded) ? [self.employeeRecord getNumberOfAbsencesInPastYear] + 1 : 1;
    }
    else if(section == TARDIES_SECTION)
    {
        return (sectionIsExpanded) ? [self.employeeRecord getNumberOfTardiesInPastYear] + 1 : 1;
    }
    else if(section == SWIPES_SECTION)
    {
        return (sectionIsExpanded) ? [self.employeeRecord getNumberOfMissedSwipesInPastYear] + 1: 1;
    }
    else if(section == INCIDENT_SECTION) return 2;
    else return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == INCIDENT_SECTION) return INCIDENT_CELL_HEIGHT;
    else return DEFAULT_CELL_HEIGHT;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == DELETE_SECTION)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Are you sure you want to delete %@ %@",self.employeeRecord.firstName,self.employeeRecord.lastName] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
    else if(indexPath.section == INCIDENT_SECTION)
    {
        if (indexPath.row==0)
        {
            [self performSegueWithIdentifier:INCIDENT_SEGUE sender:self];
        }
        else [self performSegueWithIdentifier:EDIT_EMPLOYEE_SEGUE sender:self];
    }
    else
    {
        BOOL sectionIsExpanded = [self.expandedSections containsObject:[NSNumber numberWithInt:indexPath.section]];
        int numOfDataCellsInExpandedMode = 0;
        if(indexPath.section == ABSENCES_SECTION) numOfDataCellsInExpandedMode = [self.employeeRecord getNumberOfAbsencesInPastYear];
        else if(indexPath.section == TARDIES_SECTION) numOfDataCellsInExpandedMode = [self.employeeRecord getNumberOfTardiesInPastYear];
        else if(indexPath.section == SWIPES_SECTION) numOfDataCellsInExpandedMode = [self.employeeRecord getNumberOfMissedSwipesInPastYear];
        if(sectionIsExpanded)
        {
            if(indexPath.row == 0) //Tapped collapse cell
            {
                [self.expandedSections removeObject:[NSNumber numberWithInt:indexPath.section]];
                NSMutableArray *rowsToDelete = [[NSMutableArray alloc] init];
                for(int i = numOfDataCellsInExpandedMode; i > 0; i--)
                {
                    [rowsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                }
                [self.myTableView beginUpdates];
                [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
                [self.myTableView deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:UITableViewRowAnimationFade];
                [self.myTableView endUpdates];
            }
        }
        else
        {
            [self.expandedSections addObject:[NSNumber numberWithInt:indexPath.section]];

            NSMutableArray *newRows = [[NSMutableArray alloc] init];
            for(int i = 1; i <= numOfDataCellsInExpandedMode; i++ )
            {
                [newRows addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
            }
            [self.myTableView beginUpdates];
            [self.myTableView insertRowsAtIndexPaths:newRows withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.myTableView endUpdates];


        }
    }

}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == INCIDENT_SECTION) return NO;
    if(indexPath.row > 0) return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if(indexPath.section == ABSENCES_SECTION)
        {
            [self.employeeRecord removeAbsence:[self.employeeRecord.absences objectAtIndex:indexPath.row - 1]];
            if([self.employeeRecord getNumberOfAbsencesInPastYear] == 0) [self.expandedSections removeObject:[NSNumber numberWithInt:ABSENCES_SECTION]];
        }
        else if(indexPath.section == TARDIES_SECTION)
        {
            [self.employeeRecord removeTardy:[self.employeeRecord.tardies objectAtIndex:indexPath.row - 1]];
            if([self.employeeRecord getNumberOfTardiesInPastYear] == 0) [self.expandedSections removeObject:[NSNumber numberWithInt:TARDIES_SECTION]];
        }
        else if(indexPath.section == SWIPES_SECTION)
        {
            [self.employeeRecord removeMissedSwipes:[self.employeeRecord.missedSwipes objectAtIndex:indexPath.row - 1]];
            if([self.employeeRecord getNumberOfMissedSwipesInPastYear] == 0) [self.expandedSections removeObject:[NSNumber numberWithInt:SWIPES_SECTION]];
        }
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        [self checkEnablingOfEditButton];
        [Database saveDatabase];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.destructiveButtonIndex)
    {
        [self.myModel deleteEmployeeRecord:self.employeeRecord];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (IBAction)editPressed:(UIBarButtonItem *)sender
{
    if(self.myTableView.editing)
    {
        [self.editButton setTitle:@"Edit"];
        [self.myTableView setEditing:NO animated:YES];
    }
    else
    {
        [self.editButton setTitle:@"Done"];
        [self.myTableView setEditing:YES animated:YES];
    }
}

- (void) checkEnablingOfEditButton
{
    if(self.employeeRecord.absences.count > 0 || self.employeeRecord.tardies.count > 0 || self.employeeRecord.missedSwipes.count > 0)
    {
        self.editButton.enabled = YES;
    }
    else
    {
        [self.editButton setTitle:@"Edit"];
        [self.myTableView setEditing:NO animated:YES];
        self.editButton.enabled = NO;
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.allowsSelectionDuringEditing = YES;
    self.expandedSections = [[NSMutableArray alloc] init];
    self.title = self.employeeRecord.lastName;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.myTableView reloadData];
    [self checkEnablingOfEditButton];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self.myTableView setEditing:NO];
}

- (void)viewDidUnload
{
    [self editPressed:nil];
    [super viewDidUnload];
}

- (void) editedEmployeedRecord
{
    [self dismissModalViewControllerAnimated:YES];
    self.title = self.employeeRecord.lastName;
}

- (void) canceledAddEmployeeViewController
{
    [self dismissModalViewControllerAnimated:YES];
    self.title = self.employeeRecord.lastName;
}

@end
