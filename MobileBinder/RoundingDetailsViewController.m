#import "RoundingDetailsViewController.h"
#import "UITextViewCell.h"
#import "RoundingLog.h"
#import "Database.h"
#import "UITextFieldCell.h"

#define EMPLOYEE_SECTION 0
#define EMPLOYEE_SECTION_HEIGHT 40

@interface RoundingDetailsViewController () <UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL addingNewEmployee;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (nonatomic) int currentRow;
@property (nonatomic, strong) UITextField *employeeNameField;
@property (nonatomic, weak) UIBarButtonItem *addEmployeeDoneButton;
@property (nonatomic, strong) UIPickerView *employeePicker;
@end

@implementation RoundingDetailsViewController

- (IBAction)addPressed:(UIBarButtonItem *)sender
{
    [Database saveDatabase];
    self.addingNewEmployee = YES;
    self.addButton.enabled = NO;
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, self.log.columnTitles.count - 1)];
    [self.tableView beginUpdates];
    [self.tableView deleteSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self.employeeNameField becomeFirstResponder];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.log allContentsForColumn:EMPLOYEE_SECTION] objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.log allContentsForColumn:EMPLOYEE_SECTION].count;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentRow = row;
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, self.log.columnTitles.count - 1)];
    [self.tableView beginUpdates];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    //Don't reload table for this row so picker doesn't go away
    self.employeeNameField.text = [self.log contentsForRow:self.currentRow column:EMPLOYEE_SECTION];  
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == EMPLOYEE_SECTION)
    {
        UITextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmployeeCell"];
        if(!cell)
        {
            cell = [[UITextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmployeeCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(!self.addingNewEmployee)
        {
            UIPickerView *picker = [[UIPickerView alloc] init];
            picker.delegate = self;
            picker.dataSource = self;
            picker.showsSelectionIndicator = YES;
            cell.textField.inputView = picker;
            cell.textField.delegate = self;
            cell.textField.text = [self.log contentsForRow:self.currentRow column:indexPath.row];
            
            UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                           style:UIBarButtonItemStyleDone target:cell.textField
                                                                          action:@selector(resignFirstResponder)];
            UIToolbar* toolBar = [[UIToolbar alloc] init];
            toolBar.barStyle = UIBarStyleBlackTranslucent;
            toolBar.translucent = YES;
            toolBar.tintColor = nil;
            [toolBar sizeToFit];
            [toolBar setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];
            cell.textField.inputAccessoryView = toolBar;

            self.employeePicker = picker;
        }
        else
        {
            cell.textField.inputView = nil;
            
            
            UIToolbar* toolBar = [[UIToolbar alloc] init];
            toolBar.barStyle = UIBarStyleBlackTranslucent;
            toolBar.translucent = YES;
            toolBar.tintColor = nil;
            [toolBar sizeToFit];
            
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStyleBordered target:self
                                                                            action:@selector(canceledAddingEmployeeName)];
            if([self.log allContentsForColumn:EMPLOYEE_SECTION].count == 0) cancelButton.enabled = NO;
            UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                           style:UIBarButtonItemStyleDone target:self
                                                                          action:@selector(doneAddingEmployeeName)];
            self.addEmployeeDoneButton = doneButton;
            self.addEmployeeDoneButton.enabled = NO;
            
            [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexibleSpace, doneButton, nil]];
            cell.textField.inputAccessoryView = toolBar;
            cell.textField.delegate = self;
            [self.employeeNameField becomeFirstResponder];
        }
        self.employeeNameField = cell.textField;
        return cell;
    }
    UITextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITextViewCell"];
    if(!cell)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = [[UITextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITextViewCell"];
    }
    cell.textView.delegate = self;
    cell.textView.tag = indexPath.section; //Use textView's tag to store the section of the tableview that it is in
    cell.textView.text = [self.log contentsForRow:self.currentRow column:indexPath.section];
    cell.textView.font = [UIFont systemFontOfSize:17];
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.log.columnTitles objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.addingNewEmployee) return 1;
    return self.log.columnTitles.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == EMPLOYEE_SECTION) return EMPLOYEE_SECTION_HEIGHT;
    else return 150;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void) doneAddingEmployeeName
{
    self.currentRow++;
    [self.log storeContents:self.employeeNameField.text forRow:self.currentRow column:EMPLOYEE_SECTION];
    self.employeeNameField.text = @"";
    [self turnOffAddingEmployeeMode];
}

- (void) canceledAddingEmployeeName
{
    [self turnOffAddingEmployeeMode];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.employeeNameField)
    {
        [self.employeePicker selectRow:self.currentRow inComponent:0 animated:YES];
        [Database saveDatabase];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSRange textFieldRange = NSMakeRange(0, [textField.text length]);
    if (NSEqualRanges(range, textFieldRange) && [string length] == 0)
    {
        self.addEmployeeDoneButton.enabled = NO;
    }
    else
    {
        self.addEmployeeDoneButton.enabled = YES;
    }
    return YES;
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    int column = textView.tag;
    [self.log storeContents:textView.text forRow:self.currentRow column:column];
}

- (void) turnOffAddingEmployeeMode
{
    self.addingNewEmployee = NO;
    self.addButton.enabled = YES;
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, self.log.columnTitles.count - 1)];
    [self.tableView beginUpdates];
    [self.tableView insertSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.addingNewEmployee = YES;
    self.addButton.enabled = NO;
    self.currentRow = -1;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [Database saveDatabase];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setAddButton:nil];
    [super viewDidUnload];
}
@end
