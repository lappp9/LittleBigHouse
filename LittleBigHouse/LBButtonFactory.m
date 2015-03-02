
#import "LBButtonFactory.h"

@implementation LBButtonFactory

+ (void)clearStyleButton:(UIButton *)button;
{
    button.layer.cornerRadius = 25;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    button.layer.shadowOpacity = 1.0;
    button.layer.shadowOffset = CGSizeMake(1, 1);
    [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.borderWidth = 5.0;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    
    UIColor *color = [UIColor clearColor];
    button.backgroundColor = color;
}

+ (void)blueStyleButton:(UIButton *)button;
{
    button.layer.cornerRadius = 4;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    button.layer.shadowOpacity = 1.0;
    button.layer.shadowOffset = CGSizeMake(1, 1);
    [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    UIColor *color = [UIColor colorWithRed:(52/255.f) green:(152/255.f) blue:(219/255.f) alpha:1.0];
    button.backgroundColor = color;
}

@end
