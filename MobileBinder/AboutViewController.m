#import "AboutViewController.h"
#import "OutlinedLabel.h"
#import <QuartzCore/QuartzCore.h>

#define AUTO_SCROLL_SPEED 0.5f
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

#define ENLARGE_TIME 0.7
#define OVERLAP_TIME 0.1
#define SPIN_TIME 4
#define NUM_OF_ROATATIONS 20
#define SHRINK_TIME 0.7

- (void) bowtieMethod
{
    self.bowtieView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bow_tie.png"]];
    self.bowtieView.contentMode = UIViewContentModeScaleAspectFit;
    float width = 1;
    float height = 1;
    float x = (self.view.frame.size.width / 2) - (width / 2);
    float y = (self.view.frame.size.height / 2) - (height / 2);
    self.bowtieView.frame = CGRectMake(x, y , width, height);
    [self.view addSubview:self.bowtieView];
    
    CGAffineTransform enlarge = CGAffineTransformScale(self.view.transform, 300, 300);
    CGAffineTransform shrink = CGAffineTransformIdentity;
    
    
    [UIView animateWithDuration:ENLARGE_TIME delay:0 options:0 animations:^{
        self.bowtieView.transform = enlarge;
    } completion:^(BOOL finished) {}];
    
    double delayInSeconds = ENLARGE_TIME - OVERLAP_TIME;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        spinAnimation.duration = SPIN_TIME;
        spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
        spinAnimation.toValue = [NSNumber numberWithFloat: NUM_OF_ROATATIONS * M_PI * 2.0];
        [self.bowtieView.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
        
        double delayInSeconds = SPIN_TIME - OVERLAP_TIME;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            
            [UIView animateWithDuration:SHRINK_TIME delay:0 options:0 animations:^{
                self.bowtieView.transform = shrink;
            } completion:^(BOOL finished) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        });
    });
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
