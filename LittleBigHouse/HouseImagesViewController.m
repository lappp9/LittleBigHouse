
#import "HouseImagesViewController.h"
#import "LBButtonFactory.h"
#import "LBLocationManager.h"
#import "LBGoogleMapStreetViewController.h"
#import "LBConnectivityMonitor.h"
#import <pop/POP.h>

@interface HouseImagesViewController ()
@property (nonatomic) UIButton *nextButton;
@property (nonatomic) UILabel *label;

@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;

@property (nonatomic) UIView *streetViewContainer;

@property (nonatomic) UIImageView *leftScreenshot;
@property (nonatomic) UIImageView *centerScreenshot;
@property (nonatomic) UIImageView *rightScreenshot;

@property (nonatomic) UILabel *noInternetLabel;

@end

@implementation HouseImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth  = [UIScreen mainScreen].bounds.size.width;

    [self.navigationController setNavigationBarHidden:NO];

    if (![self navigationController]) {
        [self addDismissableNavBar];
    } else {
        self.title = @"Take Screenshots";
    }

    [self layoutNextButton];
    [self layoutMapView];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(noInternetConnection:) name:@"noInternetConnection" object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(internetConnection:) name:@"internetConnection" object:nil];
    
    if (!LBConnectivityMonitor.shared.connected) {
        [self noInternetConnection:nil];
    }
}

- (void)noInternetConnection:(NSNotification *)note;
{
    _noInternetLabel = [LBConnectivityMonitor.shared networkNotAvailableLabel];
    [self.view addSubview:_noInternetLabel];
    [self.view bringSubviewToFront:_noInternetLabel];
    _noInternetLabel.layer.zPosition = 1;
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(_screenWidth/2, _noInternetLabel.frame.size.height/2 + 50)];
    
    POPBasicAnimation *alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnim.toValue = @(1.0);
    
    [_noInternetLabel pop_addAnimation:anim forKey:nil];
    [_noInternetLabel pop_addAnimation:alphaAnim forKey:nil];
}

- (void)internetConnection:(NSNotification *)note;
{
    if (_noInternetLabel && [self.view.subviews containsObject:_noInternetLabel]) {
        [_noInternetLabel removeFromSuperview];
    }
}

- (void)addDismissableNavBar;
{
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, _screenWidth, 44)];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissWasTapped:)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Take Screenshots"];
    item.leftBarButtonItem = backButton;
    [navbar setItems:@[item]];
    navbar.layer.zPosition = 2;
    
    [self.view addSubview:navbar];
}

- (void)dismissWasTapped:(UIBarButtonItem *)backButton;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)layoutMapView;
{
    UIView *mapView = [[UIView alloc] init];
    
    CGFloat mapHeight = _screenHeight - 44 - 8 - 20 - _nextButton.frame.size.height;
    
    mapView.frame = CGRectMake(0, 44, _screenWidth, mapHeight);
    mapView.backgroundColor = [UIColor darkGrayColor];
    
    _streetViewContainer = [[UIView alloc] init];
    _streetViewContainer.frame = CGRectMake(0, 0, _screenWidth, mapHeight * (7.0/9.0));
    _streetViewContainer.backgroundColor = [UIColor greenColor];
    
    
    LBGoogleMapStreetViewController *vc;
    
    if (_coordinates.latitude == 0 && _coordinates.longitude == 0) {
        vc = [[LBGoogleMapStreetViewController alloc] initWithLocationManagerLocation];
    } else {
        vc = [[LBGoogleMapStreetViewController alloc] initWithCoordinates:_coordinates];
    }
    
    vc.view.frame = _streetViewContainer.frame;
    
    [_streetViewContainer addSubview:vc.view];
   
    [mapView addSubview:_streetViewContainer];
    
    [self layoutScreenShotViews:mapView];
    
    [self.view addSubview:mapView];
}

- (void)layoutScreenShotViews:(UIView *)mapView;
{
    _leftScreenshot   = [[UIImageView alloc] init];
    _centerScreenshot = [[UIImageView alloc] init];
    _rightScreenshot  = [[UIImageView alloc] init];
    
    NSInteger i = 0;
    CGFloat subViewWidth = mapView.frame.size.width/3;
    NSArray *colors = @[[UIColor blueColor], [UIColor redColor], [UIColor purpleColor]];
    
    for (UIView *view in @[_leftScreenshot, _centerScreenshot, _rightScreenshot]) {
        view.frame = CGRectMake(i * subViewWidth, mapView.frame.size.height * (7.0/9.0), subViewWidth, mapView.frame.size.height * (2.0/9.0));
        view.backgroundColor = (UIColor *)colors[i];
        
        view.userInteractionEnabled = YES;
        
        [mapView addSubview:view];
        i++;
    }
    
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftScreenshotWasTapped:)];
    UITapGestureRecognizer *centerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerScreenshotWasTapped:)];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightScreenshotWasTapped:)];
    
    _leftScreenshot.image = [UIImage imageNamed:@"front_left"];
    _centerScreenshot.image = [UIImage imageNamed:@"front"];
    _rightScreenshot.image = [UIImage imageNamed:@"front_right"];
    
    _leftScreenshot.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _centerScreenshot.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _rightScreenshot.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _leftScreenshot.layer.borderWidth = 1;
    _centerScreenshot.layer.borderWidth = 1;
    _rightScreenshot.layer.borderWidth = 1;
    
    [_leftScreenshot addGestureRecognizer:leftTap];
    [_centerScreenshot addGestureRecognizer:centerTap];
    [_rightScreenshot addGestureRecognizer:rightTap];
}

- (void)leftScreenshotWasTapped:(UITapGestureRecognizer *)tap;
{
    UIImage *screenshot = [self imageWithView:_streetViewContainer];
    
    _leftScreenshot.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _leftScreenshot.image = screenshot;
}

- (void)centerScreenshotWasTapped:(UITapGestureRecognizer *)tap;
{
    UIImage *screenshot = [self imageWithView:_streetViewContainer];
    
    _centerScreenshot.layer.borderColor = [UIColor whiteColor].CGColor;

    _centerScreenshot.image = screenshot;
}

- (void)rightScreenshotWasTapped:(UITapGestureRecognizer *)tap;
{
    UIImage *screenshot = [self imageWithView:_streetViewContainer];
    
    _rightScreenshot.layer.borderColor = [UIColor whiteColor].CGColor;

    _rightScreenshot.image = screenshot;
}


- (void)layoutNextButton;
{
    CGFloat yOrigin = [UIScreen mainScreen].bounds.size.height - 60 - 20;
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width - 32;
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _nextButton.frame = CGRectMake(16, yOrigin, buttonWidth, 60);
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_nextButton setTitle: @"Next" forState:UIControlStateNormal];
    [LBButtonFactory blueStyleButton:_nextButton];
    
    [_nextButton addTarget:self action:@selector(nextButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_nextButton];
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)nextButtonWasTapped:(UIButton *)button;
{
    
}

- (BOOL)prefersStatusBarHidden;
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated;
{
    if ([self.view.subviews containsObject:_noInternetLabel]) {
        [_noInternetLabel removeFromSuperview];
    }
}

- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
