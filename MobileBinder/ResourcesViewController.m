//
//  ResourcesViewController.m
//  MobileBinder
//
//  Created by Alexander Bruce on 3/24/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import "ResourcesViewController.h"
#import "ResourcesModel.h"
#import "WebviewViewController.h"
#define SEGUE @"webSegue"

@interface ResourcesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) ResourcesModel *myModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *webUrl;
@end

@implementation ResourcesViewController
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[WebviewViewController class]]){
        WebviewViewController *dest = segue.destinationViewController;
        dest.webpageURL = self.webUrl;
        
    }
}
-(void) viewDidLoad
{
    self.myModel = [[ResourcesModel alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrototypeCell"];
    NSArray *titles = [self.myModel getPageTitles];
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myModel getNumberOfResourceLinks];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *links = [self.myModel getResourceLinks];
    self.webUrl =(NSString *) [links objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:SEGUE sender:self];
    
}





@end
