
#import "LBHomeViewController.h"

@interface LBHomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addressButton;

@end

@implementation LBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _addressButton.layer.cornerRadius = 4;
    [_addressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addressButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _addressButton.layer.shadowOpacity = 1.0;
    _addressButton.layer.shadowOffset = CGSizeMake(1, 1);
    UIColor *color = [UIColor colorWithRed:(52/255.f) green:(152/255.f) blue:(219/255.f) alpha:1.0];
    _addressButton.backgroundColor = color;
}

@end
