/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "AddEmployeeViewController.h"
#import "EmployeeRecord.h"
#import "Database.h"
#import "OutlinedLabel.h"
#import "Constants.h"
#import "AttendanceModel.h"

#define SCROLL_OFFSET IS_4_INCH_SCREEN ? 50 : 150
#define CONTENT_SIZE IS_4_INCH_SCREEN ? 460: 560
#define REPEAT_EMPLOYEE_ALERTVIEW 2
#define INCOMPLETE_FIELDS_ALERTVIEW 3

@interface AddEmployeeViewController () <UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *departmentField;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UITextField *unitField;
@property (weak, nonatomic) IBOutlet UITextField *uniqueIDField;
@property (nonatomic) BOOL firstResponderIsActive;
@end

@implementation AddEmployeeViewController


- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    if(self.myRecord)
    {
        self.myRecord.firstName = self.firstNameField.text;
        self.myRecord.lastName = self.lastNameField.text;
        self.myRecord.department = self.departmentField.text;
        self.myRecord.unit = self.unitField.text;
        self.myRecord.idNum = self.uniqueIDField.text;
        [Database saveDatabase];
        [self.delegate editedEmployeedRecord];
    }
    
    else if(self.firstNameField.text.length > 0 && self.lastNameField.text.length > 0)
    {
        EmployeeRecord *record = [[EmployeeRecord alloc] init];
        record.firstName = self.firstNameField.text;
        record.lastName = self.lastNameField.text;
        record.department = self.departmentField.text;
        record.unit = self.unitField.text;
        record.idNum = self.uniqueIDField.text;
        if(!record.unit) record.unit = @"";
        if(!record.department) record.department = @"";
        self.myRecord = record;
        if(self.myRecord.idNum && [self.myModel recordExistsByID:record])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"An employee with this ID already exists. Proceed with adding them?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = REPEAT_EMPLOYEE_ALERTVIEW;
            [alert show];
        }
        else if([self.myModel recordExistsByName:record])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"This employee with this name already exists. Proceed with adding them?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = REPEAT_EMPLOYEE_ALERTVIEW;
            [alert show];
        }
        else
        {
            [self.delegate addedNewEmployeeRecord:record];
        }
    }

    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"First and Last Name fields must be completed" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        alert.tag = INCOMPLETE_FIELDS_ALERTVIEW;
        [alert show];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == REPEAT_EMPLOYEE_ALERTVIEW)
    {
        if(alertView.cancelButtonIndex != buttonIndex)
        {
            [self.delegate addedNewEmployeeRecord:self.myRecord];
        }
    }
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    [self.delegate canceledAddEmployeeViewController];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.departmentField.delegate = self;
    self.unitField.delegate = self;
    self.uniqueIDField.delegate = self;
    self.firstResponderIsActive = NO;
    if(self.myRecord){
        self.firstNameField.text = self.myRecord.firstName;
        self.lastNameField.text = self.myRecord.lastName;
        self.departmentField.text = self.myRecord.department;
        self.unitField.text = self.myRecord.unit;
        self.uniqueIDField.text = self.myRecord.idNum;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden)
                                                 name:UIKeyboardWillHideNotification object:nil];
    self.myScrollView.contentSize = CGSizeMake(self.myScrollView.contentSize.width, CONTENT_SIZE);
    self.myScrollView.scrollEnabled = NO;
    
    for (UIView *view in self.myScrollView.subviews)
    {
        if([view isKindOfClass:[OutlinedLabel class]])
        {
            OutlinedLabel *label = (OutlinedLabel *) view;
            [label customize];
        }
    }
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void) hideKeyboard
{
    [self.myScrollView endEditing:YES];
}



- (void)viewDidUnload
{
    [self setFirstNameField:nil];
    [self setLastNameField:nil];
    [self setDepartmentField:nil];
    [self setUnitField:nil];
    [self setMyScrollView:nil];
    [self setUniqueIDField:nil];
    [super viewDidUnload];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#define FIRST_NAME_OFFSET (IS_4_INCH_SCREEN ? 0 : 0)
#define LAST_NAME_OFFSET (IS_4_INCH_SCREEN ? 0 : 30)
#define DEPARTMENT_OFFSET (IS_4_INCH_SCREEN ? 70 : 98)
#define UNIT_OFFSET (IS_4_INCH_SCREEN ? 70 : 160)
#define UNIQUE_ID_OFFSET (IS_4_INCH_SCREEN ? 70 : 160)

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.myScrollView.scrollEnabled = YES;
    self.firstResponderIsActive = YES;
    if(textField == self.firstNameField)
    {
        [self.myScrollView setContentOffset:CGPointMake(0, FIRST_NAME_OFFSET) animated:YES];
    }
    else if(textField == self.lastNameField)
    {
        [self.myScrollView setContentOffset:CGPointMake(0, LAST_NAME_OFFSET) animated:YES];
    }
    else if(textField == self.departmentField)
    {
        [self.myScrollView setContentOffset:CGPointMake(0, DEPARTMENT_OFFSET) animated:YES];
    }
    else if(textField == self.unitField)
    {
        [self.myScrollView setContentOffset:CGPointMake(0, UNIT_OFFSET) animated:YES];
    }
    else if(textField == self.uniqueIDField)
    {
        [self.myScrollView setContentOffset:CGPointMake(0, UNIQUE_ID_OFFSET) animated:YES];
    }

}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    self.firstResponderIsActive = NO;
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        if(!self.firstResponderIsActive)
        {
            [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }}
    );
}

- (void) keyboardWillBeHidden
{
    self.myScrollView.scrollEnabled = NO;
}



@end
