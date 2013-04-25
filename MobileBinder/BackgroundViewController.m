#import "BackgroundViewController.h"
#import "Constants.h"

@interface BackgroundViewController ()
@property (nonatomic, weak) NSValue *value; //Opaque object used for holding weak reference to self
@property (nonatomic, weak) UIView *backgroundView; //Only used when a viewcontroller is presented modally
@end

static NSMutableArray *instances;
static NSMutableDictionary *vcToValueMap;
static UIColor *backgroundColor;

@implementation BackgroundViewController

+ (void) initialize
{
    if(self == [BackgroundViewController class])
    {
        instances = [[NSMutableArray alloc] init];
        vcToValueMap = [[NSMutableDictionary alloc] init];
        [BackgroundViewController loadBackgroundImage];
    }
}

+ (NSValue *) addViewControllerToInstances: (BackgroundViewController *) viewController
{
    NSValue *value = [NSValue valueWithNonretainedObject:viewController];
    [instances addObject:value];
    return value;
}

+ (void) loadBackgroundImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:BACKGROUND_IMAGE_FILENAME];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if(image)
    {
        backgroundColor = [UIColor colorWithPatternImage:image];
    }
    else if(!image)
    {
        backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    }
}

+ (void) refreshBackground
{
    [BackgroundViewController loadBackgroundImage];
    for (NSValue *value in instances)
    {
        BackgroundViewController *vc = [value nonretainedObjectValue];
        [BackgroundViewController setBackgroundForViewController:vc];
    }
}

#define TOOLBAR_HEIGHT 44

+ (void) setBackgroundForViewController: (BackgroundViewController *) viewController
{
    if(!viewController.navigationController)
    {
        viewController.view.backgroundColor = [UIColor clearColor];
        UIView *backgroundView = viewController.backgroundView;
        if(!backgroundView)
        {
            backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, TOOLBAR_HEIGHT, viewController.view.frame.size.width, viewController.view.frame.size.height - TOOLBAR_HEIGHT)];
            [viewController.view addSubview:backgroundView];
            [viewController.view sendSubviewToBack:backgroundView];
        }
        backgroundView.backgroundColor = backgroundColor;
    }
    else
    {
        viewController.view.backgroundColor = backgroundColor;
    }
}

+ (void) removeViewControllerFromInstances: (NSValue *) value
{
    [instances removeObject:value];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.value = [BackgroundViewController addViewControllerToInstances:self];
    [BackgroundViewController setBackgroundForViewController:self];
}

- (void) dealloc
{
    [BackgroundViewController removeViewControllerFromInstances:self.value];
}

@end
