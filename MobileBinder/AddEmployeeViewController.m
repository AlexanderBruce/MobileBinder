#import "AddEmployeeViewController.h"
#import "EmployeeRecord.h"

@interface AddEmployeeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@end

@implementation AddEmployeeViewController

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    if(self.firstNameField.text.length > 0 && self.lastNameField.text.length > 0)
    {
        EmployeeRecord *record = [[EmployeeRecord alloc] init];
        record.firstName = self.firstNameField.text;
        record.lastName = self.lastNameField.text;
        [self.delegate addedNewEmployeeRecord:record];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"All fields must be completed" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
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
}


- (void)viewDidUnload {
    [self setFirstNameField:nil];
    [self setLastNameField:nil];
    [super viewDidUnload];
}
@end
