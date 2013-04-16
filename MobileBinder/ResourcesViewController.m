#import "ResourcesViewController.h"
#import "ResourcesModel.h"
#import "WebviewViewController.h"
#import "ResourceObject.h"
#import "AddResourceViewController.h"
#define SEGUE @"webSegue"
#define RESOURCE_SEGUE @"addResourceSegue"

@interface ResourcesViewController () <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) ResourcesModel *myModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *webUrl;
@property (nonatomic) BOOL searchBarShouldBeginEditing;
@end

@implementation ResourcesViewController
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[WebviewViewController class]])
    {
        WebviewViewController *dest = segue.destinationViewController;
        dest.webpageURL = self.webUrl;
    }
    if([segue.destinationViewController isKindOfClass:[AddResourceViewController class]])
        {
            AddResourceViewController *dest = segue.destinationViewController;
            dest.myModel = self.myModel;
        }
}
-(void) viewDidLoad
{
    self.myModel = [[ResourcesModel alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.searchBarShouldBeginEditing = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrototypeCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    ResourceObject *cur = [self.myModel getResourceForCategory:indexPath.section index:indexPath.row];
    cell.textLabel.text = cur.pageTitle;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myModel getNumberOfLinksForCategory:section];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResourceObject *r = [self.myModel getResourceForCategory:indexPath.section index:indexPath.row];
    self.webUrl = r.webpageURL;
    [self performSegueWithIdentifier:SEGUE sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.myModel getNumberOfCategories];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.myModel getNameOfCategory:section];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.myModel filterResourceLinksByString:searchBar.text];
    [self.tableView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    BOOL boolToReturn = self.searchBarShouldBeginEditing;
    self.searchBarShouldBeginEditing = YES;
    return boolToReturn;
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchBar.text.length == 0)
    {
        [self.myModel stopFilteringResourceLinks];
        [self.tableView reloadData];
    }
}

- (IBAction)addResourceButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"addResourceSegue" sender:self];
}



@end
