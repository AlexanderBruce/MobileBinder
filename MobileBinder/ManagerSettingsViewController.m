/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
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
}

- (void) doneRetrievingEmployeeRecords
{
    if (self.tryingToAddEmployees)
    {
        self.tryingToAddEmployees = NO;
        UIView *view = self.view;
        id<SettingsDelegate> delegate = self.delegate;
        UIViewController *mySelf = self;
        [self.myModel addEmployeesWithSupervisorID:self.idField.text completition:^{
            [Database saveDatabase];
            view.userInteractionEnabled = YES;
            [MBProgressHUD hideAllHUDsForView:view animated:YES];
            [delegate savedSettingsForViewController:mySelf];
            [mySelf.navigationController popViewControllerAnimated:YES];
        }];

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
        NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:MANAGER_NAME];
        if(!name) name = @"";
        self.nameField.text = name;
    }
    else if([indexPath isEqual:ID_INDEX_PATH])
    {
        cell.textLabel.text = ID_LABEL;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        self.idField = textField;
        NSString *managerID = [[NSUserDefaults standardUserDefaults] objectForKey:MANAGER_ID];
        if(!managerID)  managerID = @"";
        self.idField.text = managerID;
    }
    else if([indexPath isEqual: TITLE_INDEX_PATH])
    {
        cell.textLabel.text = TITLE_LABEL;
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        textField.keyboardType = UIKeyboardAppearanceDefault;
        self.titleField = textField;
        NSString *managerTitle = [[NSUserDefaults standardUserDefaults] objectForKey:MANAGER_TITLE];
        if(!managerTitle) managerTitle = @"";
        self.titleField.text = managerTitle;
    }
    else if([indexPath isEqual: EMAIL_INDEX_PATH])
    {
        cell.textLabel.text = EMAIL_LABEL;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        self.emailField = textField;
        NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:MANAGER_EMAIL_KEY];
        if (!email) email = @"";
        self.emailField.text = email;
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL alreadyAddedManagerID = [defaults boolForKey:MANAGER_ID_ALREADY_ADDED_KEY];
    if(alreadyAddedManagerID)
    {
        NSString *oldManagerId = [defaults objectForKey:MANAGER_ID];
        if(![self.idField.text isEqualToString:oldManagerId])
        {
            UIAlertView *notifyIDChange = [[UIAlertView alloc] initWithTitle:@"Import Options" message:@"Do you wish to import employees for this manager ID?" delegate:self cancelButtonTitle:@"Don't import" otherButtonTitles:@"Import",  nil];//@"Replace Old ID's Employees",@"Clear and Import",
            notifyIDChange.tag = ID_CHANGE_ALERT_TAG;
            [notifyIDChange show];
            [defaults setObject:self.idField.text forKey:MANAGER_ID];
            [defaults synchronize];
        }
        else
        {
            [self.delegate savedSettingsForViewController:self];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        [self importEmployees];
        
        [defaults setObject:self.idField.text forKey:MANAGER_ID];
        [defaults setBool:YES forKey:MANAGER_ID_ALREADY_ADDED_KEY];
        [defaults synchronize];
    }
}

- (void) importEmployees
{
    MBProgressHUD *progressIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES fontSize:PROGRESS_INDICATOR_LABEL_FONT_SIZE];
    progressIndicator.animationType = MBProgressHUDAnimationFade;
    progressIndicator.mode = MBProgressHUDModeIndeterminate;
    progressIndicator.labelText = @"Updating...";
    progressIndicator.dimBackground = NO;
    progressIndicator.taskInProgress = YES;
    progressIndicator.removeFromSuperViewOnHide = YES;
    self.view.userInteractionEnabled = NO;
    
    if(self.myModel.isInitialized)
    {
        UIView *view = self.view;
        id<SettingsDelegate> delegate = self.delegate;
        UIViewController *mySelf = self;
        [self.myModel addEmployeesWithSupervisorID:self.idField.text completition:^{
            [Database saveDatabase];
            view.userInteractionEnabled = YES;
            [MBProgressHUD hideAllHUDsForView:view animated:YES];
            [delegate savedSettingsForViewController:mySelf];
            [mySelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    else
    {
        self.tryingToAddEmployees = YES;
    }
}



- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ID_CHANGE_ALERT_TAG)
    {
        if(buttonIndex == 1)
        {
            [self importEmployees];
        }
        else
        {
            [self.delegate savedSettingsForViewController:self];
            [self.navigationController popViewControllerAnimated:YES];
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
