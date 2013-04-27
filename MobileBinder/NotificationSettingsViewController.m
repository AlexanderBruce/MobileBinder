/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "NotificationSettingsViewController.h"
#import "ReminderCenter.h"
#import "PayrollModel.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import "Reminder.h"

#define INDEX_PATH_USER_DEFAULTS_KEY @"NotifcationSettings row=%d,section=%d"

@interface NotificationSettingsViewController () <UITableViewDataSource, UITableViewDelegate, PayrollModelDelegate>

@property (strong, nonatomic) PayrollModel *model;
@property (nonatomic, strong) NSMutableDictionary *sectionsToHeader;
@property (nonatomic, strong) NSMutableDictionary *sectionsToRowText;
@property (nonatomic, strong) NSMutableDictionary *indexPathsToTypeIdArray;
@property (nonatomic, strong) NSMutableDictionary *indexPathsToSwitches;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation NotificationSettingsViewController

- (IBAction)donePressed:(id)sender
{
    MBProgressHUD *progressIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES fontSize:PROGRESS_INDICATOR_LABEL_FONT_SIZE];
    progressIndicator.animationType = MBProgressHUDAnimationFade;
    progressIndicator.mode = MBProgressHUDModeIndeterminate;
    progressIndicator.labelText = @"Saving settings";
    progressIndicator.dimBackground = NO;
    progressIndicator.taskInProgress = YES;
    progressIndicator.removeFromSuperViewOnHide = YES;
    progressIndicator.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    NSMutableArray *typeIDsToRemove = [[NSMutableArray alloc] init];
    NSMutableArray *typeIDsToAdd = [[NSMutableArray alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (NSIndexPath *indexPath in [self.indexPathsToTypeIdArray allKeys])
    {
        UISwitch *switchView = [self.indexPathsToSwitches objectForKey:indexPath];
        NSString *indexPathKey = [NSString stringWithFormat:INDEX_PATH_USER_DEFAULTS_KEY,indexPath.row,indexPath.section];
        BOOL oldSetting = [defaults boolForKey:indexPathKey];
        BOOL newSetting = switchView.isOn;
        NSArray *typeIds = [self.indexPathsToTypeIdArray objectForKey:indexPath];
        if(oldSetting == YES && newSetting == NO)
        {
            [typeIDsToRemove addObjectsFromArray:typeIds];
        }
        else if(oldSetting == NO && newSetting == YES)
        {
            [typeIDsToAdd addObjectsFromArray:typeIds];
        }
        [defaults setBool:switchView.isOn forKey:indexPathKey];
    }
    [defaults synchronize];
    
    __weak UIView *view = self.view;
    __weak id<SettingsDelegate> delegate = self.delegate;
    __weak UIViewController *viewController = self;
    [self.model addRemindersForTypeIDs:typeIDsToAdd andCancelRemindersForTypeIDs:typeIDsToRemove completion:^{
        view.userInteractionEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        [delegate savedSettingsForViewController:viewController];
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
}

#define BIWEEKLY_SECTION 0
- (void) createBiweeklySection
{
    //Section 0 Biweekly
    [self.sectionsToRowText setObject:[NSArray arrayWithObjects:@"Pay Period",@"Pay Date", @"Employee Card Lock", @"Supervisor Card Lock",@"Gross Adjustments Due",@"Forms Due", nil] forKey:[NSNumber numberWithInt:BIWEEKLY_SECTION]];
    [self.sectionsToHeader setObject:@"Biweekly" forKey:[NSNumber numberWithInt:BIWEEKLY_SECTION]];
    
    //Row 0
    NSArray *payPeriodTypeIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:BIWEEKLY_PAYPERIOD_BEGIN_DATE_TYPEID], [NSNumber numberWithInt:BIWEEKLY_PAYPERIOD_END_DATE_TYPEID], nil ];
    [self.indexPathsToTypeIdArray setObject:payPeriodTypeIds forKey:[NSIndexPath indexPathForRow:0 inSection:BIWEEKLY_SECTION]];
    
    //Row 1
    NSArray *payDateTypeIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:BIWEEKLY_PAYDATE_TYPEID], nil];
    [self.indexPathsToTypeIdArray setObject:payDateTypeIds forKey:[NSIndexPath indexPathForRow:1 inSection:BIWEEKLY_SECTION]];
    
    //Row 2
    NSArray *employeeTimeCardTypeIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:BIWEEKLY_ETIMECARD_LOCK_EMPLOYEE_TYPEID], nil];
    [self.indexPathsToTypeIdArray setObject:employeeTimeCardTypeIds forKey:[NSIndexPath indexPathForRow:2 inSection:BIWEEKLY_SECTION]];
    
    //Row 3
    NSArray *supervisorTimeCardTypeIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:BIWEEKLY_ETIMECARD_LOCK_SUPERVISOR_TYPEID], nil];
    [self.indexPathsToTypeIdArray setObject:supervisorTimeCardTypeIds forKey:[NSIndexPath indexPathForRow:3 inSection:BIWEEKLY_SECTION]];
    
    //Row 4
    NSArray *grossAdjustmentsTypeIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:BIWEEKLY_GROSS_ADJUSTMENTS_TYPEID], nil];
    [self.indexPathsToTypeIdArray setObject:grossAdjustmentsTypeIds forKey:[NSIndexPath indexPathForRow:4 inSection:BIWEEKLY_SECTION]];
    
    //Row 5
    NSArray *formsDueTypeIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:BIWEEKLY_MANAGEMENTCENTER_FORMS_TYPEID],[NSNumber numberWithInt:BIWEEKLY_DRH_HR_FORMS_TYPEID],[NSNumber numberWithInt:BIWEEKLY_IFORMS_TYPEID], nil];
    [self.indexPathsToTypeIdArray setObject:formsDueTypeIds forKey:[NSIndexPath indexPathForRow:5 inSection:BIWEEKLY_SECTION]];
}

#define MONTHLY_SECTION 1
- (void) createMonthlySection
{
    //Section 1 Monthly
    [self.sectionsToRowText setObject:[NSArray arrayWithObjects:@"Pay Date",@"Mgmt. Center Forms",@"DRH HR Forms",@"Leave of Absence Forms",@"Pay Exception Forms",@"iForms",@"Time/Atnd. Closing" ,nil] forKey:[NSNumber numberWithInt:MONTHLY_SECTION]];
    [self.sectionsToHeader setObject:@"Monthly" forKey:[NSNumber numberWithInt:MONTHLY_SECTION]];
    
    //Row 0
    NSArray *monthlyPayDateTypeIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:MONTHLY_PAY_DATE_TYPEID], nil];
    [self.indexPathsToTypeIdArray setObject:monthlyPayDateTypeIds forKey:[NSIndexPath indexPathForRow:0 inSection:MONTHLY_SECTION]];
    
    //Row 1
    NSArray *mgmtFormsTypeIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:MONTHLY_MANAGEMENTCENTER_FORMS_TYPEID], nil];
    [self.indexPathsToTypeIdArray setObject:mgmtFormsTypeIds forKey:[NSIndexPath indexPathForRow:1 inSection:MONTHLY_SECTION]];
    
    //Row 2
    NSArray *drhFormsTypeIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:MONTHLY_DRH_HR_FORMS_TYPEID], nil];
    [self.indexPathsToTypeIdArray setObject:drhFormsTypeIds forKey:[NSIndexPath indexPathForRow:2 inSection:MONTHLY_SECTION]];
    
    //Row 3
    NSArray *loaFormsTypeIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:MONTHLY_LEAVE_ABSENCE_FORMS_TYPEID], nil];
    [self.indexPathsToTypeIdArray setObject:loaFormsTypeIds forKey:[NSIndexPath indexPathForRow:3 inSection:MONTHLY_SECTION]];
    
    //Row 4
    NSArray *payExceptionTypeIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:MONTHLY_PAYEXCEPTION_FORMS_TYPEID], nil];
    [self.indexPathsToTypeIdArray setObject:payExceptionTypeIds forKey:[NSIndexPath indexPathForRow:4 inSection:MONTHLY_SECTION]];
    
    //Row 5
    NSArray *iFormsTypeIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:MONTHLY_IFORMS_TYPEID], nil];
    [self.indexPathsToTypeIdArray setObject:iFormsTypeIds forKey:[NSIndexPath indexPathForRow:5 inSection:MONTHLY_SECTION]];
    
    //Row 6
    NSArray *timeAttendanceClosingTypeIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:MONTHLY_TIME_CLOSING_PTO_FORMS_TYPEID],nil];
    [self.indexPathsToTypeIdArray setObject:timeAttendanceClosingTypeIds forKey:[NSIndexPath indexPathForRow:6 inSection:MONTHLY_SECTION]];
}

- (void) createSwitches
{
    //Create switches and restore their values from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.indexPathsToSwitches = [[NSMutableDictionary alloc] init];
    for (NSIndexPath *indexPath in [self.indexPathsToTypeIdArray allKeys])
    {
        UISwitch *switchView = [[UISwitch alloc] init];
        NSString *indexPathKey = [NSString stringWithFormat:INDEX_PATH_USER_DEFAULTS_KEY,indexPath.row,indexPath.section];
        [switchView setOn:[defaults boolForKey:indexPathKey]];
        [self.indexPathsToSwitches setObject:switchView forKey:indexPath];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionsToRowText.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rows = [self.sectionsToRowText objectForKey:[NSNumber numberWithInt:section]];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *rows = [self.sectionsToRowText objectForKey:[NSNumber numberWithInt:indexPath.section]];
    cell.textLabel.text = [rows objectAtIndex:indexPath.row];
        
    CGRect switchFrame = CGRectMake(225, 10, 0, 0);
    UISwitch *mySwitch = [self.indexPathsToSwitches objectForKey:indexPath];
    mySwitch.frame = switchFrame;
    [cell addSubview:mySwitch];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionsToHeader objectForKey:[NSNumber numberWithInt:section]];
}

- (void) doneInitializingPayrollModel
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    self.tableView.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.hidden = YES;
    self.model = [[PayrollModel alloc] init];
    [self.model initializeModelWithDelegate:self];
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectZero];
    UIBarButtonItem *tmpButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tmpView];
    self.navigationItem.leftBarButtonItem = tmpButtonItem;
    

    self.sectionsToRowText = [[NSMutableDictionary alloc] init];
    self.indexPathsToTypeIdArray = [[NSMutableDictionary alloc] init];
    self.sectionsToHeader = [[NSMutableDictionary alloc] init];
    
    [self createBiweeklySection];
    [self createMonthlySection];
    [self createSwitches];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}
@end

