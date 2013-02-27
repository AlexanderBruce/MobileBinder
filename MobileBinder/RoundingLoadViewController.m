#import "RoundingLoadViewController.h"
#import "RoundingModel.h"
#import "RoundingLog.h"


@interface RoundingLoadViewController () <RoundingModelDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RoundingLoadViewController

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrototypeCell"];
    NSArray *logs = [self.model getRoundingLogs];
    RoundingLog *currentLog = [logs objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",currentLog.date];
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model getRoundingLogs].count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundingLog *selectedLog = [[self.model getRoundingLogs] objectAtIndex:indexPath.row];
    [self.delegate selectedRoundingLog:selectedLog];
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.model fetchRoundingLogsForFutureUse];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
