
#import "LBHomeViewController.h"
#import "LBButtonFactory.h"
#import "LBAddressEntryViewController.h"
#import "LBLocationManager.h"
#import "HouseImagesViewController.h"
#import "FXBlurView.h"
#import <AsyncDisplayKit.h>

@interface LBHomeViewController ()
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIButton *addressButton;
@property (strong, nonatomic) UIButton *gpsButton;
@end

@implementation LBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth  = [UIScreen mainScreen].bounds.size.width;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = [UIScreen mainScreen].bounds;
    
    self.navigationController.navigationBarHidden = YES;

    ASImageNode *backgroundImage = [[ASImageNode alloc] init];
    backgroundImage.image = [UIImage imageNamed:@"gingerbread"];
    backgroundImage.frame = self.view.bounds;
    [self.view addSubview:backgroundImage.view];
    
    [self layoutIcon];
    [self layoutInfoButton];
    [self layoutLabel];
    [self layoutOrLabel];
    [self layoutAddressButton];
}

- (void)viewWillAppear:(BOOL)animated;
{
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark Layout

- (void)layoutIcon;
{
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_with_text"]];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.bounds = CGRectMake(0, 0, _screenWidth/3, _screenHeight/4);
    icon.center = CGPointMake(_screenWidth/2, _screenHeight/4);
    [self.view addSubview:icon];
}

- (void)layoutInfoButton;
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    button.bounds = CGRectMake(0, 0, button.imageView.image.size.width, button.imageView.image.size.height);
    button.center = CGPointMake(_screenWidth - 8 - button.frame.size.width, 8 + button.frame.size.height);
    
    [self.view addSubview:button];
}

- (void)layoutLabel;
{
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width/2;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0, 0, buttonWidth, 60);
    button.center = CGPointMake(_screenWidth/2, _screenHeight * (3.0/5.0));
    [button setTitle:@"My Location" forState:UIControlStateNormal];
    [LBButtonFactory clearStyleButton:button];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gpsButtonWasTapped:)];
    [button addGestureRecognizer:tap];
    
    [self.view addSubview:button];
}

- (void)layoutOrLabel;
{
    UILabel *orLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 44)];
    orLabel.center = CGPointMake(_screenWidth/2, _screenHeight * (3.5/5.0));
    orLabel.text = @"Or";
    orLabel.textAlignment = NSTextAlignmentCenter;
    orLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    orLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:orLabel];
}


- (void)layoutAddressButton;
{
    _addressButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _addressButton.bounds = CGRectMake(0, 0, _screenWidth/2, 60);
    _addressButton.center = CGPointMake(_screenWidth/2, _screenHeight * (4.0/5.0));
    [_addressButton setTitle: @"Enter an Address" forState:UIControlStateNormal];
    [LBButtonFactory clearStyleButton:_addressButton];
    
    [_addressButton addTarget:self action:@selector(addressButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_addressButton];
}

#pragma mark Button Tap Events

- (void)gpsButtonWasTapped:(UIButton *)button;
{
    if ([LBLocationManager.shared isAuthorized]) {
        [LBLocationManager.shared startFindingLocation];
        HouseImagesViewController *vc = HouseImagesViewController.new;
        
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    } else if ([LBLocationManager.shared wasDenied]) {
        [[[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                    message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Location Services"
                                    message:@"For us to find your location, please choose \"Allow\" when prompted."
                                   delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK", nil] show];
    }
}

- (void)addressButtonWasTapped:(UIButton *)button;
{
    LBAddressEntryViewController *vc = [[LBAddressEntryViewController alloc] init];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        
    } else if (buttonIndex == 1) {
        [LBLocationManager.shared startFindingLocation];
        LBAddressEntryViewController *vc = [[LBAddressEntryViewController alloc] init];

        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}

- (BOOL)prefersStatusBarHidden;
{
    return YES;
}

@end
