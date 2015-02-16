
#import "LBAddressEntryViewController.h"
#import "LBButtonFactory.h"

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

    [LBButtonFactory styleButton:_nextButton];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
