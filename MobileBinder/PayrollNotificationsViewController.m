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
//@property (strong, nonatomic) NSString *BIWEEKLY_HEADING_STRING;
//@property (strong, nonatomic) NSString *BEGIN_DATE_STRING;
//
//@property (strong, nonatomic) NSString *END_DATE_STRING;
//
//@property (strong, nonatomic) NSString *PAY_DATE_STRING;
//
//@property (strong, nonatomic) NSString *MONTHLY_HEADING_STRING;
//@property (strong, nonatomic) NSString *MONTHLY_NOTIFICATIONS_STRING;


//Temporary testing properties
@property (strong, nonatomic) NSDictionary *jStringToTypeID;
@property (strong, nonatomic) NSDictionary *jStringToReminderText;

@property (strong, nonatomic) NSUserDefaults *notificationUserSettings;
@property (strong, nonatomic) NSMutableDictionary *notificationSettingsSectionsAndRows;
@property (strong, nonatomic) NSMutableDictionary *switchesToLabels;
@property (strong, nonatomic) PayrollModel *model;
@end

@implementation PayrollNotificationsViewController

- (IBAction)cancelPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)savePressed:(id)sender
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
    NSMutableArray *remindersToAdd = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<[self.notificationSettingsSectionsAndRows.allKeys count]; i++) {
        NSString *iString = [self.notificationSettingsSectionsAndRows.allKeys objectAtIndex:i];
        for (NSInteger j = 0; j<[[self.notificationSettingsSectionsAndRows objectForKey:iString]count]; j++) {
            NSString *jString = [[self.notificationSettingsSectionsAndRows objectForKey:iString]objectAtIndex:j];
            UISwitch *swtch = [self.switchesToLabels objectForKey:jString];
            
            BOOL oldSetting = [self.notificationUserSettings boolForKey:jString];
            BOOL newSetting = swtch.isOn;
            if((oldSetting == YES) && (newSetting == NO)) //Cancel reminders
            {
                [typeIDsToRemove addObject:[self.jStringToTypeID objectForKey:jString]];
            }
            else if((oldSetting == NO) && (newSetting == YES)) //Add new reminders
            {
                NSArray *datesToAdd = [self.model getDatesForTypeID:[[self.jStringToTypeID objectForKey:jString] intValue]];
                for (NSDate *date in datesToAdd)
                {
                    Reminder *reminder = [[Reminder alloc] initWithText:[self.jStringToReminderText objectForKey:jString] eventDate:date fireDate:date typeID:[[self.jStringToTypeID objectForKey:jString] intValue]];
                    [remindersToAdd addObject:reminder];
                }

            }
            [self.notificationUserSettings setBool:[swtch isOn] forKey:jString];
        }
    }
    
    [self.notificationUserSettings synchronize];
    
    ReminderCenter *center = [ReminderCenter getInstance];
    [center cancelRemindersWithTypeIDs:typeIDsToRemove completion:^{
        [center addReminders:remindersToAdd completion:^{
            self.view.userInteractionEnabled = YES;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.model = [[PayrollModel alloc] init];
    NSString *BIWEEKLY_HEADING_STRING = @"Biweekly Employees";
    NSString *PP_BIWEEKLY_STRING = @"Pay Period";
    NSString *TIME_ATTENDANCE_STRING = @"Time/Attendance";
    NSString *FORMS_DUE_STRING = @"Forms Due";
    self.notificationSettingsSectionsAndRows = [NSMutableDictionary dictionary];
    [self.notificationSettingsSectionsAndRows setObject:
     [[NSArray alloc]initWithObjects:PP_BIWEEKLY_STRING,TIME_ATTENDANCE_STRING, FORMS_DUE_STRING, nil]
                                                 forKey:BIWEEKLY_HEADING_STRING]; 
    
//    NSString *LOCK_DOWN_STRING = @"Card Lock Down";
//    NSString *GROSS_STRING = @"Gross Adjustments";
//    NSString *MGMENT_CENTERS_STRING = @"Management Centers";
//    [self.notificationSettingsSectionsAndRows setObject:
//     [[NSArray alloc]initWithObjects:BEGIN_DATE_STRING,END_DATE_STRING, PAY_DATE_STRING, LOCK_DOWN_STRING, GROSS_STRING, nil]
//                                                 forKey:BIWEEKLY_HEADING_STRING];
    
    NSString *MONTHLY_HEADING_STRING = @"Monthly Employees";
    NSString *MONTHLY_FORMS_DUE_STRING = @"Forms Due ";
    NSString *MONTHLY_TIME_ATTENDANCE_STRING = @"Time/Attendance ";
    [self.notificationSettingsSectionsAndRows setObject:
     [[NSArray alloc]initWithObjects:MONTHLY_FORMS_DUE_STRING, MONTHLY_TIME_ATTENDANCE_STRING, nil]
                                                 forKey:MONTHLY_HEADING_STRING];
    
    
    //Testing purposes only
    NSArray *keys = [[NSArray alloc] initWithObjects:PP_BIWEEKLY_STRING,TIME_ATTENDANCE_STRING,FORMS_DUE_STRING,MONTHLY_FORMS_DUE_STRING,MONTHLY_TIME_ATTENDANCE_STRING, nil];
    NSArray *values = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],nil];    
    self.jStringToTypeID = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
    
    
    values = [[NSArray alloc] initWithObjects:@"Pay period ends in 2 days", @"Biweekly time cards due today",@"Biweekly forms due tomorrow",@"Monthly Forms due tomorrow",@"Monthly time cards due tomorrow", nil];
    
    self.jStringToReminderText = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
    
    
    
    self.switchesToLabels = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i<[self.notificationSettingsSectionsAndRows.allKeys count]; i++) {
        NSString *iString = [self.notificationSettingsSectionsAndRows.allKeys objectAtIndex:i];
        for (NSInteger j = 0; j<[[self.notificationSettingsSectionsAndRows objectForKey:iString]count]; j++) {
            NSString *jString = [[self.notificationSettingsSectionsAndRows objectForKey:iString]objectAtIndex:j];
            UISwitch *swtch = [[UISwitch alloc]init];
            [self.switchesToLabels setObject:swtch forKey:jString];
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
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    //Code moved up to savePressed method
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    CGRect labelFrame = CGRectMake(20, 13, 150, 20);
    UILabel *title = [[UILabel alloc]initWithFrame:labelFrame];
    title.backgroundColor = [UIColor clearColor];
    NSString *key = [self.notificationSettingsSectionsAndRows.allKeys objectAtIndex:indexPath.section];
    title.text = [[self.notificationSettingsSectionsAndRows objectForKey:key]objectAtIndex:indexPath.row];
    title.backgroundColor = [UIColor clearColor];
    [cell addSubview:title];
    
    CGRect switchFrame = CGRectMake(220, 10, 40, 22);
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
