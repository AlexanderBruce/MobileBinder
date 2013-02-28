#import "RoundingDetailsViewController.h"
#import "UITextViewCell.h"
#import "RoundingLog.h"
#import "Database.h"
#import "UITextFieldCell.h"
#import "Constants.h"

#define EMPLOYEE_SECTION 0
#define EMPLOYEE_SECTION_HEIGHT 40

@interface RoundingDetailsViewController () <UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL addingNewEmployee;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (nonatomic) int currentRow;
@property (nonatomic, strong) UITextField *employeeNameField;
@property (nonatomic, strong) UIView *employeePickerView;
@property (nonatomic, strong) UIPickerView *employeePicker;
@end

@implementation RoundingDetailsViewController

- (IBAction)addPressed:(UIBarButtonItem *)sender
{
    self.currentRow++;
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
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textField.delegate = self;
        cell.textField.text = [self.log contentsForRow:self.currentRow column:indexPath.row];
        self.employeeNameField = cell.textField;

        if(self.addingNewEmployee)
        {
            [self.employeeNameField becomeFirstResponder];
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
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


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.employeeNameField && !self.addingNewEmployee)
    {
        [self.employeePicker selectRow:self.currentRow inComponent:0 animated:YES];
        [Database saveDatabase];
    }
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.addingNewEmployee) return YES;
    else
    {
        [self.employeePicker reloadAllComponents];
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
             float y = self.view.frame.size.height - self.employeePickerView.frame.size.height;
             self.employeePickerView.frame = CGRectMake(0, y, self.employeePickerView.frame.size.width, self.employeePickerView.frame.size.height);
         } completion:^(BOOL finished) {}];
        return NO;
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.employeeNameField)
    {
        [self.log storeContents:textField.text forRow:self.currentRow column:EMPLOYEE_SECTION];
        self.addingNewEmployee = NO;
        self.addButton.enabled = YES;
        NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, self.log.columnTitles.count - 1)];
        [self.tableView beginUpdates];
        [self.tableView insertSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    int column = textView.tag;
    [self.log storeContents:textView.text forRow:self.currentRow column:column];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.addingNewEmployee = YES;
    self.addButton.enabled = NO;
    self.currentRow = 0;
    [self createPicker];
}

- (void) createPicker
{
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, TOOLBAR_HEIGHT + KEYBOARD_HEIGHT)];
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [picker sizeToFit];
    picker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [pickerView addSubview:picker];
    self.employeePicker = picker;
    
    // Create done button
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                             style:UIBarButtonItemStyleBordered target:self
                                                            action:@selector(editEmployee)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneWithPickerView)];
    UIToolbar* toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.translucent = YES;
    toolBar.tintColor = nil;
    [toolBar sizeToFit];
    [toolBar setItems:[NSArray arrayWithObjects:edit,flexibleSpace, doneButton, nil]];

    [pickerView addSubview:toolBar];
    picker.frame = CGRectMake(0, toolBar.frame.size.height, self.view.frame.size.width, pickerView.frame.size.height - TOOLBAR_HEIGHT);
    toolBar.frame = CGRectMake(0, 0, self.view.frame.size.width, TOOLBAR_HEIGHT);
    self.employeePickerView = pickerView;
    [self.view addSubview: pickerView];
}

- (void) editEmployee
{
    self.addingNewEmployee = YES;
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.employeePickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, TOOLBAR_HEIGHT + KEYBOARD_HEIGHT);
    } completion:^(BOOL finished) {
        [self.employeeNameField becomeFirstResponder];
    }];
    
}

- (void) doneWithPickerView
{
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.employeePickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, TOOLBAR_HEIGHT + KEYBOARD_HEIGHT);
    } completion:^(BOOL finished) {}];
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
