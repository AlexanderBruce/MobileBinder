//
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
#import "OutlinedLabel.h"
#import "PayrollModel.h"

#define KEYBOARD_HEIGHT 216.0f
#define TOOLBAR_HEIGHT 44

#define BIWEEKLY_SEGMENT 0
#define MONTHLY_SEGMENT 1

@interface PayrollPeriodViewController () <UITextFieldDelegate> 
@property (weak, nonatomic) IBOutlet UISegmentedControl *periodTypeSegmented;
@property (weak, nonatomic) IBOutlet UITextField *periodSelectionField;

@property(strong,nonatomic) UIBarButtonItem *doneButton;
@property(strong,nonatomic) NSMutableArray *monthlyPayPeriods;
@property(strong,nonatomic) NSMutableArray *biweeklyPayPeriods;
@property(strong,nonatomic) UIPickerView *myPicker;
@property(strong,nonatomic) NSString *selectedPayPeriod;
@property(strong,nonatomic) PayrollModel *myModel;
@property(strong,nonatomic) NSMutableDictionary *payrollStringsToPayrollModel;
@property (weak, nonatomic) IBOutlet UITableView *payPeriodTableView;
@property(strong,nonatomic) NSArray *modelData;
@property(strong,nonatomic) NSArray *importantDateLabels;
@property (weak, nonatomic) IBOutlet OutlinedLabel *myLabel;
@end

@implementation PayrollPeriodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myLabel.outlineColor = [UIColor blackColor];
    self.myLabel.outlineWidth = .6;
    self.myLabel.verticalAlignment = AGKOutlineLabelVerticalAlignmentMiddle;
    self.myLabel.shadeBlur = 0;
    self.myLabel.diffuseShadowColor = [UIColor blackColor];
    self.myLabel.diffuseShadowOffset = CGSizeZero;
    
    self.myModel = [[PayrollModel alloc] init];
    self.payrollStringsToPayrollModel = [NSMutableDictionary dictionary];
    self.monthlyPayPeriods = [[NSMutableArray alloc]initWithObjects:
                              @"January",@"February",@"March", @"April",
                              @"May", @"June", @"July", @"August",
                              @"September", @"October", @"November", @"December",nil];
    self.biweeklyPayPeriods = [[NSMutableArray alloc]initWithObjects:
                               @"Jan-1", @"Jan-2", @"Feb-1", @"Feb-2", @"Mar-1", @"Mar-2", @"Apr-1", @"Apr-2",
                               @"May-1", @"May-2", @"Jun-1", @"Jun-2", @"Jul-1", @"Jul-2", @"Aug-1", @"Aug-2",
                               @"Sep-1", @"Sep-2", @"Oct-1", @"Oct-2", @"Nov-1", @"Nov-2", @"Dec-1", @"Dec-2", nil];
    
    self.payPeriodTableView.delegate = self;
    self.payPeriodTableView.dataSource = self;
//    self.payPeriodTableView.alpha = .85;
    self.payPeriodTableView.backgroundColor = [UIColor clearColor];
    self.payPeriodTableView.opaque = NO;
//    self.payPeriodTableView.backgroundView = nil;
    
    for(int i = 0; i < [self.monthlyPayPeriods count]; i++)
    {
        [self.payrollStringsToPayrollModel setValue:[[self.monthlyPayPeriods objectAtIndex:i]substringToIndex:3] forKey:[self.monthlyPayPeriods objectAtIndex:i]];
    }
    for(int i = 0; i < [self.biweeklyPayPeriods count]; i++)
    {
        [self.payrollStringsToPayrollModel setValue:[NSString stringWithFormat:@"%02d", (i+1)] forKey:[self.biweeklyPayPeriods objectAtIndex:i]];
    }
    self.periodSelectionField.inputView = [self createPeriodPicker];
    self.periodTypeSegmented.selectedSegmentIndex = 0;
    [self segmentedValueChanged:self.periodTypeSegmented];
}

-(UIView *) createPeriodPicker
{
    UIView *pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, KEYBOARD_HEIGHT+TOOLBAR_HEIGHT)];
    
    self.myPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, TOOLBAR_HEIGHT, self.view.frame.size.width, KEYBOARD_HEIGHT)];
    self.myPicker.dataSource = self;
    self.myPicker.delegate = self;
    self.myPicker.showsSelectionIndicator = YES;
    [self.periodSelectionField setText:self.selectedPayPeriod];
    
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    toolBar.translucent = YES;
    [toolBar sizeToFit];
    self.doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePressed)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects: flexible, self.doneButton, nil]];
    

    [pickerView addSubview:self.myPicker];
    [pickerView addSubview:toolBar];
    
    return pickerView;
}

- (void)donePressed
{
    [self.periodSelectionField resignFirstResponder];
    [self.payPeriodTableView reloadData];
}

- (IBAction)segmentedValueChanged:(id)sender
{
    if (self.periodTypeSegmented.selectedSegmentIndex == MONTHLY_SEGMENT)
    {
        self.importantDateLabels = [[NSArray alloc]initWithObjects:@"Forms Due to Management Centers (except DRH)", @"Forms Due To DRH HR", @"Leave of Absence Forms Due to Corporate Payroll", @"Pay Exception Forms Due to Corporate Payroll", @"All Types of iForms", @"Time and Attendance Closing to Update PTO Balances", @"Pay Date", nil];
    }
    else
    {
        self.importantDateLabels = [[NSArray alloc]initWithObjects:@"Pay Period Begin Date",@"Pay Period End Date", @"Pay Date", @"Time/Attendance and Electronic Time Cards Employee Lock Down", @"Time/Attendance and Electronic Time Cards Supervisor Lock Down", @"Gross Adjustment Forms Due to Corporate Payroll", @"Forms Due to Management Centers", @"All Forms Due to DRH HR", @"All Types of iForms", nil];
    }
    [self.myPicker reloadAllComponents];
    [self.myPicker selectRow:0 inComponent:0 animated:YES];
    self.selectedPayPeriod = [self pickerView:self.myPicker titleForRow:0 forComponent:0];
    [self.periodSelectionField setText:self.selectedPayPeriod];
    [self.payPeriodTableView reloadData];
}

#pragma mark - UIPickerViewDataSource & Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedPayPeriod = [self pickerView:pickerView titleForRow:row forComponent:component];
    [self.periodSelectionField setText:self.selectedPayPeriod];
    [self.payPeriodTableView reloadData];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if(self.periodTypeSegmented.selectedSegmentIndex == MONTHLY_SEGMENT)
    {
        return [self.monthlyPayPeriods count];
    }
    else
    {
        return [self.biweeklyPayPeriods count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result = nil;
    if([pickerView isEqual:self.myPicker])
    {
        if(self.periodTypeSegmented.selectedSegmentIndex == 1)
        {
            result = [self.monthlyPayPeriods objectAtIndex:row];
        }
        else if (self.periodTypeSegmented.selectedSegmentIndex == 0)
        {
            result = [self.biweeklyPayPeriods objectAtIndex:row];
        }
    }
    return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.importantDateLabels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellIdentifier];
        UIView *view = [[UIView alloc] initWithFrame:cell.frame];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = .85;
        [cell addSubview:view];
        [cell sendSubviewToBack:view];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.alpha = 1;
    
    UILabel *label = cell.textLabel;
    label.backgroundColor = [UIColor clearColor];
    self.modelData = [self.myModel datesForPayPeriod:[self.payrollStringsToPayrollModel objectForKey:self.selectedPayPeriod]];
    if(indexPath.section >= self.modelData.count)
    {
        [NSException raise:@"Crash and Burn Exception!" format:@"Something went wrong in the cellForRowAtIndexPathMethod of PayrollPeriodViewController"];
    }
    NSDate *date =[self.modelData objectAtIndex:indexPath.section];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EE MMMM dd, yyyy"];
    NSString *title = [dateFormatter stringFromDate:date];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];

    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.importantDateLabels objectAtIndex:section];
}

- (void)viewDidUnload
{
    [self setPeriodTypeSegmented:nil];
    [self setPeriodSelectionField:nil];
    [self setPayPeriodTableView:nil];
    [self setPayPeriodTableView:nil];
    [self setPayPeriodTableView:nil];
    [self setMyLabel:nil];
    [super viewDidUnload];
}
@end
