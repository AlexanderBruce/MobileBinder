#import "EmployeeRoundingOverviewViewController.h"
#import "RoundingDetailsViewController.h"
#import "RoundingLog.h"
#import "Constants.h"
#import "Database.h"
#import "RoundingAllLogsViewController.h"
#import "RoundingModel.h"
#import "EMployeeRoundingLog.h"

#define ROUNDING_DETAILS_SEGUE @"roundingDetailsSegue"

#define SCROLL_OFFSET IS_4_INCH_SCREEN ? 140 : 200
#define CONTENT_SIZE IS_4_INCH_SCREEN ? 550: 590

@interface EmployeeRoundingOverviewViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *employeeNameField;
@property (weak, nonatomic) IBOutlet UITextField *unitField;
@property (weak, nonatomic) IBOutlet UITextField *leaderField;
@property (weak, nonatomic) IBOutlet UITextField *keyFocusField;
@property (weak, nonatomic) IBOutlet UITextField *keyRemindersField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) BOOL firstResponderIsActive;
@end

@implementation EmployeeRoundingOverviewViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.firstResponderIsActive = NO;

    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, CONTENT_SIZE);
    self.scrollView.scrollEnabled = NO;

    self.employeeNameField.delegate = self;
    self.unitField.delegate = self;
    self.leaderField.delegate = self;
    self.keyFocusField.delegate = self;
    self.keyRemindersField.delegate = self;

    self.employeeNameField.text = self.log.employeeName;
    self.unitField.text = self.log.unit;
    if(self.log.leader.length > 0)
    {
        self.leaderField.text = self.log.leader;
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *leader = [defaults objectForKey:MANAGER_NAME];
        if(!leader) leader = @"";
        self.leaderField.text = leader;
    }    self.keyFocusField.text = self.log.keyFocus;
    self.keyRemindersField.text = self.log.keyReminders;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.scrollView.scrollEnabled = YES;
    self.firstResponderIsActive = YES;
    if(textField == self.keyFocusField || textField == self.keyRemindersField)
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

- (void) saveDataIntoLog
{
    self.log.employeeName = self.employeeNameField.text;
    self.log.unit = self.unitField.text;
    self.log.leader = self.leaderField.text;
    self.log.keyFocus = self.keyFocusField.text;
    self.log.keyReminders = self.keyRemindersField.text;
    [Database saveDatabase];
}

- (void)viewDidUnload
{
    [self setUnitField:nil];
    [self setLeaderField:nil];
    [self setKeyFocusField:nil];
    [self setKeyRemindersField:nil];
    [self setScrollView:nil];
    [self setEmployeeNameField:nil];
    [super viewDidUnload];
}
@end
