//
//  PayrollPeriodViewController.m
//  MobileBinder
//
//  Created by Samuel Rang on 1/30/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import "PayrollPeriodViewController.h"

@interface PayrollPeriodViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *PeriodTypeSegmented;
@property (weak, nonatomic) IBOutlet UITextField *PeriodSelection;

@end

@implementation PayrollPeriodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload {
    [self setPeriodTypeSegmented:nil];
    [self setPeriodSelection:nil];
    [super viewDidUnload];
}
@end
