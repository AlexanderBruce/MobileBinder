#import "RoundingDetailsViewController.h"
#import "UITextViewCell.h"
#import "RoundingLog.h"
#import "Database.h"
#import "UITextFieldCell.h"
#import "UIButton+Disable.h"
#import "Constants.h"

#define EMPLOYEE_SECTION 0
#define EMPLOYEE_SECTION_HEIGHT 35

@interface RoundingDetailsViewController () <UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int currentRow;
@property (nonatomic, strong) UITextField *employeeNameField;
@property (nonatomic, strong) UIView *employeePickerView;
@property (nonatomic, strong) UIPickerView *employeePicker;
@property (nonatomic) BOOL pickerIsVisible;
@property (nonatomic, weak) UIButton *switchButton;
@end

@implementation RoundingDetailsViewController

- (IBAction)addPressed:(UIBarButtonItem *)sender
{
    [self.tableView endEditing:YES];
    self.currentRow = [self.log addRow];
    if([self.log allContentsForColumn:EMPLOYEE_SECTION].count >= 2) [self.switchButton enableButton];
    else [self.switchButton disableButton];
    [Database saveDatabase];
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.log.columnTitles.count - 1)];
    [self.tableView beginUpdates];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self.employeeNameField becomeFirstResponder];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *employeeAtRow = [[self.log allContentsForColumn:EMPLOYEE_SECTION] objectAtIndex:row];
    if(employeeAtRow.length > 0) return employeeAtRow;
    else return [NSString stringWithFormat:@"Entry %d",row + 1];
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
            cell.textField.delegate = self;
            [cell.switchButton addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
        }

        cell.textField.text = [self.log contentsForRow:self.currentRow column:indexPath.row];
        self.employeeNameField = cell.textField;
        self.switchButton = cell.switchButton;
        if([self.log allContentsForColumn:EMPLOYEE_SECTION].count >= 2) [self.switchButton enableButton];
        else [self.switchButton disableButton];
        
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textView.tag = indexPath.section;  //Store section in textviewTag
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

- (void) showPicker
{
    if(self.pickerIsVisible) return;
    self.pickerIsVisible = YES;
    [self.tableView endEditing:YES];
    [self.employeePicker reloadAllComponents];
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        float y = self.view.frame.size.height - self.employeePickerView.frame.size.height;
        self.employeePickerView.frame = CGRectMake(0, y, self.employeePickerView.frame.size.width, self.employeePickerView.frame.size.height);
    } completion:^(BOOL finished) {}];
}

- (void) hidePicker
{
    if(!self.pickerIsVisible) return;
    self.pickerIsVisible = NO;
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.employeePickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, TOOLBAR_HEIGHT + KEYBOARD_HEIGHT);
    } completion:^(BOOL finished) {}];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidePicker];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EMPLOYEE_SECTION] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:textView.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self hidePicker];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self.log storeContents:textField.text forRow:self.currentRow column:EMPLOYEE_SECTION];
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
    self.currentRow = 0;
    self.pickerIsVisible = NO;
    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, 5000);
    [self createPicker];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.delegate = self;
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void) hideKeyboard
{
    [self.tableView endEditing:YES];
}

- (void) keyboardWillShow
{
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - KEYBOARD_HEIGHT);} completion:^(BOOL finished) {}];
}

- (void) keyboardWillHide
{
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + KEYBOARD_HEIGHT);} completion:^(BOOL finished) {}];
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
    

    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(hidePicker)];
    UIToolbar* toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.translucent = YES;
    toolBar.tintColor = nil;
    [toolBar sizeToFit];
    [toolBar setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];

    [pickerView addSubview:toolBar];
    picker.frame = CGRectMake(0, toolBar.frame.size.height, self.view.frame.size.width, pickerView.frame.size.height - TOOLBAR_HEIGHT);
    toolBar.frame = CGRectMake(0, 0, self.view.frame.size.width, TOOLBAR_HEIGHT);
    self.employeePickerView = pickerView;
    [self.view addSubview: pickerView];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"%@ %@",[gestureRecognizer.view class],[otherGestureRecognizer.view class]); //cancel touches in view
    return (gestureRecognizer.view == self.switchButton || otherGestureRecognizer.view == self.switchButton);
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [Database saveDatabase];
}

@end
