
#import "LBHomeViewController.h"
#import "LBButtonFactory.h"

@interface LBHomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addressButton;

@end

@implementation LBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [LBButtonFactory styleButton:_addressButton];
}

@end
