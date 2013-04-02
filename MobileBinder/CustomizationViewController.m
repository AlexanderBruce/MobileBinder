#import "CustomizationViewController.h"
#import "MobileCoreServices/UTCoreTypes.h"
#import "Constants.h"

@interface CustomizationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
@end

@implementation CustomizationViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.delegate savedSettingsForViewController:self];
}

- (IBAction)selectFromLibraryPressed:(UIButton *)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
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
        [self presentModalViewController:imagePicker animated:YES];
    }
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
        {
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            //Save image
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:BACKGROUND_IMAGE_FILENAME];
            NSData *imageData = UIImagePNGRepresentation(image);
            [imageData writeToFile:savedImagePath atomically:NO];
            dispatch_async(dispatch_get_main_queue(), ^{});
        }
    });
}

/*
*   Browse for photo operation canceled
*/
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}




@end
