#import "SeniorRoundingOverviewViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RoundingLog.h"
#import "RoundingModel.h"
#import "SeniorRoundingLog.h"
#import "Constants.h"
#import "Database.h"


#define SCROLL_OFFSET IS_4_INCH_SCREEN ? 120 : 200
#define CONTENT_SIZE IS_4_INCH_SCREEN ? 480: 590

@interface SeniorRoundingOverviewViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *unitField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextView *notesView;
@property (nonatomic) BOOL firstResponderIsActive;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, weak) MFMailComposeViewController *mailer;
@end

@implementation SeniorRoundingOverviewViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    self.notesView.layer.cornerRadius = 5;
    self.notesView.clipsToBounds = YES;
    [self.notesView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.notesView.layer setBorderWidth:1.3]; //2.0
    self.firstResponderIsActive = NO;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, CONTENT_SIZE);
    self.scrollView.scrollEnabled = NO;
    self.dateField.delegate = self;
    self.unitField.delegate = self;
    self.nameField.delegate = self;
    self.notesView.delegate = self;
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
    if(self.log.name.length > 0)
    {
        self.nameField.text = self.log.name;
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *name = [defaults objectForKey:MANAGER_NAME];
        if(!name) name = @"";
        self.nameField.text = name;
    }
    self.unitField.text = self.log.unit;
    self.notesView.text = self.log.notes;

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


- (void) saveDataIntoLog
{
    self.log.date = [self.formatter dateFromString:self.dateField.text];
    self.log.unit = self.unitField.text;
    self.log.name = self.nameField.text;
    self.log.notes = self.notesView.text;
    [Database saveDatabase];
}


-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.scrollView.scrollEnabled = YES;
    self.firstResponderIsActive = YES;
    if(textField == self.nameField)
    {
        [self.scrollView setContentOffset:CGPointMake(0, SCROLL_OFFSET) animated:YES];
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
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }}
    );
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    self.scrollView.scrollEnabled = YES;
    self.firstResponderIsActive = YES;
    [self.scrollView setContentOffset:CGPointMake(0, SCROLL_OFFSET) animated:YES];
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    self.firstResponderIsActive = NO;
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(!self.firstResponderIsActive)
        {
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }}
                   
    );
}

- (void)viewDidUnload
{
    [self setDateField:nil];
    [self setUnitField:nil];
    [self setNameField:nil];
    [self setNotesView:nil];
    [super viewDidUnload];
}
@end
