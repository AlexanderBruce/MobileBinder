//
//  payrollNotificationsViewController.m
//  MobileBinder
//
//  Created by Samuel Rang on 1/29/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import "PayrollNotificationsViewController.h"

@interface PayrollNotificationsViewController ()
@property (strong, nonatomic) NSString *BIWEEKLY_HEADING_STRING;
@property (strong, nonatomic) UISwitch *beginDateSwitch;
@property (strong, nonatomic) NSString *BEGIN_DATE_STRING;

@property (strong, nonatomic) UISwitch *endDateSwitch;
@property (strong, nonatomic) NSString *END_DATE_STRING;

@property (strong, nonatomic) UISwitch *payDateSwitch;
@property (strong, nonatomic) NSString *PAY_DATE_STRING;

@property (strong, nonatomic) NSString *MONTHLY_HEADING_STRING;
@property (strong, nonatomic) NSString *MONTHLY_NOTIFICATIONS_STRING;

@property (strong, nonatomic) NSUserDefaults *notificationUserSettings;
@property (strong, nonatomic) NSMutableDictionary *notificationSettingsSectionsAndRows;
@property (strong, nonatomic) NSMutableDictionary *notificationSwitchesToLabels;
@end

@implementation PayrollNotificationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.BIWEEKLY_HEADING_STRING = @"Biweekly";
    self.BEGIN_DATE_STRING = @"Begin Date";
    self.END_DATE_STRING = @"End Date";
    self.PAY_DATE_STRING = @"Pay Date";
    self.MONTHLY_HEADING_STRING = @"Monthly";
    self.MONTHLY_NOTIFICATIONS_STRING = @"Monthly Notifications";
    
    self.notificationSettingsSectionsAndRows = [NSMutableDictionary dictionary];
    [self.notificationSettingsSectionsAndRows setObject:
     [[NSArray alloc]initWithObjects:self.BEGIN_DATE_STRING,self.END_DATE_STRING, self.PAY_DATE_STRING, nil]
                                                 forKey:self.BIWEEKLY_HEADING_STRING];
    
    [self.notificationSettingsSectionsAndRows setObject:
     [[NSArray alloc]initWithObjects:self.MONTHLY_NOTIFICATIONS_STRING, nil]
                                                 forKey:self.MONTHLY_HEADING_STRING];
    self.notificationUserSettings = [NSUserDefaults standardUserDefaults];
    self.beginDateSwitch = [[UISwitch alloc]init];
    self.endDateSwitch = [[UISwitch alloc]init];
    self.payDateSwitch = [[UISwitch alloc]init];
    [self.beginDateSwitch setOn:[self.notificationUserSettings boolForKey:self.BEGIN_DATE_STRING]];
    [self.endDateSwitch setOn: [self.notificationUserSettings boolForKey:self.END_DATE_STRING]];
    [self.payDateSwitch setOn: [self.notificationUserSettings boolForKey:self.PAY_DATE_STRING]];

    
    self.notificationSwitchesToLabels = [NSMutableDictionary dictionary];
    [self.notificationSwitchesToLabels setObject:self.beginDateSwitch forKey:self.BEGIN_DATE_STRING];
    [self.notificationSwitchesToLabels setObject:self.endDateSwitch forKey:self.END_DATE_STRING];
    [self.notificationSwitchesToLabels setObject:self.payDateSwitch forKey:self.PAY_DATE_STRING];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    NSLog(@"UISwitch, %@, is %i\n", self.beginDateSwitch, self.beginDateSwitch.isOn);

    [self.notificationUserSettings setBool:[self.beginDateSwitch isOn] forKey:self.BEGIN_DATE_STRING];
    [self.notificationUserSettings setBool:[self.endDateSwitch isOn] forKey:self.END_DATE_STRING];
    [self.notificationUserSettings setBool:[self.payDateSwitch isOn] forKey:self.PAY_DATE_STRING];
    [self.notificationUserSettings synchronize];
    NSLog(@"It should be %i\n",[self.notificationUserSettings boolForKey:self.BEGIN_DATE_STRING]);
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
    
    CGRect labelFrame = CGRectMake(20, 13, 150, 20);
    UILabel *title = [[UILabel alloc]initWithFrame:labelFrame];
    NSString *key = [self.notificationSettingsSectionsAndRows.allKeys objectAtIndex:indexPath.section];
    title.text = [[self.notificationSettingsSectionsAndRows objectForKey:key]objectAtIndex:indexPath.row];
    [cell addSubview:title];
    
    CGRect switchFrame = CGRectMake(220, 10, 40, 22);
    UISwitch *mySwitch = [self.notificationSwitchesToLabels objectForKey:title.text];
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
    [self setBeginDateSwitch:nil];
    [self setEndDateSwitch:nil];
    [self setPayDateSwitch:nil];
    [super viewDidUnload];
}
@end
