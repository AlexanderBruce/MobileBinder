#import "RemindersViewController.h"
#import "Reminder.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ReminderCenter.h"
#import "MarqueeCell.h"

#define FIRST_DAY_IN_TABLE -7
#define NUMBER_OF_DAYS_IN_FETCH 14
#define MIN_SIZE_UNTIL_FETCH_COMPLETE 12
#define MAX_NUMBER_OF_FETCHES 12

@interface RemindersViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDate *minDateInTable;
@property (nonatomic, strong) NSDate *maxDateInTable;

@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSMutableDictionary *rowsForSections;
@property (nonatomic, strong) NSString *noRemindersHeaderText;
@end

@implementation RemindersViewController


#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.rowsForSections objectForKey:[NSNumber numberWithInt:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.sectionTitles.count == 0) return self.noRemindersHeaderText;
    else return [self.sectionTitles objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.sectionTitles.count == 0) return 1;
    else return self.sectionTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarqueeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Prototype Cell"];
    if(!cell)
    {
        cell = [[MarqueeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Prototype Cell"];
    }
    NSArray *arrayForSection = [self.rowsForSections objectForKey:[NSNumber numberWithInt:indexPath.section]];
    Reminder *reminder = [arrayForSection objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setLabelText:reminder.text];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sectionTitles = [[NSMutableArray alloc] init];
    self.rowsForSections = [[NSMutableDictionary alloc] init];
    self.noRemindersHeaderText = @"";
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    dayComponent.day = FIRST_DAY_IN_TABLE;

    NSDateComponents *comps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
    NSDate *max = [calendar dateFromComponents:comps];
    
    self.maxDateInTable = [calendar dateByAddingComponents:dayComponent toDate:max options:0];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 2.0; //These two seconds are necessary...who knows why
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        __block int numberRetrieved = 0;
        __block int numberOfFetches = 0;
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            while (numberRetrieved < MIN_SIZE_UNTIL_FETCH_COMPLETE && numberOfFetches < MAX_NUMBER_OF_FETCHES)
            {
                numberRetrieved += [self addNewDataToTableView];
                numberOfFetches ++;
            }
            if(numberOfFetches >= MAX_NUMBER_OF_FETCHES && numberRetrieved <MIN_SIZE_UNTIL_FETCH_COMPLETE)
            {
                self.noRemindersHeaderText = @"No scheduled reminders";
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [self.tableView.infiniteScrollingView stopAnimating];
        });

    }];
}

- (int) addNewDataToTableView
{
    ReminderCenter *center = [ReminderCenter getInstance];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [self.tableView beginUpdates];
    dayComponent.day = NUMBER_OF_DAYS_IN_FETCH;
    self.minDateInTable = self.maxDateInTable;
    self.maxDateInTable = [calendar dateByAddingComponents:dayComponent toDate:self.maxDateInTable options:0];
    NSArray *newReminders =[center getRemindersBetween:self.minDateInTable andEndDate:self.maxDateInTable];
    NSMutableArray *newIndexPaths = [[NSMutableArray alloc] init];
    
    NSDateComponents *lastComponents;
    int section = self.sectionTitles.count - 1;
    int row = 0;
    
    for(Reminder *current in newReminders)
    {
        NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:current.fireDate];
        if(currentComponents.day == lastComponents.day && currentComponents.month == lastComponents.month && currentComponents.year == lastComponents.year)
        {
            row ++;
            NSMutableArray *arrayForSection = [self.rowsForSections objectForKey:[NSNumber numberWithInt:section]];
            [arrayForSection addObject:current];
        }
        else
        {
            lastComponents = currentComponents;
            section ++;
            row = 0;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateStyle = NSDateFormatterLongStyle;
            [self.sectionTitles addObject:[formatter stringFromDate:[calendar dateFromComponents:currentComponents]]];
            [self.rowsForSections setObject:[NSMutableArray arrayWithObject:current] forKey:[NSNumber numberWithInt:section]];
            if(section > 0)
            {
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else
            {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
        [newIndexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];    
    }
    
    [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    return newIndexPaths.count;

}

- (void) viewDidAppear:(BOOL)animated
{
    [self.tableView triggerInfiniteScrolling];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
