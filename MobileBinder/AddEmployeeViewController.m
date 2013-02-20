#import "AddEmployeeViewController.h"
#import "EmployeeRecord.h"
#import "Database.h"
#import "Constants.h"

#define SCROLL_OFFSET IS_4_INCH_SCREEN ? 100 : 200
#define CONTENT_SIZE IS_4_INCH_SCREEN ? 460: 560

@interface AddEmployeeViewController () <UITextFieldDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *departmentField;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UITextField *unitField;
@property (nonatomic) BOOL firstResponderIsActive;
@end

@implementation AddEmployeeViewController

- (IBAction)deletePressed:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Are you sure you want to delete %@ %@",self.myRecord.firstName,self.myRecord.lastName] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
    [sheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.destructiveButtonIndex)
    {
        [self.delegate deleteEmployeeRecord:self.myRecord];
    }
}

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
    [self.myScrollView setContentSize:CGSizeMake(self.myScrollView.frame.size.width, self.myScrollView.frame.size.height)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden)
                                                 name:UIKeyboardWillHideNotification object:nil];
    self.myScrollView.contentSize = CGSizeMake(self.myScrollView.contentSize.width, CONTENT_SIZE);
    self.myScrollView.scrollEnabled = NO;
}



- (void)viewDidUnload
{
    [self setFirstNameField:nil];
    [self setLastNameField:nil];
    [self setDepartmentField:nil];
    [self setUnitField:nil];
    [self setMyScrollView:nil];
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

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.myScrollView.scrollEnabled = YES;
    self.firstResponderIsActive = YES;
    if(textField == self.departmentField || textField == self.unitField)
    {
        [self.myScrollView setContentOffset:CGPointMake(0, SCROLL_OFFSET) animated:YES];
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
            [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }}
    );
}

- (void) keyboardWillBeHidden
{
    self.myScrollView.scrollEnabled = NO;
}



@end
