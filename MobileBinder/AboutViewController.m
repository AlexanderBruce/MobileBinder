#import "AboutViewController.h"
#import "OutlinedLabel.h"

#define AUTO_SCROLL_SPEED 3 //0.5f
#define DELAY_BEFORE_AUTOSCROLLING 5

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (nonatomic, strong) UIView *bowtieView;
@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    float maxY = 0;
    for(UIView *view in self.scrollView.subviews)
    {
        if([view isKindOfClass:[OutlinedLabel class]])
        {
            OutlinedLabel *label = (OutlinedLabel *) view;
            [label customize];
            float currentY = label.frame.origin.y + label.frame.size.height;
            if(currentY > maxY) maxY = currentY;
        }
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, maxY);
    UITapGestureRecognizer *myScrollViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAutoScrollState)];
    myScrollViewTap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:myScrollViewTap];
}

- (void) changeAutoScrollState
{
    @synchronized(self)
    {
        if(self.autoScrollTimer)
        {
            [self.autoScrollTimer invalidate];
            self.autoScrollTimer = nil;
        }
        else
        {
            self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:.03 target:self selector:@selector(scroll) userInfo:nil repeats:YES];
        }
    }
}

- (void) scroll
{
    CGPoint newOffset = CGPointMake(0, self.scrollView.contentOffset.y + AUTO_SCROLL_SPEED);
    if(newOffset.y > self.scrollView.contentSize.height)
    {
        [self.autoScrollTimer invalidate];
        [self bowtieMethod];
        return;
    }
    [self.scrollView setContentOffset:newOffset animated:NO];
}

- (void) bowtieMethod
{
    self.bowtieView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bow_tie.png"]];
    self.bowtieView.contentMode = UIViewContentModeScaleAspectFit;
    float width = 20;
    float height = 20;
    float x = (self.view.frame.size.width / 2) - (width / 2);
    float y = (self.view.frame.size.height / 2) - (height / 2);
    self.bowtieView.frame = CGRectMake(x, y , width, height);
    [self.view addSubview:self.bowtieView];
    CGAffineTransform tr = CGAffineTransformScale(self.view.transform, 14, 14);
    [UIView animateWithDuration:2.5 delay:0 options:0 animations:^{
        self.bowtieView.transform = tr;
    } completion:^(BOOL finished) {
        CGAffineTransform minTr = CGAffineTransformMakeRotation(360);
        [UIView animateWithDuration:2.5 delay:0 options:0 animations:^{
            self.bowtieView.transform = minTr;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
