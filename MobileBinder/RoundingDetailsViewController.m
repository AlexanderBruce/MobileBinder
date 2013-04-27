/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "RoundingDetailsViewController.h"
#import "UITextViewCell.h"
#import "RoundingLog.h"
#import "Database.h"
#import "UITextFieldCell.h"
#import "UIButton+Disable.h"
#import "Constants.h"
#import "RoundingModel.h"
#import "MBProgressHUD.h"
#import "RoundingLogManagedObjectProtocol.h"
#import <MessageUI/MFMailComposeViewController.h>

#define EMPLOYEE_SECTION 0
#define EMPLOYEE_SECTION_HEIGHT 35

#define TEXTVIEW_CELL_HEIGHT 150

#define DELETE_SECTION_HEIGHT 35

#define BACK_PRESSED_ALERT_TITLE @"Unsaved Changes"
#define BACK_PRESSED_ALERT_MESSAGE @"Do you wish to save your log before going back?"
#define BACK_PRESSED_ALERT_CANCEL_BUTTON_TITLE @"Don't Save"
#define BACK_PRESSED_ALERT_BUTTON_TITLE @"Save"
#define BACK_PRESSED_ALERT_TAG 2

@interface RoundingDetailsViewController () <UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate,UIGestureRecognizerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int currentRow;
@property (nonatomic, strong) UITextField *employeeNameField;
@property (nonatomic, strong) UIView *employeePickerView;
@property (nonatomic, strong) UIPickerView *employeePicker;
@property (nonatomic) BOOL pickerIsVisible;
@property (nonatomic, weak) UIButton *switchButton;
@property (nonatomic, weak) MFMailComposeViewController *mailer;
@end

@implementation RoundingDetailsViewController

- (IBAction)backPressed:(id)sender
{
    [self.tableView endEditing:YES];
    if(self.log.saved)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:BACK_PRESSED_ALERT_TITLE message:BACK_PRESSED_ALERT_MESSAGE delegate:self cancelButtonTitle:BACK_PRESSED_ALERT_CANCEL_BUTTON_TITLE otherButtonTitles:BACK_PRESSED_ALERT_BUTTON_TITLE, nil];
        alertView.tag = BACK_PRESSED_ALERT_TAG;
        [alertView show];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == BACK_PRESSED_ALERT_TAG)
    {
        if(buttonIndex == alertView.cancelButtonIndex)
        {
            [self.log discardChanges];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self showSavingIndicator];
            [self.log saveLogWithCompletition:^{
                self.view.userInteractionEnabled = YES;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}

- (IBAction)savePressed:(id)sender
{
    [self.tableView endEditing:YES];
    dispatch_async(dispatch_get_current_queue(), ^{ //Make sure that textfield has a chance to store its info before progressing
        [self showSavingIndicator];
        [self.log saveLogWithCompletition:^{
            self.view.userInteractionEnabled = YES;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    });
}

- (void) showSavingIndicator
{
    MBProgressHUD *progressIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES fontSize:PROGRESS_INDICATOR_LABEL_FONT_SIZE];
    progressIndicator.animationType = MBProgressHUDAnimationFade;
    progressIndicator.mode = MBProgressHUDModeIndeterminate;
    progressIndicator.labelText = @"Saving";
    progressIndicator.dimBackground = NO;
    progressIndicator.taskInProgress = YES;
    progressIndicator.removeFromSuperViewOnHide = YES;
    progressIndicator.userInteractionEnabled = NO;
    progressIndicator.minShowTime = 1.0;
    self.view.userInteractionEnabled = NO;
}

- (IBAction)addPressed:(id)sender
{
    [self.tableView endEditing:YES];
    self.currentRow = [self.log addRow];
    if(self.log.numberOfRows >= 2) [self.switchButton enableButton];
    else [self.switchButton disableButton];
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.log.numberOfColumns - 1)];
    [self.tableView beginUpdates];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:EMPLOYEE_SECTION] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self.employeeNameField becomeFirstResponder];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *employeeAtRow = [[self.log allContentsForColumn:EMPLOYEE_SECTION] objectAtIndex:row];
    if(employeeAtRow.length > 0) return employeeAtRow;
    else return [NSString stringWithFormat:@"Unit %d",row + 1];
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
    [self loadNewCurrentRow:row];
}

- (void) loadNewCurrentRow: (int) newCurrentRow
{
    self.currentRow = newCurrentRow;
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, self.log.numberOfColumns - 1)];
    [self.tableView beginUpdates];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableView endUpdates];
    //Don't reload table for this row so picker doesn't go away
    self.employeeNameField.text = [self.log contentsForRow:self.currentRow column:EMPLOYEE_SECTION];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.destructiveButtonIndex)
    {
        [self.log deleteRow:self.currentRow];
        [self loadNewCurrentRow:MAX(0, self.currentRow - 1)];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == EMPLOYEE_SECTION)
    {
        UITextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];

        if(!cell)
        {
            cell = [[UITextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrototypeCell"];
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
    if(indexPath.section < self.log.numberOfColumns)
    {
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
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Delete Cell"];
        if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Delete Cell"];
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"Delete Button.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
        cell.backgroundView = backgroundImage;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = @"Delete Unit";
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    

}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section < [self.log getColumnTitles].count)
    {
        return [[self.log getColumnTitles] objectAtIndex:section];
    }
    else return @"";
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section >= self.log.numberOfColumns) //Delete row
    {
        NSString *rowTitle = [[[self.log getColumnTitles] objectAtIndex:0] lowercaseString];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Are you sure you want to delete the log data for this %@?", rowTitle] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.log.numberOfColumns + 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == EMPLOYEE_SECTION) return EMPLOYEE_SECTION_HEIGHT;
    else if(indexPath.section < self.log.numberOfColumns) return TEXTVIEW_CELL_HEIGHT;
    else return DELETE_SECTION_HEIGHT;
}


- (void) showPicker
{
    if(self.pickerIsVisible) return;
    self.pickerIsVisible = YES;
    [self.tableView endEditing:YES];
    [self.employeePicker reloadAllComponents];
    [self.employeePicker selectRow:self.currentRow inComponent:0 animated:YES];
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
    if(![textField.text isEqualToString:[self.log contentsForRow:self.currentRow column:EMPLOYEE_SECTION]])
    {
        [self.log storeContents:textField.text forRow:self.currentRow column:EMPLOYEE_SECTION];
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
    self.tableView.allowsSelection = YES;
    self.currentRow = 0;
    self.pickerIsVisible = NO;
    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, 5000);
    [self createPicker];
    

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.delegate = self;
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void) applicationWillResignActive
{
    [self.tableView endEditing:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(!self.mailer)
    {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.log.numberOfRows == 0)
    {
        self.currentRow = [self.log addRow];
        [self.employeeNameField becomeFirstResponder];
    }
}

- (void) hideKeyboard
{
    [self.tableView endEditing:YES];
}

- (void) keyboardWillShow
{
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
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


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
     // Might want to use cancel touches in view here
    return (gestureRecognizer.view == self.switchButton || otherGestureRecognizer.view == self.switchButton);
}

- (IBAction)sharePressed:(id)sender
{
    [self.tableView endEditing:YES];
    dispatch_async(dispatch_get_current_queue(), ^{ //Make sure that textfield has a chance to store its info before progressing
        self.mailer = [self.model generateRoundingDocumentFor:self.log];
        self.mailer.mailComposeDelegate = self;
        [self presentModalViewController:self.mailer animated:YES];
    });
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self.mailer dismissViewControllerAnimated:YES completion:^{}];
}


- (void)dealloc
{
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [Database saveDatabase];
}

@end
