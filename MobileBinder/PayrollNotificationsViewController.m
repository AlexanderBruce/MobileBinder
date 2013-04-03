//
//  payrollNotificationsViewController.m
//  MobileBinder
//
//  Created by Samuel Rang on 1/29/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import "PayrollNotificationsViewController.h"
#import "ReminderCenter.h"
#import "PayrollModel.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import "Reminder.h"

@interface PayrollNotificationsViewController ()

//Temporary testing properties
@property (strong, nonatomic) NSDictionary *payrollNotificationToArrayofTypeIDs;
@property (strong, nonatomic) NSDictionary *payrollNotificationToReminderText;

@property (strong, nonatomic) NSUserDefaults *notificationUserSettings;
@property (strong, nonatomic) NSMutableDictionary *notificationSettingsSectionsAndRows;
@property (strong, nonatomic) NSMutableDictionary *switchesToLabels;
@property (strong, nonatomic) PayrollModel *model;
@end

@implementation PayrollNotificationsViewController

- (IBAction)donePressed:(id)sender
{
    MBProgressHUD *progressIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES fontSize:PROGRESS_INDICATOR_LABEL_FONT_SIZE];
    progressIndicator.animationType = MBProgressHUDAnimationFade;
    progressIndicator.mode = MBProgressHUDModeIndeterminate;
    progressIndicator.labelText = @"Saving settings";
    progressIndicator.dimBackground = NO;
    progressIndicator.taskInProgress = YES;
    progressIndicator.removeFromSuperViewOnHide = YES;
    self.view.userInteractionEnabled = NO;
    
    NSMutableArray *typeIDsToRemove = [[NSMutableArray alloc] init];
    NSMutableArray *typeIDsToAdd = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<[self.notificationSettingsSectionsAndRows.allKeys count]; i++) {
        NSString *notificationSection = [self.notificationSettingsSectionsAndRows.allKeys objectAtIndex:i];
        for (NSInteger j = 0; j<[[self.notificationSettingsSectionsAndRows objectForKey:notificationSection]count]; j++) {
            NSString *notificationLabel = [[self.notificationSettingsSectionsAndRows objectForKey:notificationSection]objectAtIndex:j];
            UISwitch *swtch = [self.switchesToLabels objectForKey:notificationLabel];
            BOOL oldSetting = [self.notificationUserSettings boolForKey:notificationLabel];
            BOOL newSetting = swtch.isOn;
            if((oldSetting == YES) && (newSetting == NO)) //Cancel reminders
            {
                [typeIDsToRemove addObjectsFromArray:[self.payrollNotificationToArrayofTypeIDs objectForKey:notificationLabel]];
            }
            else if((oldSetting == NO) && (newSetting == YES)) //Add new reminders
            {
                NSArray *typeIDs = [self.payrollNotificationToArrayofTypeIDs objectForKey:notificationLabel];
                [typeIDsToAdd addObjectsFromArray:typeIDs];
            }
            [self.notificationUserSettings setBool:[swtch isOn] forKey:notificationLabel];
        }
    }
    
    __weak UIView *view = self.view;
    __weak id<SettingsDelegate> delegate = self.delegate;
    __weak UIViewController *viewController = self;
    [self.model addRemindersForTypeIDs:typeIDsToAdd andCancelRemindersForTypeIDs:typeIDsToRemove completion:^{
        view.userInteractionEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        [delegate savedSettingsForViewController:viewController];
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.notificationUserSettings synchronize];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.model = [[PayrollModel alloc] init];
    self.payrollNotificationToArrayofTypeIDs = [NSMutableDictionary dictionary];
    NSString *BIWEEKLY_HEADING = @"Biweekly Employees";
    NSString *BIWEEKLY_PAY_PERIOD = @"Pay Period";
    [self.payrollNotificationToArrayofTypeIDs setValue:
     [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:BIWEEKLY_PAYPERIOD_BEGIN_DATE_TYPEID], [NSNumber numberWithInt:BIWEEKLY_PAYPERIOD_END_DATE_TYPEID], nil ]forKey:BIWEEKLY_PAY_PERIOD];
    NSString *BIWEEKLY_PAY_DATE = @"Pay Date";
    [self.payrollNotificationToArrayofTypeIDs setValue:
     [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:BIWEEKLY_PAYDATE_TYPEID], nil ]forKey:BIWEEKLY_PAY_DATE];
    NSString *BIWEEKLY_TIME_CARD = @"Time Card Locks";
    [self.payrollNotificationToArrayofTypeIDs setValue:
     [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:BIWEEKLY_ETIMECARD_LOCK_EMPLOYEE_TYPEID], [NSNumber numberWithInt:BIWEEKLY_ETIMECARD_LOCK_SUPERVISOR_TYPEID],[NSNumber numberWithInt:BIWEEKLY_GROSS_ADJUSTMENTS_TYPEID], nil ]forKey:BIWEEKLY_TIME_CARD];
    self.notificationSettingsSectionsAndRows = [NSMutableDictionary dictionary];
    [self.notificationSettingsSectionsAndRows setObject:
     [[NSArray alloc]initWithObjects:BIWEEKLY_PAY_PERIOD,BIWEEKLY_TIME_CARD, BIWEEKLY_PAY_DATE, nil]
                                                 forKey:BIWEEKLY_HEADING];
    
    NSString *MONTHLY_HEADING = @"Monthly Employees";
    NSString *MONTHLY_PAY_DATE = @"Pay Date ";
    [self.payrollNotificationToArrayofTypeIDs setValue:
     [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:MONTHLY_PAY_DATE_TYPEID], nil ]forKey:MONTHLY_PAY_DATE];
    NSString *MONTHLY_LEAVE_FORMS = @"Leave of Absence";
    [self.payrollNotificationToArrayofTypeIDs setValue:
     [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:MONTHLY_LEAVE_ABSENCE_FORMS_TYPEID], nil ]forKey:MONTHLY_LEAVE_FORMS];
    NSString *MONTHLY_PAY_EXEMPTION = @"Pay Exemption";
    [self.payrollNotificationToArrayofTypeIDs setValue:
     [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:MONTHLY_PAYEXCEPTION_FORMS_TYPEID], nil ]forKey:MONTHLY_PAY_EXEMPTION];
    [self.notificationSettingsSectionsAndRows setObject:
     [[NSArray alloc]initWithObjects:MONTHLY_PAY_DATE,MONTHLY_LEAVE_FORMS,MONTHLY_PAY_EXEMPTION, nil]
                                                 forKey:MONTHLY_HEADING];
    
    NSString *FORMS_HEADING = @"Forms Due To";
    NSString *DRH_HR = @"Hospital HR";
    [self.payrollNotificationToArrayofTypeIDs setValue:
     [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:BIWEEKLY_DRH_HR_FORMS_TYPEID], [NSNumber numberWithInt:MONTHLY_DRH_HR_FORMS_TYPEID], nil ]forKey:DRH_HR];
    NSString *MNGMT_CENTERS = @"Management Centers";
    [self.payrollNotificationToArrayofTypeIDs setValue:
     [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:BIWEEKLY_MANAGEMENTCENTER_FORMS_TYPEID], [NSNumber numberWithInt:MONTHLY_MANAGEMENTCENTER_FORMS_TYPEID], nil ]forKey:MNGMT_CENTERS];
    NSString *IFORMS = @"iForms";
    [self.payrollNotificationToArrayofTypeIDs setValue:
     [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:BIWEEKLY_IFORMS_TYPEID], [NSNumber numberWithInt:MONTHLY_IFORMS_TYPEID], nil ]forKey:IFORMS];
    NSString *MONTHLY_PTO_FORMS = @"Time Closing PTO";
    [self.payrollNotificationToArrayofTypeIDs setValue:
     [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:MONTHLY_TIME_CLOSING_PTO_FORMS_TYPEID], nil ]forKey:MONTHLY_PTO_FORMS];
    [self.notificationSettingsSectionsAndRows setObject:
     [[NSArray alloc]initWithObjects:DRH_HR,MNGMT_CENTERS,IFORMS,MONTHLY_PTO_FORMS, nil]
                                                 forKey:FORMS_HEADING];

    
    
    
    //Testing purposes only
    //    NSArray *keys = [[NSArray alloc] initWithObjects:BIWEEKLY_PAY_PERIOD, BIWEEKLY_PAY_DATE, BIWEEKLY_TIME_CARD, nil];
    //    NSArray *values = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:BIWEEKLY_PAYPERIOD_TYPEID], [NSNumber numberWithInt:BIWEEKLY_PAYDATE_TYPEID], [NSNumber numberWithInt:BIWEEKLY_ETIMECARD_LOCK_TYPEID ],nil];
    //    self.jStringToTypeID = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
    //
    //
    //    values = [[NSArray alloc] initWithObjects:@"Pay period ends in 2 days", @"Biweekly pay day today",@"Biweekly forms due tomorrow", nil];//@"Monthly Forms due tomorrow",@"Monthly time cards due tomorrow", nil];
    //
    //    self.jStringToReminderText = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
    
    
    
    self.switchesToLabels = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i<[self.notificationSettingsSectionsAndRows.allKeys count]; i++) {
        NSString *notificationSections = [self.notificationSettingsSectionsAndRows.allKeys objectAtIndex:i];
        for (NSInteger j = 0; j<[[self.notificationSettingsSectionsAndRows objectForKey:notificationSections]count]; j++) {
            NSString *notificationLabel = [[self.notificationSettingsSectionsAndRows objectForKey:notificationSections]objectAtIndex:j];
            UISwitch *mySwitch = [[UISwitch alloc]init];
            [self.switchesToLabels setObject:mySwitch forKey:notificationLabel];
            [mySwitch setOn:[self.notificationUserSettings boolForKey:notificationLabel]];
        }
    }
    
    self.notificationUserSettings = [NSUserDefaults standardUserDefaults];
    for (NSInteger i = 0; i<[self.notificationSettingsSectionsAndRows.allKeys count]; i++) {
        NSString *iString = [self.notificationSettingsSectionsAndRows.allKeys objectAtIndex:i];
        for (NSInteger j = 0; j<[[self.notificationSettingsSectionsAndRows objectForKey:iString]count]; j++) {
            NSString *jString = [[self.notificationSettingsSectionsAndRows objectForKey:iString]objectAtIndex:j];
            
            UISwitch *swtch = [self.switchesToLabels objectForKey:jString];
            [swtch setOn:[self.notificationUserSettings boolForKey:jString]];
        }
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Hide back button
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectZero];
    UIBarButtonItem *tmpButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tmpView];
    self.navigationItem.leftBarButtonItem = tmpButtonItem;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.notificationSettingsSectionsAndRows.allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.notificationSettingsSectionsAndRows.allKeys objectAtIndex:section];
    return [[self.notificationSettingsSectionsAndRows objectForKey:key]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *title = cell.textLabel;
    title.backgroundColor = [UIColor clearColor];
    NSString *key = [self.notificationSettingsSectionsAndRows.allKeys objectAtIndex:indexPath.section];
    title.text = [[self.notificationSettingsSectionsAndRows objectForKey:key]objectAtIndex:indexPath.row];
    title.backgroundColor = [UIColor clearColor];
    
    CGRect switchFrame = CGRectMake(230, 10, 0, 0);
    UISwitch *mySwitch = [self.switchesToLabels objectForKey:title.text];
    mySwitch.frame = switchFrame;
    [cell addSubview:mySwitch];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.notificationSettingsSectionsAndRows.allKeys objectAtIndex:section];
}

@end

