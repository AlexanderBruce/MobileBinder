#import "IncidentViewController.h"
#import "EmployeeRecord.h"
#import "Database.h"

#define KEYBOARD_HEIGHT 216.0f
#define TOOLBAR_HEIGHT 44

#define ABSENCE_INDEX 0
#define TARDY_INDEX 1
#define TIMECARD_INDEX 2

@interface IncidentViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *employeeNameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *incidentTypeControl;
@property (weak, nonatomic) IBOutlet UITextField *incidentDateField;
@property (nonatomic, strong) NSDate *incidentDate;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@end

@implementation IncidentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.employeeNameField.text = [NSString stringWithFormat:@"%@ %@",self.employeeRecord.firstName,self.employeeRecord.lastName];
    self.employeeNameField.enabled = NO;
    self.employeeNameField.textColor = [UIColor lightGrayColor];
    self.incidentDateField.inputView = [self createDatePicker];
    self.incidentTypeControl.selectedSegmentIndex = -1;
    self.incidentDateField.delegate = self;
    self.incidentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    self.incidentDateField.text = [formatter stringFromDate:[NSDate date]];
}

- (IBAction)savePressed:(UIButton *)sender
{
    if(self.incidentTypeControl.selectedSegmentIndex < 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select the incident type" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    if(self.incidentTypeControl.selectedSegmentIndex == ABSENCE_INDEX)
    {
        [self.employeeRecord addAbsenceForDate:self.incidentDate];
    }
    else if(self.incidentTypeControl.selectedSegmentIndex = TARDY_INDEX)
    {
        [self.employeeRecord addTardyForDate:self.incidentDate];
    }
    else if(self.incidentTypeControl.selectedSegmentIndex = TIMECARD_INDEX)
    {
        [self.employeeRecord addOtherForDate:self.incidentDate];
    }
    [Database saveAttendanceDatabase];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self.myScrollView setContentOffset:CGPointMake(0, 70) animated:YES];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (UIView *) createDatePicker
{
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, TOOLBAR_HEIGHT + KEYBOARD_HEIGHT)];
    
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    [picker sizeToFit];
    picker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    picker.datePickerMode = UIDatePickerModeDate;
    [picker addTarget:self action:@selector(updateIncidentDateField:) forControlEvents:UIControlEventValueChanged];
    [pickerView addSubview:picker];
    
    
    // Create done button
    UIToolbar* toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.translucent = YES;
    toolBar.tintColor = nil;
    [toolBar sizeToFit];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneUsingPicker)];
    
    [toolBar setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];
    [pickerView addSubview:toolBar];
    picker.frame = CGRectMake(0, toolBar.frame.size.height, self.view.frame.size.width, pickerView.frame.size.height - TOOLBAR_HEIGHT);
    toolBar.frame = CGRectMake(0, 0, self.view.frame.size.width, TOOLBAR_HEIGHT);
    return pickerView;
}

- (void) updateIncidentDateField: (UIDatePicker *) picker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    self.incidentDateField.text = [formatter stringFromDate:picker.date];
    self.incidentDate = picker.date;
}

- (void) doneUsingPicker
{
    [self.incidentDateField resignFirstResponder];
}

- (void)viewDidUnload
{
    [self setEmployeeNameField:nil];
    [self setIncidentTypeControl:nil];
    [self setIncidentDateField:nil];
    [self setMyScrollView:nil];
    [super viewDidUnload];
}
@end
