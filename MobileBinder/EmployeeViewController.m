#import "EmployeeViewController.h"
#import "EmployeeRecord.h"
#import "Database.h"
#import "IncidentViewController.h"


#define ABSENCES_SECTION 0
#define ABSENCES_HEADER @"Unscheduled Absences"

#define TARDIES_SECTION 1
#define TARDIES_HEADER @"Tardies"

#define SWIPES_SECTION 2
#define SWIPES_HEADER @"Missed Swipes"

#define INCIDENT_SECTION 3
#define INCIDENT_SEGUE @"reportIncidentSegue"

#define DEFAULT_CELL_HEIGHT 38
#define INCIDENT_CELL_HEIGHT 42

@interface EmployeeViewController() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
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

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrototypeCell"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    if(indexPath.section == ABSENCES_SECTION)
    {
        NSArray *absences = self.employeeRecord.absences;
        if(absences.count == 0)
        {
            cell.textLabel.text = @"No unscheduled absences reported";
        }
        else
        {
            NSDate *absenceForRow = [absences objectAtIndex:indexPath.row];
            cell.textLabel.text = [formatter stringFromDate:absenceForRow];
        }
    }
    else if(indexPath.section == TARDIES_SECTION)
    {
        NSArray *tardies = self.employeeRecord.tardies;
        if(tardies.count == 0)
        {
            cell.textLabel.text = @"No tardies reported";
        }
        else
        {
            NSDate *tardyForRow = [tardies objectAtIndex:indexPath.row];
            cell.textLabel.text = [formatter stringFromDate:tardyForRow];
        }
    }
    else if(indexPath.section == SWIPES_SECTION)
    {
        NSArray *swipes = self.employeeRecord.missedSwipes;
        if(swipes.count == 0)
        {
            cell.textLabel.text = @"No missed swipes reported";
        }
        else
        {
            NSDate *swipeForRow = [swipes objectAtIndex:indexPath.row];
            cell.textLabel.text = [formatter stringFromDate:swipeForRow];
        }
    }
    else if(indexPath.section == INCIDENT_SECTION)
    {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.textLabel.text = @"Report an incident";
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
    if(section == ABSENCES_SECTION)
    {
        return MAX([self.employeeRecord getNumberOfAbsencesInPastYear], 1);
    }
    else if(section == TARDIES_SECTION)
    {
        return MAX([self.employeeRecord getNumberOfTardiesInPastYear], 1);
    }
    else if(section == SWIPES_SECTION)
    {
        return MAX([self.employeeRecord getNumberOfMissedSwipesInPastYear], 1);
    }
    else return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == INCIDENT_SECTION) return INCIDENT_CELL_HEIGHT;
    else return DEFAULT_CELL_HEIGHT;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == INCIDENT_SECTION)
    {
        [self performSegueWithIdentifier:INCIDENT_SEGUE sender:self];
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == INCIDENT_SECTION) return NO;
    if(indexPath.section == ABSENCES_SECTION && [self.employeeRecord getNumberOfAbsencesInPastYear] == 0) return NO;
    if(indexPath.section == TARDIES_SECTION && [self.employeeRecord getNumberOfTardiesInPastYear] == 0) return NO;
    if(indexPath.section == SWIPES_SECTION && [self.employeeRecord getNumberOfMissedSwipesInPastYear] == 0) return NO;
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if(indexPath.section == ABSENCES_SECTION)
        {
            [self.employeeRecord removeAbsence:[self.employeeRecord.absences objectAtIndex:indexPath.row]];
        }
        else if(indexPath.section == TARDIES_SECTION)
        {
            [self.employeeRecord removeTardy:[self.employeeRecord.tardies objectAtIndex:indexPath.row]];
        }
        else if(indexPath.section == SWIPES_SECTION)
        {
            [self.employeeRecord removeMissedSwipes:[self.employeeRecord.missedSwipes objectAtIndex:indexPath.row]];
        }
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self checkEnablingOfEditButton];
        [Database saveAttendanceDatabase];
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
    self.title = self.employeeRecord.lastName;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.myTableView reloadData];
    [self checkEnablingOfEditButton];
}

- (void)viewDidUnload
{
    [self setEditButton:nil];
    [super viewDidUnload];
}
@end
