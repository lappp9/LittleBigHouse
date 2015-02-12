
#import "LBAddressEntryViewController.h"

@interface LBAddressEntryViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *streetOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *streetTwoTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;

@end

@implementation LBAddressEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UITextField *textField in @[_streetOneTextField, _streetTwoTextField, _cityTextField, _stateTextField, _zipCodeTextField]) {
        textField.delegate = self;
    }
    
    _nextButton.layer.cornerRadius = 4;
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _nextButton.layer.shadowOpacity = 1.0;
    _nextButton.layer.shadowOffset = CGSizeMake(1, 1);
    UIColor *color = [UIColor colorWithRed:(52/255.f) green:(152/255.f) blue:(219/255.f) alpha:1.0];
    _nextButton.backgroundColor = color;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
