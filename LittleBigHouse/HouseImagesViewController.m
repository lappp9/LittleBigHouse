
#import "HouseImagesViewController.h"
#import "LBButtonFactory.h"
#import "LBLocationManager.h"
#import "LBGoogleMapStreetViewController.h"

@interface HouseImagesViewController ()
@property (nonatomic) UIButton *nextButton;
@property (nonatomic) UILabel *label;

@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;

@property (nonatomic) UIView *streetViewContainer;
@end

@implementation HouseImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth  = [UIScreen mainScreen].bounds.size.width;

    if (![self navigationController]) {
        [self addDismissableNavBar];
    }

    [self layoutNextButton];
    [self layoutMapView];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addDismissableNavBar;
{
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissWasTapped:)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Save Images"];
    item.leftBarButtonItem = backButton;
    [navbar setItems:@[item]];
    
    [self.view addSubview:navbar];
}

- (void)dismissWasTapped:(UIBarButtonItem *)backButton;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)layoutMapView;
{
    UIView *tempMapView = [[UIView alloc] init];
    
    CGFloat mapHeight = _screenHeight - 50 - 8 - 20 - _nextButton.frame.size.height;
    
    tempMapView.frame = CGRectMake(0, 51, _screenWidth, mapHeight);
    tempMapView.backgroundColor = [UIColor darkGrayColor];
    
    _streetViewContainer = [[UIView alloc] init];
    _streetViewContainer.frame = CGRectMake(0, 0, _screenWidth, mapHeight * (7.0/9.0));
    _streetViewContainer.backgroundColor = [UIColor greenColor];

    LBGoogleMapStreetViewController *vc = [[LBGoogleMapStreetViewController alloc] init];
    vc.view.frame = _streetViewContainer.frame;
    
    [_streetViewContainer addSubview:vc.view];
   
    [tempMapView addSubview:_streetViewContainer];
    
    [self layoutScreenShotViews:tempMapView];
    
    [self.view addSubview:tempMapView];
}

- (void)layoutScreenShotViews:(UIView *)mapView;
{
    UIView *leftScreenshot = [[UIView alloc] init];
    UIView *centerScreenshot = [[UIView alloc] init];
    UIView *rightScreenShot = [[UIView alloc] init];
    
    NSInteger i = 0;
    CGFloat subViewWidth = mapView.frame.size.width/3;
    NSArray *colors = @[[UIColor blueColor], [UIColor redColor], [UIColor purpleColor]];
    for (UIView *view in @[leftScreenshot, centerScreenshot, rightScreenShot]) {
        view.frame = CGRectMake(i * subViewWidth, mapView.frame.size.height * (7.0/9.0), subViewWidth, mapView.frame.size.height * (2.0/9.0));
        view.backgroundColor = (UIColor *)colors[i];
        [mapView addSubview:view];
        i++;
    }
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

- (void)nextButtonWasTapped:(UIButton *)button;
{
    
}

- (BOOL)prefersStatusBarHidden;
{
    return YES;
}

@end
