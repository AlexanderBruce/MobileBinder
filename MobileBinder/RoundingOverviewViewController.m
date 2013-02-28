#import "RoundingOverviewViewController.h"
#import "RoundingDetailsViewController.h"
#import "RoundingLog.h"
#import "Constants.h"
#import "Database.h"
#import "RoundingAllLogsViewController.h"
#import "RoundingModel.h"

#define ROUNDING_DETAILS_SEGUE @"roundingDetailsSegue"

#define SCROLL_OFFSET IS_4_INCH_SCREEN ? 100 : 200
#define CONTENT_SIZE IS_4_INCH_SCREEN ? 490: 590

@interface RoundingOverviewViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *unitField;
@property (weak, nonatomic) IBOutlet UITextField *leaderField;
@property (weak, nonatomic) IBOutlet UITextField *keyFocusField;
@property (weak, nonatomic) IBOutlet UITextField *keyRemindersField;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic) BOOL firstResponderIsActive;
@end

@implementation RoundingOverviewViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[RoundingDetailsViewController class]])
    {
        RoundingDetailsViewController *dest = segue.destinationViewController;
        dest.log = self.log;
    }
}

- (IBAction)nextPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:ROUNDING_DETAILS_SEGUE sender:self];
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    self.firstResponderIsActive = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden)
                                                 name:UIKeyboardWillHideNotification object:nil];
    self.myScrollView.contentSize = CGSizeMake(self.myScrollView.contentSize.width, CONTENT_SIZE);
    self.myScrollView.scrollEnabled = NO;

    
    self.dateField.delegate = self;
    self.unitField.delegate = self;
    self.leaderField.delegate = self;
    self.keyFocusField.delegate = self;
    self.keyRemindersField.delegate = self;
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateStyle = NSDateFormatterShortStyle;
    self.dateField.inputView = [self createDatePicker];
    
    if(self.log.date)
    {
        self.dateField.text = [self.formatter stringFromDate:self.log.date];
    }
    else
    {
        self.dateField.text = [self.formatter stringFromDate:[NSDate date]];
    }
    self.unitField.text = self.log.unit;
    self.leaderField.text = self.log.leader;
    self.keyFocusField.text = self.log.keyFocus;
    self.keyRemindersField.text = self.log.keyReminders;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.myScrollView.scrollEnabled = YES;
    self.firstResponderIsActive = YES;
    if(textField == self.keyFocusField || textField == self.keyRemindersField)
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


- (UIView *) createDatePicker
{
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, TOOLBAR_HEIGHT + KEYBOARD_HEIGHT)];
    
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    [picker sizeToFit];
    picker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    picker.datePickerMode = UIDatePickerModeDate;
    [picker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
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

- (void) doneUsingPicker
{
    [self.dateField resignFirstResponder];
}


- (void) updateDateField: (UIDatePicker *) datePicker
{
    self.dateField.text = [self.formatter stringFromDate:datePicker.date];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.myScrollView endEditing:YES];
    self.log.date = [self.formatter dateFromString:self.dateField.text];
    self.log.unit = self.unitField.text;
    self.log.leader = self.leaderField.text;
    self.log.keyFocus = self.keyFocusField.text;
    self.log.keyReminders = self.keyRemindersField.text;
    [Database saveDatabase];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    [self setDateField:nil];
    [self setUnitField:nil];
    [self setLeaderField:nil];
    [self setKeyFocusField:nil];
    [self setKeyRemindersField:nil];
    [self setMyScrollView:nil];
    [super viewDidUnload];
}
@end
