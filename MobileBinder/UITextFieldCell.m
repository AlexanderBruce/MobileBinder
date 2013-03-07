#import "UITextFieldCell.h"
#import <QuartzCore/QuartzCore.h>

#define BUTTON_WIDTH 70

@interface UITextFieldCell()
@property (nonatomic) CGRect originalContentView;
@end

@implementation UITextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textField = [self createTextField];
        [self.contentView addSubview:self.textField];
        self.switchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.switchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.switchButton setTitle:@"Switch" forState:UIControlStateNormal];
        [self addSubview:self.switchButton];
        
        self.contentView.backgroundColor = [UIColor whiteColor];

        self.contentView.layer.cornerRadius = 8;
        self.contentView.clipsToBounds = YES;
        struct CGColor *borderColor = [[UIColor lightGrayColor] CGColor];
        self.contentView.layer.borderColor = borderColor;
        self.contentView.layer.borderWidth = 1.1;
        self.switchButton.layer.borderColor = borderColor;
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (UITextField *) createTextField
{
    UITextField *textField = [[UITextField alloc] init];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    float x = 10;
    float y = 0;
    float width = self.contentView.frame.size.width - (2 * x);
    float height = self.contentView.frame.size.height - (2 * y);
    textField.frame = CGRectMake(x, y, width, height);
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return textField;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    if(CGRectIsEmpty(self.originalContentView)) self.originalContentView = self.contentView.frame;
    //240 40
    
    
    float x = self.originalContentView.origin.x + self.originalContentView.size.width - BUTTON_WIDTH;
    float y = self.originalContentView.origin.y;
    float width = BUTTON_WIDTH;
    float height = self.originalContentView.size.height;
    self.switchButton.frame = CGRectMake(x, y, width, height);
    
    x = self.originalContentView.origin.x;
    y = self.switchButton.frame.origin.y;
    width = self.switchButton.frame.origin.x - x - 8;
    height = self.switchButton.frame.size.height;
    self.contentView.frame = CGRectMake(x,y,width,height);



}


@end
