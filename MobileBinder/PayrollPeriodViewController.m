//
//  PayrollPeriodViewController.m
//  MobileBinder
//
//  Created by Samuel Rang on 1/30/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import "PayrollPeriodViewController.h"

#define KEYBOARD_HEIGHT 216.0f
#define TOOLBAR_HEIGHT 44


@interface PayrollPeriodViewController () <UITextFieldDelegate> 
@property (weak, nonatomic) IBOutlet UISegmentedControl *periodTypeSegmented;
@property (weak, nonatomic) IBOutlet UITextField *periodSelection;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property(strong,nonatomic) NSMutableArray *monthlyPayPeriods;
@property(strong,nonatomic) NSMutableArray *biweeklyPayPeriods;
@property(strong,nonatomic) UIPickerView *myPicker;
@property(strong,nonatomic) NSString *selectedPayPeriod;
@property(strong,nonatomic) UITableView *payPeriodContent;

@end

@implementation PayrollPeriodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.monthlyPayPeriods = [[NSMutableArray alloc]initWithObjects:
                              @"January",@"February",@"March", @"April",
                              @"May", @"June", @"July", @"August",
                              @"September", @"October", @"November", @"December",nil];
    self.biweeklyPayPeriods = [[NSMutableArray alloc]initWithObjects:
                               @"01-1", @"01-2", @"02-1", @"02-2", @"03-1", @"03-2", @"04-1", @"04-2",
                               @"05-1", @"05-2", @"06-1", @"06-2", @"07-1", @"07-2", @"08-1", @"08-2",
                               @"09-1", @"09-2", @"10-1", @"10-2", @"11-1", @"11-2", @"12-1", @"12-2", nil];
    self.periodSelection.inputView = [self createPeriodPicker];
    self.periodTypeSegmented.selectedSegmentIndex = 1;
    self.periodSelection.delegate = self;
}

-(UIView *) createPeriodPicker
{
    self.myPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, KEYBOARD_HEIGHT+TOOLBAR_HEIGHT)];
    self.myPicker.dataSource = self;
    self.myPicker.delegate = self;
    self.myPicker.showsSelectionIndicator = YES;
    
    return self.myPicker;
}
- (IBAction)storePayPeriodSelection:(id)sender {
        [self.periodSelection resignFirstResponder];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self.myScrollView setContentOffset:CGPointMake(0, 70) animated:YES];
    [self.myPicker reloadAllComponents];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.payPeriodContent = [[UITableView alloc]init];
    [self populatePayPeriodDates];
    
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

-(void)populatePayPeriodDates;
{
    
}

- (void)viewDidUnload {
    [self setPeriodTypeSegmented:nil];
    [self setPeriodSelection:nil];
    [self setMyScrollView:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
}
@end
