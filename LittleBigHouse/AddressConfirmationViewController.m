
#import "AddressConfirmationViewController.h"
#import "LBButtonFactory.h"

@interface AddressConfirmationViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation AddressConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [LBButtonFactory styleButton:_nextButton];
}

@end
