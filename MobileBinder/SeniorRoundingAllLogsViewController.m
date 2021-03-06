/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import "SeniorRoundingAllLogsViewController.h"
#import "SeniorRoundingLog.h"
#import "RoundingModel.h"
#import "SeniorRoundingModel.h"

@interface SeniorRoundingAllLogsViewController ()

@end

@implementation SeniorRoundingAllLogsViewController


- (UITableViewCell *) customizeCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath usingRoundingLog:(RoundingLog *)log
{
    if(![log isKindOfClass:[SeniorRoundingLog class]])
    {
        [NSException raise:@"Invalid type of rounding log" format:@"Trying to use a non-employee rounding log in the EmployeeRoundingAllLogsViewController"];
    }
    SeniorRoundingLog *currentLog = (SeniorRoundingLog *) log;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    
    //Create label text for cell
    NSMutableString *labelText = [@"" mutableCopy];
    
    if(currentLog.date) [labelText appendString:[formatter stringFromDate:currentLog.date]];
    if(currentLog.date && currentLog.unit.length > 0) [labelText appendFormat:@": %@", currentLog.unit];
    else if(currentLog.unit.length > 0) [labelText appendFormat:@"%@",currentLog.unit];
    if((currentLog.date || currentLog.unit.length > 0) && currentLog.name.length > 0) [labelText appendFormat:@" (%@)",currentLog.name];
    else if(currentLog.name.length > 0) [labelText appendFormat:@"(%@)",currentLog.name];
    
    if(labelText.length == 0) labelText = [NSString stringWithFormat:@"Log %d",indexPath.row + 1];
    cell.textLabel.text = labelText;
    
    //Create detail text for cell
    NSString *detailText = @"";
    if(currentLog.notes.length > 0) detailText = currentLog.notes;
    cell.detailTextLabel.text = detailText;
    return cell;
}

- (RoundingModel *) createModel
{
    return [[SeniorRoundingModel alloc] init];
}



@end
