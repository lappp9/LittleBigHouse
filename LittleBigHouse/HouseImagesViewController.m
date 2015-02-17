
#import "HouseImagesViewController.h"
#import "LBButtonFactory.h"
#import <GoogleMaps/GoogleMaps.h>

@interface HouseImagesViewController ()
@property (nonatomic) UIButton *nextButton;
@property (nonatomic) UILabel *label;
@property (nonatomic) UIView *mapView;
@end

@implementation HouseImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self layoutLabel];
    [self layoutNextButton];
    [self layoutMapView];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)layoutMapView;
{
    _mapView = [[UIView alloc] init];
    _mapView.frame = (CGRect){{0, 0}, CGSizeMake([UIScreen mainScreen].bounds.size.width - 32, [UIScreen mainScreen].bounds.size.height/2)};
    _mapView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    _mapView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_mapView];
}

- (void)layoutLabel;
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(16, 44 + 16 + 20, [UIScreen mainScreen].bounds.size.width - 32, 44)];
    _label.text = @"Choose images";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont fontWithName:@"HelveticaNeue" size:24];

    [self.view addSubview:_label];
}

- (void)layoutNextButton;
{
    CGFloat yOrigin = [UIScreen mainScreen].bounds.size.height - 60 - 20;
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width - 32;
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _nextButton.frame = CGRectMake(16, yOrigin, buttonWidth, 60);
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_nextButton setTitle: @"Next" forState:UIControlStateNormal];
    [LBButtonFactory styleButton:_nextButton];
    
    [_nextButton addTarget:self action:@selector(nextButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_nextButton];
}

- (void)nextButtonWasTapped:(UIButton *)button;
{
    
}

@end
