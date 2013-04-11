#import "EmployeeRoundingAllLogsViewController.h"
#import "EmployeeRoundingLog.h"
#import "EmployeeRoundingModel.h"

@interface EmployeeRoundingAllLogsViewController ()

@end

@implementation EmployeeRoundingAllLogsViewController

- (UITableViewCell *) customizeCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath usingRoundingLog:(RoundingLog *)log
{
    if(![log isKindOfClass:[EmployeeRoundingLog class]])
    {
        [NSException raise:@"Invalid type of rounding log" format:@"Trying to use a non-employee rounding log in the EmployeeRoundingAllLogsViewController"];
    }
    EmployeeRoundingLog *currentLog = (EmployeeRoundingLog *) log;
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    
    //Create label text for cell
    NSMutableString *labelText = [@"" mutableCopy];
    
    if(currentLog.employeeName.length > 0) [labelText appendString:currentLog.employeeName];
    if(currentLog.employeeName.length > 0 && currentLog.unit.length > 0) [labelText appendFormat:@": %@", currentLog.unit];
    else if(currentLog.unit.length > 0) [labelText appendFormat:@"%@",currentLog.unit];
    if((currentLog.employeeName.length > 0|| currentLog.unit.length > 0) && currentLog.leader.length > 0) [labelText appendFormat:@" (%@)",currentLog.leader];
    else if(currentLog.leader.length > 0) [labelText appendFormat:@"(%@)",currentLog.leader];
    
    if(labelText.length == 0) labelText = [NSString stringWithFormat:@"Log %d",indexPath.row + 1];
    cell.textLabel.text = labelText;
    
    //Create detail text for cell
    NSString *detailText = @"";
    if(currentLog.keyFocus.length > 0) detailText = currentLog.keyFocus;
    else if(currentLog.keyReminders.length > 0) detailText = currentLog.keyReminders;
    cell.detailTextLabel.text = detailText;
    return cell;
}

- (RoundingModel *) createModel
{
    return [[EmployeeRoundingModel alloc] init];
}

@end
