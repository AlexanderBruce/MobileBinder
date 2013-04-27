/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "AllSettingsViewController.h"

@interface AllSettingsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *cellTitles;
@property (nonatomic, strong) NSArray *cellSegues;
@end

@implementation AllSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cellTitles = [[NSArray alloc] initWithObjects:@"Notifications",@"Manager Details",@"Personalization",@"Reset", nil];
    self.cellSegues = [[NSArray alloc] initWithObjects:@"notificationsSegue",@"managerDetailsSegue",@"personalizationSegue",@"resetSegue", nil];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrototypeCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *view = [[UIView alloc] initWithFrame:cell.frame];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = .85;
        [cell addSubview:view];
        [cell sendSubviewToBack:view];
    }
    cell.textLabel.text = [self.cellTitles objectAtIndex:indexPath.row];

    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellTitles.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:[self.cellSegues objectAtIndex:indexPath.row] sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//This somehow removes the extra seperators for "fake" cells
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // This will create a "invisible" footer
    return 0.01f;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
