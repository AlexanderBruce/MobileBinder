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
@property (weak, nonatomic) IBOutlet UITableView *payPeriodContent;

@end

@implementation PayrollPeriodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.periodSelection.inputView = [self createPeriodPicker];
    self.periodTypeSegmented.selectedSegmentIndex = -1;
    self.periodSelection.delegate = self;
}

-(UIView *) createPeriodPicker
{
    UIView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, KEYBOARD_HEIGHT+TOOLBAR_HEIGHT)];
    
    return pickerView;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return @"Row Name";
}


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self.myScrollView setContentOffset:CGPointMake(0, 70) animated:YES];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)viewDidUnload {
    [self setPeriodTypeSegmented:nil];
    [self setPeriodSelection:nil];
    [self setMyScrollView:nil];
    [self setPayPeriodContent:nil];
    [super viewDidUnload];
}
@end
