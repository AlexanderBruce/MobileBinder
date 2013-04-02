#import "WelcomeViewController.h"
#import "PayrollNotificationsViewController.h"

#define PROCEED_ALERT_TAG 2

#define WELCOME_SECTION 0
#define RECOMMEND_SECTION 1
#define OPTIONAL_SECTION 2
#define WELCOME_HEADER @"Welcome to the Mobile Binder! Before you begin, please customize these settings so this app can best serve your needs."
#define OPTIONAL_HEADER @"Optional"
#define RECOMMEND_HEADER @"Recommended"


@interface WelcomeViewController () <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *rowTitles;
@property (nonatomic, strong) NSDictionary *viewControllersForRows;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *completedRows;
@end

@implementation WelcomeViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSArray *values = [[NSArray alloc] initWithObjects:@"Notifications",@"Manager Details", nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0], nil];
    self.rowTitles = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    values = [[NSArray alloc] initWithObjects:@"notificationSettings",@"managerSettings", nil];
    self.viewControllersForRows = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    self.completedRows = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
}

- (void) savedSettingsForViewController:(UIViewController *)viewController
{
    [self.completedRows addObject:self.selectedIndexPath];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    NSString *storyboardName = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"iPad" : @"iPhone";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    NSString *vcIdentifier = [self.viewControllersForRows objectForKey:indexPath];
    UIViewController<SettingsViewController> *viewController = [storyboard instantiateViewControllerWithIdentifier:vcIdentifier];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrototypeCell"];
    cell.textLabel.text = [self.rowTitles objectForKey:indexPath];
    if([self.completedRows containsObject:indexPath]) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == WELCOME_SECTION) return 0;
    else if (section == RECOMMEND_SECTION) return 2;
    else if (section ==)
    else return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == WELCOME_SECTION) return WELCOME_HEADER;
    else if(
    else return @"";
}

- (IBAction)proceedPressed:(id)sender
{
    if(self.completedRows.count < [self.viewControllersForRows allKeys].count)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to proceed" message:@"You have uncompleted settings which may limit this app's functionality" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Proceed", nil];
        alert.tag = PROCEED_ALERT_TAG;
        [alert show];
    }
    else
    {
        //Dismiss ourselves because this VC is modally embedded in a UINavigation Controller
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == PROCEED_ALERT_TAG)
    {
        if(buttonIndex == 1)
        {
            //Dismiss ourselves because this VC is modally embedded in a UINavigation Controller
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
