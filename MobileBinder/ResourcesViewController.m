//
//  ResourcesViewController.m
//  MobileBinder
//
//  Created by Alexander Bruce on 3/24/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import "ResourcesViewController.h"
#import "ResourcesModel.h"

@interface ResourcesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) ResourcesModel *myModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ResourcesViewController

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

}





@end
