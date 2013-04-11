#import "PersonalizationViewController.h"
#import "MobileCoreServices/UTCoreTypes.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "UIImageResizing.h"
#import "JPImagePickerController.h"
#import "BackgroundViewController.h"
#import "PredefinedImagesModel.h"
#import "OutlinedLabel.h"

#define HEADER_TEXT @"App Wallpaper"

#define PREDEFINED_LABEL @"Default Images"
#define PREDEFINED_ROW 0

#define LIBRARY_LABEL @"Select from Library"
#define LIBRARY_ROW 1

@interface PersonalizationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate, JPImagePickerControllerDelegate, JPImagePickerControllerDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *loadingIndexPath;
@property (nonatomic, strong) PredefinedImagesModel *model;
@end

@implementation PersonalizationViewController

- (PredefinedImagesModel *) model
{
    if(!_model) _model = [[PredefinedImagesModel alloc] init];
    return _model;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
    //Hide back button
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectZero];
    UIBarButtonItem *tmpButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tmpView];
    self.navigationItem.leftBarButtonItem = tmpButtonItem;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Prototype Cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Prototype Cell"];
    }
    if([indexPath isEqual:self.loadingIndexPath])
    {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake(0, 0, 24, 24);
        cell.accessoryView = indicator;
        [indicator startAnimating];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    if(indexPath.row == PREDEFINED_ROW)
    {
        cell.textLabel.text = PREDEFINED_LABEL;
    }
    else if(indexPath.row == LIBRARY_ROW)
    {
        cell.textLabel.text = LIBRARY_LABEL;
    }
    return cell;
}

#define HEADER_HEIGHT 42
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, HEADER_HEIGHT)];
    //section text as a label
    float x = 12;
    float y = 9;
    OutlinedLabel *label = [[OutlinedLabel alloc] initWithFrame:CGRectMake(x, y, view.frame.size.width - x, HEADER_HEIGHT - y)];
    label.font = [UIFont boldSystemFontOfSize:17];
    [view addSubview:label];
    [label customize];
    label.text = HEADER_TEXT;
    [label setBackgroundColor:[UIColor clearColor]];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == PREDEFINED_ROW)
    {
        JPImagePickerController *imagePickerController = [[JPImagePickerController alloc] init];
		imagePickerController.delegate = self;
		imagePickerController.dataSource = self;
		imagePickerController.imagePickerTitle = @"Backgrounds";
        [self.navigationController presentModalViewController:imagePickerController animated:YES];
    }
    else if(indexPath.row == LIBRARY_ROW)
    {
        self.loadingIndexPath = indexPath;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone]; //Start showing loading indicator
        [self initializeImagePickerWithCompletion:^{
            self.loadingIndexPath = nil;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone]; //Stop showing loading indicator
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) initializeImagePickerWithCompletion: (void (^)())completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypePhotoLibrary])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                      (NSString *) kUTTypeImage,
                                      nil];
        imagePicker.allowsEditing = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:imagePicker animated:YES completion:^{
                completionBlock();}];
        });
    });
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) return; //Only use this method for iPhone
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
    navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

/*
 *   Responds when an image is selected (from browsing)
 */
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self processImage:image];
    }
}

- (void) processImage: (UIImage *) image
{
    MBProgressHUD *progressIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES fontSize:PROGRESS_INDICATOR_LABEL_FONT_SIZE];
    progressIndicator.animationType = MBProgressHUDAnimationFade;
    progressIndicator.mode = MBProgressHUDModeIndeterminate;
    progressIndicator.labelText = @"Processing";
    progressIndicator.dimBackground = NO;
    progressIndicator.taskInProgress = YES;
    progressIndicator.removeFromSuperViewOnHide = YES;
    self.view.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *scaledImage = [image scaleAndCropToSize:self.view.frame.size onlyIfNeeded:YES];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:BACKGROUND_IMAGE_FILENAME];
        NSData *imageData = UIImagePNGRepresentation(scaledImage);
        BOOL success = [imageData writeToFile:savedImagePath atomically:YES];
        NSLog(@"Success = %d",success);
        dispatch_async(dispatch_get_main_queue(), ^{
            [BackgroundViewController refreshBackground];
            self.view.userInteractionEnabled = YES;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    });
}

/*
*   Browse for photo operation canceled
*/
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)donePressed:(id)sender
{
    [self.delegate savedSettingsForViewController:self];
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark JPImagePickerControllerDelegate

- (void)imagePickerDidCancel:(JPImagePickerController *)picker {
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)imagePicker:(JPImagePickerController *)picker didFinishPickingWithImageNumber:(NSInteger)imageNumber
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    UIImage *selectedImage = [self.model getImageWithNumber:imageNumber];
	[self processImage:selectedImage];
}

# pragma mark JPImagePickerControllerDataSource

- (NSInteger)numberOfImagesInImagePicker:(JPImagePickerController *)picker {
	return [self.model getNumberOfImages];
}

- (UIImage *)imagePicker:(JPImagePickerController *)picker thumbnailForImageNumber:(NSInteger)imageNumber
{
	return [self.model getThumbnailWithNumber:imageNumber];
}

- (UIImage *)imagePicker:(JPImagePickerController *)imagePicker imageForImageNumber:(NSInteger)imageNumber
{
	return [self.model getImageWithNumber:imageNumber];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
