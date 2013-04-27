/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "RoundingAllLogsViewController.h"
#import "EmployeeRoundingOverviewViewController.h"
#import "SeniorRoundingOverviewViewController.h"
#import "RoundingModel.h"
#import "RoundingLog.h"

#define ROUNDING_LOG_OVERVIEW_SEGUE @"roundingLogOverviewSegue"

@interface RoundingAllLogsViewController () <RoundingModelDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RoundingModel *model;
@property (nonatomic, strong) RoundingLog *selectedLog;

@end

@implementation RoundingAllLogsViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setLog:self.selectedLog];
    [segue.destinationViewController setModel:self.model];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PrototypeCell"];
    NSArray *logs = [self.model getRoundingLogs];

    RoundingLog *currentLog = [logs objectAtIndex:indexPath.row];
    [self customizeCell:cell forIndexPath:indexPath usingRoundingLog:currentLog];
    return cell;
}

- (UITableViewCell *) customizeCell: (UITableViewCell *) cell forIndexPath: (NSIndexPath *) indexPath usingRoundingLog: (RoundingLog *) log
{
    [NSException raise:@"Override Error" format:@"Method %@ must be overidden in class %@",NSStringFromSelector(_cmd),self.class];
    return nil;
}

- (RoundingModel *) createModel
{
    [NSException raise:@"Override Error" format:@"Method %@ must be overidden in class %@",NSStringFromSelector(_cmd),self.class];
    return nil;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model getRoundingLogs].count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedLog = [[self.model getRoundingLogs] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:ROUNDING_LOG_OVERVIEW_SEGUE sender:self];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSArray *roundingLogs = [self.model getRoundingLogs];
        RoundingLog *logToDelete = [roundingLogs objectAtIndex:indexPath.row];
        [self.model deleteRoundingLog: logToDelete];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row < [self.model getRoundingLogs].count);
}


- (IBAction)addLogPressed:(UIBarButtonItem *)sender
{
    self.selectedLog = [self.model addNewRoundingLog];
    [self performSegueWithIdentifier:ROUNDING_LOG_OVERVIEW_SEGUE sender:self];
}

- (void) doneRetrievingRoundingLogs
{
    [self.tableView reloadData];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.model = [self createModel];
    self.model.delegate = self;
    [self.model fetchRoundingLogsForFutureUse];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
