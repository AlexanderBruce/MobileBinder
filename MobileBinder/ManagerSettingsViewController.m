#import "ManagerSettingsViewController.h"
#import "Constants.h"
#import "AttendanceModel.h"
#import "MBProgressHUD.h"
#import "Database.h"


#define NAME_INDEX_PATH [NSIndexPath indexPathForRow:0 inSection:0]
#define NAME_LABEL @"Name"

#define ID_INDEX_PATH [NSIndexPath indexPathForRow:1 inSection:0]
#define ID_LABEL @"ID"

#define TITLE_INDEX_PATH [NSIndexPath indexPathForRow:2 inSection:0]
#define TITLE_LABEL @"Title"

#define EMAIL_INDEX_PATH [NSIndexPath indexPathForRow:3 inSection:0]
#define EMAIL_LABEL @"E-mail"

#define ID_CHANGE_ALERT_TAG 2


#define FOOTER_TEXT @"This information will be used to auto-populate documents throughout this app"

@interface ManagerSettingsViewController () <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, AttendanceModelDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *idField;
@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) AttendanceModel *myModel;
@property (atomic) BOOL tryingToAddEmployees;
@property (nonatomic) BOOL isWelcomeScreen;
@end

@implementation ManagerSettingsViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectZero];
    UIBarButtonItem *tmpButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tmpView];
    self.navigationItem.leftBarButtonItem = tmpButtonItem;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    self.myModel = [[AttendanceModel alloc] init];
    self.myModel.delegate = self;
    [self.myModel fetchEmployeeRecordsForFutureUse];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (!([defaults objectForKey:MANAGER_ID]||[defaults objectForKey:MANAGER_NAME]||[defaults objectForKey:MANAGER_EMAIL_KEY]))
    {
        self.isWelcomeScreen = YES;
    }
    else
    {
        self.isWelcomeScreen = NO;
    }
}

- (void) doneRetrievingEmployeeRecords
{
    //If boolean is true then add employees
    //Else don't
    if (self.tryingToAddEmployees)
    {
        [self.myModel addEmployeesWithSupervisorID:self.idField.text];
        [Database saveDatabase];
        self.tryingToAddEmployees = NO;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.delegate savedSettingsForViewController:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        
    }
}

- (void) hideKeyboard
{
    [self.tableView endEditing:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrototypeCell"]; //Dont deque so we don't have to worry about mixing up the textfields
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Create textfield
    UITextField *textField = [[UITextField alloc] init];
    float xOrigin = 72;
    float yOrigin = 0;
    float width = cell.contentView.frame.size.width - xOrigin - 7;
    float height = cell.contentView.frame.size.height - yOrigin;
    textField.frame = CGRectMake(xOrigin, yOrigin, width , height );
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;

    if([indexPath isEqual: NAME_INDEX_PATH])
    {
        cell.textLabel.text = NAME_LABEL;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        textField.keyboardType = UIKeyboardAppearanceDefault;
        self.nameField = textField;
        self.nameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:MANAGER_NAME];
    }
    else if([indexPath isEqual:ID_INDEX_PATH])
    {
        cell.textLabel.text = ID_LABEL;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        self.idField = textField;
        self.idField.text = [[NSUserDefaults standardUserDefaults] objectForKey:MANAGER_ID];
    }
    else if([indexPath isEqual: TITLE_INDEX_PATH])
    {
        cell.textLabel.text = TITLE_LABEL;
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        textField.keyboardType = UIKeyboardAppearanceDefault;
        self.titleField = textField;
        self.titleField.text = [[NSUserDefaults standardUserDefaults] objectForKey:MANAGER_TITLE];
    }
    else if([indexPath isEqual: EMAIL_INDEX_PATH])
    {
        cell.textLabel.text = EMAIL_LABEL;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        self.emailField = textField;
        self.emailField.text = [[NSUserDefaults standardUserDefaults] objectForKey:MANAGER_EMAIL_KEY];
    }
    [cell.contentView addSubview:textField];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return FOOTER_TEXT;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(textField == self.nameField)
    {
        [defaults setObject:self.nameField.text forKey:MANAGER_NAME];
    }
    else if(textField == self.idField)
    {
        //Should check to make sure it matches UID format
    }
    
    else if(textField == self.titleField)
    {
        [defaults setObject:self.titleField.text forKey:MANAGER_TITLE];
    }
    else if(textField == self.emailField)
    {
        [defaults setObject:self.emailField.text forKey:MANAGER_EMAIL_KEY];
    }
    [defaults synchronize];
}

- (IBAction)donePressed:(id)sender
{
    [self.tableView endEditing:YES];
    if(![self.idField.text isEqual: [[NSUserDefaults standardUserDefaults]objectForKey:MANAGER_ID]]&&!self.isWelcomeScreen){
        UIAlertView *notifyIDChange = [[UIAlertView alloc] initWithTitle:@"Import Options" message:@"You have changed your Unique ID. You have options for importing employees." delegate:self cancelButtonTitle:@"Don't import" otherButtonTitles:@"Import",  nil];//@"Replace Old ID's Employees",@"Clear and Import",
        notifyIDChange.tag = ID_CHANGE_ALERT_TAG;
        [notifyIDChange show];
        [[NSUserDefaults standardUserDefaults] setObject:self.idField.text forKey:MANAGER_ID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [self.delegate savedSettingsForViewController:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ID_CHANGE_ALERT_TAG)
    {
        MBProgressHUD *progressIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES fontSize:PROGRESS_INDICATOR_LABEL_FONT_SIZE];
        progressIndicator.animationType = MBProgressHUDAnimationFade;
        progressIndicator.mode = MBProgressHUDModeIndeterminate;
        progressIndicator.labelText = @"Updating Attendance";
        progressIndicator.dimBackground = NO;
        progressIndicator.taskInProgress = YES;
        progressIndicator.removeFromSuperViewOnHide = YES;
        self.view.userInteractionEnabled = NO;

        if(self.myModel.isInitialized)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.myModel addEmployeesWithSupervisorID:self.idField.text];
            [Database saveDatabase];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            self.tryingToAddEmployees = YES;
        }
    }
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
