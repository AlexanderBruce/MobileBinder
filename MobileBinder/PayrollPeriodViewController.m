/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "PayrollPeriodViewController.h"
#import <Foundation/NSDate.h>
#import "OutlinedLabel.h"
#import "PayrollCategory.h"
#import "PayrollModel.h"

#define KEYBOARD_HEIGHT 216.0f
#define TOOLBAR_HEIGHT 44

#define BIWEEKLY_SEGMENT 0
#define MONTHLY_SEGMENT 1

#define SAVED_SETTINGS_KEY @"payrollSavedSettingsKey"

@interface PayrollPeriodViewController () <UITextFieldDelegate, PayrollModelDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *periodTypeSegmented;
@property (weak, nonatomic) IBOutlet UITextField *periodSelectionField;

@property(strong,nonatomic) UIBarButtonItem *doneButton;
@property(strong,nonatomic) UIPickerView *myPicker;
@property(strong,nonatomic) NSString *selectedPayPeriod;
@property(strong,nonatomic) PayrollModel *myModel;
@property (weak, nonatomic) IBOutlet UITableView *payPeriodTableView;
@property (weak, nonatomic) IBOutlet OutlinedLabel *myLabel;
@end

@implementation PayrollPeriodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.myLabel customize];
    self.payPeriodTableView.hidden = YES;
    self.payPeriodTableView.backgroundColor = [UIColor clearColor];
    self.payPeriodTableView.opaque = NO;

    self.myModel = [[PayrollModel alloc] init];
    [self.myModel initializeModelWithDelegate:self];
}

- (void) doneInitializingPayrollModel
{
    self.payPeriodTableView.delegate = self;
    self.payPeriodTableView.dataSource = self;
    self.payPeriodTableView.hidden = NO;
    self.periodSelectionField.inputView = [self createPeriodPicker];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.periodTypeSegmented.selectedSegmentIndex = [[defaults objectForKey:SAVED_SETTINGS_KEY] intValue];
    [self segmentedValueChanged:self.periodTypeSegmented];
    self.selectedPayPeriod = [[self.myModel getPeriods] objectAtIndex:0];
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
    [self.payPeriodTableView reloadData];
    [self.periodSelectionField resignFirstResponder];
}

- (IBAction)segmentedValueChanged:(id)sender
{
    if(self.periodTypeSegmented.selectedSegmentIndex == 0)
    {
        self.myModel.mode = BiweeklyMode;
    }
    else self.myModel.mode = MonthlyMode;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:self.periodTypeSegmented.selectedSegmentIndex] forKey:SAVED_SETTINGS_KEY];
    [defaults synchronize];
    
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
    return [self.myModel getPeriods].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.myModel getPeriods] objectAtIndex:row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.myModel getCategories].count;
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
    
    NSDate *date = [self.myModel getDateForCategoryNum:indexPath.section period:self.selectedPayPeriod];
    if(date)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EE MMMM dd, yyyy"];
        NSString *title = [dateFormatter stringFromDate:date];
        cell.textLabel.text = title;
    }
    else cell.textLabel.text = @"No date";
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    PayrollCategory *category = [[self.myModel getCategories] objectAtIndex:section];
    return category.name;
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
