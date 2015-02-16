
#import "HouseImagesViewController.h"
#import "LBButtonFactory.h"

@interface HouseImagesViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation HouseImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [LBButtonFactory styleButton:_nextButton];
}

@end
