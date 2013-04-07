//
//  AddResourceViewController.m
//  MobileBinder
//
//  Created by Alexander Bruce on 4/6/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import "AddResourceViewController.h"
#import "ResourcesModel.h"
#define KEYBOARD_HEIGHT 216.0f
#define TOOLBAR_HEIGHT 44
#define PICKER_HIDE_ANIMATION_SPEED .6
#define PICKER_SHOW_ANIMATION_SPEED .5

@interface AddResourceViewController () <UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pageTitle;
@property (weak, nonatomic) IBOutlet UITextField *webPageUrl;
@property (weak, nonatomic) IBOutlet UITextField *description;
@property (weak, nonatomic) IBOutlet UITextField *category;
@property (strong, nonatomic)UIPickerView *myPicker;
@property (nonatomic, strong) UIView *pickerView;
@property (nonatomic) BOOL pickerIsVisible;
@end

@implementation AddResourceViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createPicker];
    self.pickerIsVisible = NO;
}
- (IBAction)doneButtonPressed:(id)sender
{
    if([self.pageTitle.text isEqualToString:@""]||[self.webPageUrl.text isEqualToString:@""]||[self.category.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Missing Fields" message:@"A resource needs a title, a url, and a category" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
    if([self.webPageUrl.text hasPrefix:@"www"])self.webPageUrl.text = [NSString stringWithFormat:@"%@%@", @"http://", self.webPageUrl.text];
    if([self.description.text isEqualToString:@""])self.description.text = @" ";
        [self.myModel addResourceObjectwithPageTitle:self.pageTitle.text url:self.webPageUrl.text description:self.description.text category:self.category.text];
    [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)preExistingPressed:(UIButton *)sender
{
    if(!self.pickerIsVisible)
    {
        self.pickerIsVisible = YES;
        [UIView animateWithDuration:PICKER_SHOW_ANIMATION_SPEED animations:^
         {
             self.pickerView.frame = CGRectMake(0, self.view.frame.size.height - self.pickerView.frame.size.height, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
         }];
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
    return [self.myModel getNumberOfCategories];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result = nil;
    result =[self.myModel getNameOfCategory:row];
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
    }
}
@end
