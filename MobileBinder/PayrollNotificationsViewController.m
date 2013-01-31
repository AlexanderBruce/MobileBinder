//
//  payrollNotificationsViewController.m
//  MobileBinder
//
//  Created by Samuel Rang on 1/29/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import "PayrollNotificationsViewController.h"

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

@property (strong, nonatomic) NSUserDefaults *notificationUserSettings;
@property (strong, nonatomic) NSMutableDictionary *notificationSettingsSectionsAndRows;
@property (strong, nonatomic) NSMutableDictionary *switchesToLabels;
@end

@implementation PayrollNotificationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    for (NSInteger i = 0; i<[self.notificationSettingsSectionsAndRows.allKeys count]; i++) {
        NSString *iString = [self.notificationSettingsSectionsAndRows.allKeys objectAtIndex:i];
        for (NSInteger j = 0; j<[[self.notificationSettingsSectionsAndRows objectForKey:iString]count]; j++) {
            NSString *jString = [[self.notificationSettingsSectionsAndRows objectForKey:iString]objectAtIndex:j];
            
            UISwitch *swtch = [self.switchesToLabels objectForKey:jString];
            [self.notificationUserSettings setBool:[swtch isOn] forKey:jString];
        }
    }
    [self.notificationUserSettings synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.notificationSettingsSectionsAndRows.allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
