#import "RoundingOverviewViewController.h"
#import "RoundingDetailsViewController.h"
#import "RoundingLog.h"
#import "Constants.h"
#import "Database.h"
#import "RoundingLoadViewController.h"
#import "RoundingModel.h"

#define ROUNDING_DETAILS_SEGUE @"roundingDetailsSegue"
#define LOAD_SEGUE @"loadSegue"

@interface RoundingOverviewViewController () <UITextFieldDelegate, RoundingLoadDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *unitField;
@property (weak, nonatomic) IBOutlet UITextField *leaderField;
@property (weak, nonatomic) IBOutlet UITextField *keyFocusField;
@property (weak, nonatomic) IBOutlet UITextField *keyRemindersField;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) RoundingLog *log;
@property (nonatomic, strong) RoundingModel *model;
@end

@implementation RoundingOverviewViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[RoundingDetailsViewController class]])
    {
        RoundingDetailsViewController *dest = segue.destinationViewController;
        dest.log = self.log;
    }
    else if([segue.destinationViewController isKindOfClass:[RoundingLoadViewController class]])
    {
        RoundingLoadViewController *dest = segue.destinationViewController;
        dest.delegate = self;
        dest.model = self.model;
    }
}

- (void) selectedRoundingLog:(RoundingLog *)log
{
    self.log = log;
    self.dateField.text = [self.formatter stringFromDate:log.date];
    self.unitField.text = log.unit;
    self.leaderField.text = log.leader;
    self.keyFocusField.text = log.keyFocus;
    self.keyRemindersField.text = log.keyReminders;
}

- (IBAction)continuePressed:(UIButton *)sender
{
    [self saveRoundingLogWithCompletition:^{
        [self performSegueWithIdentifier:ROUNDING_DETAILS_SEGUE sender:self];
    }];
}

- (IBAction)loadPressed:(UIBarButtonItem *)sender
{
    [self saveRoundingLogWithCompletition:^{
        [self performSegueWithIdentifier:LOAD_SEGUE sender:self];
    }];
}

- (void) saveRoundingLogWithCompletition: (void (^) (void)) block
{
    self.log.date = [self.formatter dateFromString:self.dateField.text];
    self.log.unit = self.unitField.text;
    self.log.leader = self.leaderField.text;
    self.log.keyFocus = self.keyFocusField.text;
    self.log.keyReminders = self.keyRemindersField.text;
    [Database saveDatabaseWithCompletion:block];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.dateField.delegate = self;
    self.unitField.delegate = self;
    self.leaderField.delegate = self;
    self.keyFocusField.delegate = self;
    self.keyRemindersField.delegate = self;
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateStyle = NSDateFormatterShortStyle;
    self.dateField.text = [self.formatter stringFromDate:[NSDate date]];
    self.dateField.inputView = [self createDatePicker];
    self.log = [[RoundingLog alloc] init];
    self.model = [[RoundingModel alloc] init];
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

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
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
