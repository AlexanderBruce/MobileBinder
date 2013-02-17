#import "IncidentViewController.h"
#import "EmployeeRecord.h"
#import "WebviewViewController.h"
#import "Database.h"
#import "Constants.h"

#define KEYBOARD_HEIGHT 216.0f
#define TOOLBAR_HEIGHT 44

#define ABSENCE_INDEX 0
#define TARDY_INDEX 1
#define TIMECARD_INDEX 2

#define LEVEL_1_SEGUE @"yellowSegue"
#define YELLOW_WEBPAGE_URL @"http://www.hr.duke.edu/policies/time_away/availability.php"

#define LEVEL_1_ALERT_TAG 2
#define LEVEL_2_ALERT_TAG 3
#define LEVEL_3_ALERT_TAG 4

@interface IncidentViewController () <UITextFieldDelegate, WebviewViewControllerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *employeeNameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *incidentTypeControl;
@property (weak, nonatomic) IBOutlet UITextField *incidentDateField;
@property (nonatomic, strong) NSDate *incidentDate;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@end

@implementation IncidentViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:LEVEL_1_SEGUE])
    {
        WebviewViewController *dest = (WebviewViewController *) segue.destinationViewController;
        dest.delegate = self;
        dest.webpageURL = @"http://www.hr.duke.edu/policies/time_away/availability.php";
    }
}

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

#pragma mark - WebviewViewControllerDelegate
- (void) doneViewingWebpage
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         [self.navigationController popViewControllerAnimated:YES];
     }];
}

- (IBAction)savePressed:(UIButton *)sender
{
    if(self.incidentTypeControl.selectedSegmentIndex < 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select the incident type" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    int changeOfLevel = -1;
    if(self.incidentTypeControl.selectedSegmentIndex == ABSENCE_INDEX)
    {
        changeOfLevel = [self.employeeRecord addAbsenceForDate:self.incidentDate];
    }
    else if(self.incidentTypeControl.selectedSegmentIndex == TARDY_INDEX)
    {
        changeOfLevel = [self.employeeRecord addTardyForDate:self.incidentDate];
    }
    else if(self.incidentTypeControl.selectedSegmentIndex == TIMECARD_INDEX)
    {
        changeOfLevel =[self.employeeRecord addMissedSwipeForDate:self.incidentDate];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [Database saveDatabase];
    });
    
    if (changeOfLevel >= 0)
    {
        NSString *alertTitle = [NSString stringWithFormat:@"%@",[self.employeeRecord getTextForLevel:changeOfLevel]];
        if (changeOfLevel == LEVEL_1_ID)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:@"Review for written warning" delegate:self cancelButtonTitle:@"Review" otherButtonTitles:nil];
            alert.tag = LEVEL_1_ALERT_TAG;
            [alert show];
            return;
        }
        else if (changeOfLevel == LEVEL_2_ID)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:@"Review for final written warning" delegate:self cancelButtonTitle:@"Review" otherButtonTitles:nil];
            alert.tag = LEVEL_2_ALERT_TAG;
            [alert show];
            return;
        }
        else if(changeOfLevel == LEVEL_3_ID)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:@"Please prepare termination proposal and submit to Staff and Labor Relations for review" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            alert.tag = LEVEL_3_ALERT_TAG;
            [alert show];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES]; 
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == LEVEL_1_ALERT_TAG)
    {
        [self performSegueWithIdentifier:LEVEL_1_SEGUE sender:self];
    }
    else if(alertView.tag == LEVEL_2_ALERT_TAG)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(alertView.tag == LEVEL_3_ALERT_TAG)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(!IS_4_INCH_SCREEN)
    {
        [self.myScrollView setContentOffset:CGPointMake(0, 70) animated:YES];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if(!IS_4_INCH_SCREEN)
    {
        [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
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
    toolBar.barStyle = UIBarStyleBlackTranslucent;
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
