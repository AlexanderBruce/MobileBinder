#import "RoundingAllLogsViewController.h"
#import "RoundingOverviewViewController.h"
#import "RoundingModel.h"
#import "RoundingLog.h"

#define ROUNDING_LOG_OVERVIEW_SEGUE @"roundingLogOverviewSegue"

@interface RoundingAllLogsViewController () <RoundingModelDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RoundingModel *model;
@property (nonatomic, strong) RoundingLog *selectedLog;

@end

@implementation RoundingAllLogsViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[RoundingOverviewViewController class]])
    {
        RoundingOverviewViewController *dest = segue.destinationViewController;
        dest.log = self.selectedLog;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PrototypeCell"];
    NSArray *logs = [self.model getRoundingLogs];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    RoundingLog *currentLog = [logs objectAtIndex:indexPath.row];
    
    //Create label text for cell
    NSMutableString *labelText = [@"" mutableCopy];
    
    if(currentLog.date) [labelText appendString:[formatter stringFromDate:currentLog.date]];
    if(currentLog.date && currentLog.unit.length > 0) [labelText appendFormat:@": %@", currentLog.unit];
    else if(currentLog.unit.length > 0) [labelText appendFormat:@"%@",currentLog.unit];
    if((currentLog.date || currentLog.unit.length > 0) && currentLog.leader.length > 0) [labelText appendFormat:@" (%@)",currentLog.leader];
    else if(currentLog.leader.length > 0) [labelText appendFormat:@"(%@)",currentLog.leader];
    cell.textLabel.text = labelText;
    
    //Create detail text for cell
    NSString *detailText = @"";
    if(currentLog.keyFocus.length > 0) detailText = currentLog.keyFocus;
    else if(currentLog.keyReminders.length > 0) detailText = currentLog.keyReminders;
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model getRoundingLogs].count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedLog = [[self.model getRoundingLogs] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:ROUNDING_LOG_OVERVIEW_SEGUE sender:self];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSArray *roundingLogs = [self.model getRoundingLogs];
        RoundingLog *logToDelete = [roundingLogs objectAtIndex:indexPath.row];
        [self.model deleteRoundingLog: logToDelete];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row < [self.model getRoundingLogs].count);
}


- (IBAction)addLogPressed:(UIBarButtonItem *)sender
{
    self.selectedLog = [self.model addNewRoundingLog];
    [self performSegueWithIdentifier:ROUNDING_LOG_OVERVIEW_SEGUE sender:self];
}

- (void) doneRetrievingRoundingLogs
{
    [self.tableView reloadData];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.model = [[RoundingModel alloc] init];
    self.model.delegate = self;
    [self.model fetchRoundingLogsForFutureUse];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
