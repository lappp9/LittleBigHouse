
#import "LBButtonFactory.h"

@implementation LBButtonFactory

+ (void)styleButton:(UIButton *)button;
{
    button.layer.cornerRadius = 4;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    button.layer.shadowOpacity = 1.0;
    button.layer.shadowOffset = CGSizeMake(1, 1);
    UIColor *color = [UIColor colorWithRed:(52/255.f) green:(152/255.f) blue:(219/255.f) alpha:1.0];
    button.backgroundColor = color;
}

@end
