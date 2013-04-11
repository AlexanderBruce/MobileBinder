#import "ResetSettingsViewController.h"
#import "Database.h"
#import <CoreData/CoreData.h>
#import "Constants.h"
#import "MBProgressHUD.h"
#import "ReminderCenter.h"
#import "BackgroundViewController.h"
#import "ReminderManagedObject.h"


#define RESET_SETTINGS_TAG 2
#define ERASE_CONTENT_TAG 3
#define RESET_ALL_TAG 4

#define RESET_COMPLETE_HUD_SHOW_TIME 2

@interface ResetSettingsViewController () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *resetSettingsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *eraseContentCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *resetAllCell;
@end

@implementation ResetSettingsViewController

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if(selectedCell == self.resetSettingsCell)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"This will reset all of the settings for this app.  Your saved content will remain untouched." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Reset Settings" otherButtonTitles:nil];
        sheet.tag = RESET_SETTINGS_TAG;
        [sheet showInView:self.view];
    }
    else if(selectedCell == self.eraseContentCell)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"This will erase all saved data in this app. Your settings will remain untouched." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Erase Content" otherButtonTitles:nil];
        sheet.tag = ERASE_CONTENT_TAG;
        [sheet showInView:self.view];
    }
    else if(selectedCell == self.resetAllCell)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"This will erase all settings and content in this app and return it to factory settings." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Reset All" otherButtonTitles:nil];
        sheet.tag = RESET_ALL_TAG;
        [sheet showInView:self.view];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void) resetSettings
{
    id workaround51Crash = [[NSUserDefaults standardUserDefaults] objectForKey:@"WebKitLocalStorageDatabasePathPreferenceKey"];
    NSDictionary *emptySettings = (workaround51Crash != nil)
    ? [NSDictionary dictionaryWithObject:workaround51Crash forKey:@"WebKitLocalStorageDatabasePathPreferenceKey"]
    : [NSDictionary dictionary];
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:emptySettings forName:[[NSBundle mainBundle] bundleIdentifier]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Delete background
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *backgroundPath = [documentsDirectory stringByAppendingPathComponent:BACKGROUND_IMAGE_FILENAME];
    [[NSFileManager defaultManager] removeItemAtPath: backgroundPath error: nil];
    
    //Remove notifications from reminder center
    [[ReminderCenter getInstance] resetWithCompletition:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [BackgroundViewController refreshBackground];
        });
    }];
}

- (void) eraseContent
{
    NSManagedObjectContext *context = [Database getInstance].managedObjectContext;
    NSManagedObjectModel *model = [[context persistentStoreCoordinator]
                                   managedObjectModel];
    
    for(NSEntityDescription *entity in [model entities])
    {
        //Don't delete reminders
        if(![entity.name isEqualToString:NSStringFromClass([ReminderManagedObject class])])
        {
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entity];
            NSArray *results = [context executeFetchRequest:request error:nil];
            for(NSManagedObject *object in results)
            {
                [context deleteObject:object];
            }
        }
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",
                          documentsDirectory,CUSTOM_DATA_FILE];
    NSString *contentsToWrite = @"";
    
    [[contentsToWrite dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];

}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != actionSheet.destructiveButtonIndex) return;
    
    switch (actionSheet.tag)
    {
        case RESET_SETTINGS_TAG:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self resetSettings];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showCompletitionHUD];
                    double delayInSeconds = RESET_COMPLETE_HUD_SHOW_TIME;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                });
            });
        }
        break;
            
        case ERASE_CONTENT_TAG:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self eraseContent];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showCompletitionHUD];
                    double delayInSeconds = RESET_COMPLETE_HUD_SHOW_TIME;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                });
            });
        }
        break;
            
        case RESET_ALL_TAG:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self resetSettings];
                [self eraseContent];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showCompletitionHUD];
                    double delayInSeconds = RESET_COMPLETE_HUD_SHOW_TIME;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                });
            });
        }
        break;
            
        default:
            break;
    }
}

- (void) showCompletitionHUD
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES fontSize:17];
    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.labelText = @"Complete";
    [HUD show:YES];
    [HUD hide:YES afterDelay:RESET_COMPLETE_HUD_SHOW_TIME];
}

- (void)viewDidUnload {
    [self setResetSettingsCell:nil];
    [self setEraseContentCell:nil];
    [self setResetAllCell:nil];
    [super viewDidUnload];
}
@end
