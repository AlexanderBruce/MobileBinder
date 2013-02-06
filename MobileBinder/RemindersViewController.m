#import "RemindersViewController.h"
#import "Reminder.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ReminderCenter.h"

#define KEYBOARD_HEIGHT 216.0f
#define TOOLBAR_HEIGHT 44

#define PICKER_APPEAR_TIME .5
#define PICKER_DISAPPEAR_TIME .5

#define DAY_TITLE @"Day"
#define WEEK_TITLE @"Week"
#define MONTH_TITLE @"Month"
#define YEAR_TITLE @"Year"

@interface RemindersViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDate *minDateInTable;
@property (nonatomic, strong) NSDate *maxDateInTable;

@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSMutableDictionary *rowsForSections;

@end

@implementation RemindersViewController


#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.rowsForSections objectForKey:[NSNumber numberWithInt:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionTitles objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Prototype Cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Prototype Cell"];
    }
    NSArray *arrayForSection = [self.rowsForSections objectForKey:[NSNumber numberWithInt:indexPath.section]];
    Reminder *reminder = [arrayForSection objectAtIndex:indexPath.row];
    cell.textLabel.text = reminder.text;

    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sectionTitles = [[NSMutableArray alloc] init];
    self.rowsForSections = [[NSMutableDictionary alloc] init];
    
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = -7;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    self.minDateInTable = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    dayComponent.day = 7;
    self.maxDateInTable = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self createTestReminders];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 2.0; //These two seconds are necessary...who knows why
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self addNewDataToTableView];
            [self.tableView.infiniteScrollingView stopAnimating];
        });

    }];
}

- (void) addNewDataToTableView
{
    ReminderCenter *center = [ReminderCenter getInstance];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [self.tableView beginUpdates];
    dayComponent.day = 7;
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
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [newIndexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    
    [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];

}

- (void) viewDidAppear:(BOOL)animated
{
    [self.tableView triggerInfiniteScrolling];
}

- (void) createTestReminders
{
    ReminderCenter *center = [ReminderCenter getInstance];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    for(int i = 0; i < 10000; i ++)
    {
        Reminder *r1 = [[Reminder alloc] initWithText:@"Time Card Due" eventDate:[NSDate date] fireDate:[calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0]  typeID:nil];
        [center addReminder:r1];
        dayComponent.day = dayComponent.day + 1;

        Reminder *r2 = [[Reminder alloc] initWithText:@"Pay check issued" eventDate:[NSDate date] fireDate:[calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0]  typeID:nil];
        [center addReminder:r2];

        Reminder *r3 = [[Reminder alloc] initWithText:@"Employee Attendance sheet filing date" eventDate:[NSDate date] fireDate:[calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0]  typeID:nil];
        [center addReminder:r3];
        dayComponent.day = dayComponent.day + 1;

        Reminder *r4 = [[Reminder alloc] initWithText:@"2 weeks until pay day" eventDate:[NSDate date] fireDate:[calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0]  typeID:nil];
        [center addReminder:r4];

        Reminder *r5 = [[Reminder alloc] initWithText:@"New Employee Orientation" eventDate:[NSDate date] fireDate:[calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0]  typeID:nil];
        [center addReminder:r5];

        Reminder *r6 = [[Reminder alloc] initWithText:@"Company Picnic" eventDate:[NSDate date] fireDate:[calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0]  typeID:nil];
        [center addReminder:r6];

        Reminder *r7 = [[Reminder alloc] initWithText:@"Nuclear Weapon Testing" eventDate:[NSDate date] fireDate:[calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0]  typeID:nil];
        [center addReminder:r7];
        dayComponent.day = dayComponent.day + 1;
    }
    [center synchronize];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
