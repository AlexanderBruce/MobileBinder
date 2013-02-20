#import "AddEmployeeViewController.h"
#import "EmployeeRecord.h"
#import "Database.h"

@interface AddEmployeeViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *departmentField;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UITextField *unitField;
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
        if(!record.unit) record.unit = @"";
        if(!record.department) record.department = @"";
        NSLog(@"Record.department = %@",record.department);
        [self.delegate addedNewEmployeeRecord:record];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"First and Last Name fields must be completed" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
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
    self.firstResponderIsActive = NO;
    self.myScrollView.scrollEnabled = YES;
    if(self.myRecord){
        self.firstNameField.text = self.myRecord.firstName;
        self.lastNameField.text = self.myRecord.lastName;
        self.departmentField.text = self.myRecord.department;
        self.unitField.text = self.myRecord.unit;
    }
}



- (void)viewDidUnload {
    [self setFirstNameField:nil];
    [self setLastNameField:nil];
    [self setDepartmentField:nil];
    [self setUnitField:nil];
    [self setMyScrollView:nil];
    [super viewDidUnload];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.myScrollView.contentSize = CGSizeMake(self.myScrollView.contentSize.width, 560);
    self.firstResponderIsActive = YES;
    if(textField == self.departmentField || textField == self.unitField)
    {
        [self.myScrollView setContentOffset:CGPointMake(0, 200) animated:YES];
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
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(!self.firstResponderIsActive)
        {
            self.myScrollView.contentSize = CGSizeMake(self.myScrollView.contentSize.width,0);
                [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }}
    );

}

@end
