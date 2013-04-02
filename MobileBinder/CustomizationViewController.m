#import "CustomizationViewController.h"
#import "MobileCoreServices/UTCoreTypes.h"

@interface CustomizationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
@property (nonatomic, strong) UIPopoverController *popController; //Maybe make weak
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
    if ([self.popController isPopoverVisible])
    {
        [self.popController dismissPopoverAnimated:YES];
        self.popController = nil;
    } else {
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
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                self.popController = [[UIPopoverController alloc]
                                          initWithContentViewController:imagePicker];
                
                self.popController.delegate = self;
                [self.popController presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            }
            else
            {
                imagePicker.delegate = self;
                [self presentModalViewController:imagePicker animated:YES];
            }
        }
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
    [self.popController dismissPopoverAnimated:true];
    self.popController = nil;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]) forKey:@"BackgroundImage"];
//        UIImage *image = [[UIImage alloc] initWithData:UIImageJPEGRepresentation([info objectForKey:UIImagePickerController], .2)];
//        UIImage *scaledImage = [UIImage scaleImage:image toSize:SCALED_IMAGE_SIZE];
    }
}

/*
*   Browse for photo operation canceled
*/
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.popController dismissPopoverAnimated:true];
}




@end
