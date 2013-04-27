/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "AddResourceViewController.h"
#import "ResourcesModel.h"
#import "Constants.h"
#import "OutlinedLabel.h"

#define KEYBOARD_HEIGHT 216.0f
#define TOOLBAR_HEIGHT 44
#define PICKER_HIDE_ANIMATION_SPEED .4
#define PICKER_SHOW_ANIMATION_SPEED .4

#define PICKER_OFFSET IS_4_INCH_SCREEN ? 55 : 150
#define CONTENT_SIZE IS_4_INCH_SCREEN ? 360: 415

@interface AddResourceViewController () <UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UITextField *pageTitle;
@property (weak, nonatomic) IBOutlet UITextField *webPageUrl;
@property (weak, nonatomic) IBOutlet UITextField *description;
@property (weak, nonatomic) IBOutlet UITextField *category;
@property (strong, nonatomic)UIPickerView *myPicker;
@property (nonatomic, strong) UIView *pickerView;
@property (nonatomic) BOOL pickerIsVisible;
@property (nonatomic) BOOL firstResponderIsActive;
@end

@implementation AddResourceViewController

#define TITLE_OFFSET (IS_4_INCH_SCREEN ? 15 : 0)
#define URL_OFFSET (IS_4_INCH_SCREEN ? 15 : 65)
#define DESCRIPTION_OFFSET (IS_4_INCH_SCREEN ? 15 : 105)
#define CATEGORY_OFFSET (IS_4_INCH_SCREEN ? 15 : 105)

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(self.pickerIsVisible){
        self.pickerIsVisible = NO;
        [UIView animateWithDuration:PICKER_HIDE_ANIMATION_SPEED animations:^
         {
             self.pickerView.frame = CGRectMake(0, self.view.frame.size.height, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
         }];
        
    }
    self.myScrollView.scrollEnabled = YES;
    self.firstResponderIsActive = YES;
    if(textField == self.pageTitle)
    {
        [self.myScrollView setContentOffset:CGPointMake(0, TITLE_OFFSET) animated:YES];
    }
    else if(textField == self.webPageUrl)
    {
        [self.myScrollView setContentOffset:CGPointMake(0, URL_OFFSET) animated:YES];
    }
    else if(textField == self.description)
    {
        [self.myScrollView setContentOffset:CGPointMake(0, DESCRIPTION_OFFSET) animated:YES];
    }
    else if(textField == self.category)
    {
        [self.myScrollView setContentOffset:CGPointMake(0, CATEGORY_OFFSET) animated:YES];
    }

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createPicker];
    for (UIView *view in self.myScrollView.subviews)
    {
        if([view isKindOfClass:[OutlinedLabel class]])
        {
            OutlinedLabel *label = (OutlinedLabel *) view;
            [label customize];
        }
    }
    self.pickerIsVisible = NO;
    self.description.delegate = self;
    self.pageTitle.delegate = self;
    self.webPageUrl.delegate = self;
    self.category.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden)
                                                 name:UIKeyboardWillHideNotification object:nil];
    self.myScrollView.contentSize = CGSizeMake(self.myScrollView.contentSize.width, CONTENT_SIZE);
    self.myScrollView.scrollEnabled = NO;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void) hideKeyboard
{
    [self.myScrollView endEditing:YES];
}

- (IBAction)doneButtonPressed:(id)sender
{
    if([self.pageTitle.text isEqualToString:@""]||[self.webPageUrl.text isEqualToString:@""]||[self.category.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Missing Fields" message:@"A resource needs a title, a URL and a category" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
    if([self.webPageUrl.text hasPrefix:@"www"])self.webPageUrl.text = [NSString stringWithFormat:@"%@%@", @"http://", self.webPageUrl.text];
    if([self.description.text isEqualToString:@""])self.description.text = @" ";
        [self.myModel addResourceObjectwithPageTitle:self.pageTitle.text url:self.webPageUrl.text description:self.description.text category:[self.category.text capitalizedString]];
    [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)preExistingPressed:(UIButton *)sender
{
    if(!self.pickerIsVisible)
    {
        [self.myScrollView endEditing:YES];
        self.pickerIsVisible = YES;
        [UIView animateWithDuration:PICKER_SHOW_ANIMATION_SPEED animations:^
         {
             self.pickerView.frame = CGRectMake(0, self.view.frame.size.height - self.pickerView.frame.size.height, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
         }];
        self.firstResponderIsActive = YES;
        [self.myScrollView setContentOffset:CGPointMake(0, PICKER_OFFSET) animated:YES];
        BOOL needToDefault = YES;
        for(int i =0; i<[self.myModel getNumberOfCategoriesWhenUnfiltered];i++){
            if([self.category.text caseInsensitiveCompare:[self pickerView:self.myPicker titleForRow:i forComponent:0]] == NSOrderedSame){
                self.category.text = [self pickerView:self.myPicker titleForRow:i forComponent:0];
                [self.myPicker selectRow:i inComponent:0 animated:YES];
                needToDefault = NO;
                
            }
        }
        if(needToDefault){
        self.category.text =[self pickerView:self.myPicker titleForRow:0 forComponent:0];
         [self.myPicker selectRow:0 inComponent:0 animated:YES];
        }
        
    }
    
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidUnload {
    [self setPageTitle:nil];
    [self setWebPageUrl:nil];
    [self setDescription:nil];
    [self setCategory:nil];
    [self setMyScrollView:nil];
    [super viewDidUnload];
}

-(UIView *) createPicker
{
    UIView *pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, KEYBOARD_HEIGHT+TOOLBAR_HEIGHT)];
    
    self.myPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, TOOLBAR_HEIGHT, self.view.frame.size.width, KEYBOARD_HEIGHT)];
    self.myPicker.dataSource = self;
    self.myPicker.delegate = self;
    self.myPicker.showsSelectionIndicator = YES;
    
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    toolBar.translucent = YES;
    [toolBar sizeToFit];
    UIBarButtonItem  *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pickerPressed)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects: flexible, doneButton, nil]];
    
    [pickerView addSubview:self.myPicker];
    [pickerView addSubview:toolBar];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
    
    return pickerView;
}

#pragma mark - UIPickerViewDataSource & Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.category.text = [self pickerView:pickerView titleForRow:row forComponent:component];

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [self.myModel getNumberOfCategoriesWhenUnfiltered];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result = nil;
    result =[self.myModel getNameOfCategoryWhenUnFiltered:row];
    return result;
}


-(void) pickerPressed
{
    
    if(self.pickerIsVisible)
    {
        self.pickerIsVisible = NO;
        [UIView animateWithDuration:PICKER_HIDE_ANIMATION_SPEED animations:^
         {
             self.pickerView.frame = CGRectMake(0, self.view.frame.size.height, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
         }];
        self.firstResponderIsActive = NO;
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            if(!self.firstResponderIsActive)
            {
                [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        });
    }
}

#pragma mark Scrolling Features
- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        if(!self.firstResponderIsActive)
        {
            [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    });
}

- (void) keyboardWillBeHidden
{
    self.myScrollView.scrollEnabled = NO;
}
@end
