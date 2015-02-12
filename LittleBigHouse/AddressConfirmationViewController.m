
#import "AddressConfirmationViewController.h"

@interface AddressConfirmationViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation AddressConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _nextButton.layer.cornerRadius = 4;
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _nextButton.layer.shadowOpacity = 1.0;
    _nextButton.layer.shadowOffset = CGSizeMake(1, 1);
    UIColor *color = [UIColor colorWithRed:(52/255.f) green:(152/255.f) blue:(219/255.f) alpha:1.0];
    _nextButton.backgroundColor = color;
}

@end
