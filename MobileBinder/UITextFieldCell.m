#import "UITextFieldCell.h"

@implementation UITextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textField = [self createTextField];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

- (UITextField *) createTextField
{
    UITextField *textField = [[UITextField alloc] init];
    float x = 10;
    float y = 8;
    float width = self.contentView.frame.size.width - (2 * x);
    float height = 32;
    textField.frame = CGRectMake(x, y, width, height);
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return textField;
}


@end
