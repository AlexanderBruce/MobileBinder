#import "BackgroundViewController.h"
#import "Constants.h"

@interface BackgroundViewController ()
@property (nonatomic, weak) NSValue *value; //Opaque object used for holding weak reference to self
@end

static NSMutableArray *instances;
static NSMutableDictionary *vcToValueMap;
static UIColor *backgroundColor;

@implementation BackgroundViewController

+ (void) initialize
{
    instances = [[NSMutableArray alloc] init];
    vcToValueMap = [[NSMutableDictionary alloc] init];
    [BackgroundViewController loadBackgroundImage];
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
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:BACKGROUND_IMAGE_FILENAME];
    UIImage *image = [UIImage imageWithContentsOfFile:getImagePath];
    backgroundColor = [UIColor colorWithPatternImage:image];
}

+ (void) refreshBackground
{
    [BackgroundViewController loadBackgroundImage];
    for (NSValue *value in instances)
    {
        BackgroundViewController *vc = [value nonretainedObjectValue];
        vc.view.backgroundColor = backgroundColor;
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
    self.view.backgroundColor = backgroundColor;
}

- (void) dealloc
{
    [BackgroundViewController removeViewControllerFromInstances:self.value];
}

@end
