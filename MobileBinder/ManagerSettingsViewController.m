#import "ManagerSettingsViewController.h"
#import "Constants.h"

@interface ManagerSettingsViewController () <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITextField *emailField;
@end

@implementation ManagerSettingsViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrototypeCell"];
    else cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = @"E-mail";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.emailField = [[UITextField alloc] init];
    
    float xOrigin = 72;
    float yOrigin = 10;
    float width = cell.contentView.frame.size.width - xOrigin - 7;
    float height = cell.contentView.frame.size.height - yOrigin - 5;
    self.emailField.frame = CGRectMake(xOrigin, yOrigin, width , height );
    self.emailField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.delegate = self;
    [cell.contentView addSubview:self.emailField];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"Occasionally, the app will send auto-generated documents to this e-mail";
}

- (IBAction)savePressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.emailField.text forKey:MANAGER_EMAIL_KEY];
    [defaults synchronize];
    [self.delegate savedSettingsForViewController:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
