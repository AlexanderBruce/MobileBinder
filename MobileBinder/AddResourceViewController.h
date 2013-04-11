//
//  AddResourceViewController.h
//  MobileBinder
//
//  Created by Alexander Bruce on 4/6/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundViewController.h"
@class ResourcesModel;

@interface AddResourceViewController : BackgroundViewController
@property (strong,nonatomic) ResourcesModel * myModel;
@end
