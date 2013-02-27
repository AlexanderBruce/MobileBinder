//
//Bug - when switching between biweekly and monthly pickers while the picker view is up
//
//
//  PayrollPeriodViewController.m
//  MobileBinder
//
//  Created by Samuel Rang on 1/30/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import "PayrollPeriodViewController.h"
#import <Foundation/NSDate.h>


#define KEYBOARD_HEIGHT 216.0f
#define TOOLBAR_HEIGHT 44
#import "PayrollModel.h"


@interface PayrollPeriodViewController () <UITextFieldDelegate> 
@property (weak, nonatomic) IBOutlet UISegmentedControl *periodTypeSegmented;
@property (weak, nonatomic) IBOutlet UITextField *periodSelection;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property(strong,nonatomic) NSMutableArray *monthlyPayPeriods;
@property(strong,nonatomic) NSMutableArray *biweeklyPayPeriods;
@property(strong,nonatomic) UIPickerView *myPicker;
@property(strong,nonatomic) NSString *selectedPayPeriod;
@property(strong,nonatomic) PayrollModel *myModel;
@property(strong,nonatomic) NSMutableDictionary *payrollStringsToPayrollModel;
@property(strong,nonatomic) UITableView *payPeriodTableView;
@property(strong,nonatomic) NSArray *modelData;
@property(strong,nonatomic) NSArray *importantDateLabels;
@end

@implementation PayrollPeriodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myModel = [[PayrollModel alloc] init];
    self.payrollStringsToPayrollModel = [NSMutableDictionary dictionary];
    self.monthlyPayPeriods = [[NSMutableArray alloc]initWithObjects:
                              @"January",@"February",@"March", @"April",
                              @"May", @"June", @"July", @"August",
                              @"September", @"October", @"November", @"December",nil];
    self.biweeklyPayPeriods = [[NSMutableArray alloc]initWithObjects:
                               @"01-1", @"01-2", @"02-1", @"02-2", @"03-1", @"03-2", @"04-1", @"04-2",
                               @"05-1", @"05-2", @"06-1", @"06-2", @"07-1", @"07-2", @"08-1", @"08-2",
                               @"09-1", @"09-2", @"10-1", @"10-2", @"11-1", @"11-2", @"12-1", @"12-2", nil];
    for(int i = 0; i < [self.monthlyPayPeriods count]; i++)
    {
        [self.payrollStringsToPayrollModel setValue:[[self.monthlyPayPeriods objectAtIndex:i]substringToIndex:3] forKey:[self.monthlyPayPeriods objectAtIndex:i]];
    }
    for(int i = 0; i < [self.biweeklyPayPeriods count]; i++)
    {
        [self.payrollStringsToPayrollModel setValue:[NSString stringWithFormat:@"%02d", (i+1)] forKey:[self.biweeklyPayPeriods objectAtIndex:i]];
    }
    self.periodSelection.inputView = [self createPeriodPicker];
    self.periodTypeSegmented.selectedSegmentIndex = 0;
}

-(UIView *) createPeriodPicker
{
    self.myPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, KEYBOARD_HEIGHT+TOOLBAR_HEIGHT)];
    self.myPicker.dataSource = self;
    self.myPicker.delegate = self;
    self.myPicker.showsSelectionIndicator = YES;
    self.selectedPayPeriod = [self pickerView:self.myPicker titleForRow:0 forComponent:0];
    [self.periodSelection setText:self.selectedPayPeriod];
    return self.myPicker;
}
- (IBAction)storePayPeriodSelection:(id)sender {
    [self.periodSelection resignFirstResponder];
    if(self.selectedPayPeriod){
        [self createPayPeriodDataTable];
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
        [self.myScrollView setContentOffset:CGPointMake(0, 70) animated:YES];
        self.selectedPayPeriod = [self pickerView:self.myPicker titleForRow:0 forComponent:0];
        [self.periodSelection setText:self.selectedPayPeriod];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)segmentedValueChanged:(id)sender {
    [self.myPicker reloadAllComponents];
    self.selectedPayPeriod = [self pickerView:self.myPicker titleForRow:0 forComponent:0];
    [self.periodSelection setText:self.selectedPayPeriod];
}

- (void) createPayPeriodDataTable
{
    self.payPeriodTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,131,self.view.frame.size.width,295)];
    self.modelData = [self.myModel datesForPayPeriod:[self.payrollStringsToPayrollModel objectForKey:self.selectedPayPeriod]];
    if (self.periodTypeSegmented.selectedSegmentIndex == 1) {
        self.importantDateLabels = [[NSArray alloc]initWithObjects:@"Forms Due to Management Centers (except DRH)", @"Forms Due To DRH HR", @"Leave of Absence Forms Due to Corporate Payroll", @"Pay Exception Forms Due to Corporate Payroll", @"All Types of iForms", @"Time and Attendance Closing to Update PTO Balances", @"Pay Date", nil];
    }
    else
    {
        self.importantDateLabels = [[NSArray alloc]initWithObjects:@"Pay Period Begin Date",@"Pay Period End Date", @"Pay Date", @"Time/Attendance and Electronic Time Cards Employee Lock Down", @"Time/Attendance and Electronic Time Cards Supervisor Lock Down", @"Gross Adjustment Forms Due to Corporate Payroll", @"Forms Due to Management Centers", @"All Forms Due to DRH HR", @"All Types of iForms", nil];
    }
    self.payPeriodTableView.delegate = self;
    self.payPeriodTableView.dataSource = self;
    [self.view addSubview:self.payPeriodTableView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedPayPeriod = [self pickerView:pickerView titleForRow:row forComponent:component];
    [self.periodSelection setText:self.selectedPayPeriod];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    NSInteger ret = 0;
    if(self.periodTypeSegmented.selectedSegmentIndex == 1){
        ret = [self.monthlyPayPeriods count];
    }
    else if (self.periodTypeSegmented.selectedSegmentIndex == 0) {
        ret = [self.biweeklyPayPeriods count];
    }
    return ret;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result = nil;
    if([pickerView isEqual:self.myPicker])
    {
        if(self.periodTypeSegmented.selectedSegmentIndex == 1){
            result = [self.monthlyPayPeriods objectAtIndex:row];
        }
        else if (self.periodTypeSegmented.selectedSegmentIndex == 0) {
            result = [self.biweeklyPayPeriods objectAtIndex:row];
        }
 
    }
    return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.importantDateLabels.count;
//    NSInteger *result;
//    if(self.periodTypeSegmented.selectedSegmentIndex == 1){
//        result = self.modelData.count;
//    }
//    else if (self.periodTypeSegmented.selectedSegmentIndex == 0) {
//        result = 
//    }
//
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *label = cell.textLabel;
    label.backgroundColor = [UIColor clearColor];
    NSDate *date =[self.modelData objectAtIndex:indexPath.section];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EE MMMM dd, yyyy"];
    NSString *title = [dateFormatter stringFromDate:date];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    
//    CGRect buttonFrame = CGRectMake(250, 0, 50, 22);
//    UIButton *addReminderButton = [[UIButton alloc]initWithFrame:buttonFrame];
//    UILabel *buttonLabel = [[UILabel alloc]initWithFrame:addReminderButton.frame];
//    buttonLabel.text = @"Add Reminder";
//    [addReminderButton addSubview:buttonLabel];
//    
//    [cell addSubview:addReminderButton];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.importantDateLabels objectAtIndex:section];
}


- (void)viewDidUnload {
    [self setPeriodTypeSegmented:nil];
    [self setPeriodSelection:nil];
    [self setMyScrollView:nil];
    [self setDoneButton:nil];
    [self setPayPeriodTableView:nil];
    [self setPayPeriodTableView:nil];
    [super viewDidUnload];
}
@end
