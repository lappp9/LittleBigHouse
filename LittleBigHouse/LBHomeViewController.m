
#import "LBHomeViewController.h"
#import "LBButtonFactory.h"
#import "LBAddressEntryViewController.h"
#import "LBLocationManager.h"
#import "HouseImagesViewController.h"
#import <AsyncDisplayKit.h>

@interface LBHomeViewController ()
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIButton *addressButton;
@property (strong, nonatomic) UIButton *gpsButton;
@end

@implementation LBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = [UIScreen mainScreen].bounds;
    
    [self layoutLabel];
    [self layoutGpsButton];
    [self layoutOrLabel];
    [self layoutAddressButton];
}

#pragma mark Layout

- (void)layoutLabel;
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(16, 44 + 16 + 20, [UIScreen mainScreen].bounds.size.width - 32, 44)];
    _label.text = @"Tap to get your location";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    [self.view addSubview:_label];
}

- (void)layoutGpsButton;
{
    _gpsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _gpsButton.layer.cornerRadius = 4;
    _gpsButton.layer.borderWidth = 1.0;
    _gpsButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _gpsButton.userInteractionEnabled = YES;
    _gpsButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _gpsButton.contentMode = UIViewContentModeScaleAspectFit;
    [_gpsButton setImage:[UIImage imageNamed:@"gps"] forState:UIControlStateNormal];
    _gpsButton.frame = CGRectMake(16, 44 + [UIScreen mainScreen].bounds.size.height/4, _gpsButton.imageView.image.size.width, [UIScreen mainScreen].bounds.size.height/3);
    _gpsButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, _gpsButton.center.y);
    
    [_gpsButton addTarget:self action:@selector(gpsButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_gpsButton];
}

- (void)layoutOrLabel;
{
    CGFloat yOrigin = 44 + [UIScreen mainScreen].bounds.size.height/4 + _gpsButton.frame.size.height + 32;

    UILabel *orLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, yOrigin, [UIScreen mainScreen].bounds.size.width - 32, 44)];
    orLabel.text = @"Or";
    orLabel.textAlignment = NSTextAlignmentCenter;
    orLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    [self.view addSubview:orLabel];
}

- (void)layoutAddressButton;
{
    CGFloat yOrigin = [UIScreen mainScreen].bounds.size.height - 60 - 20;
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width - 32;
    
    _addressButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _addressButton.frame = CGRectMake(16, yOrigin, buttonWidth, 60);
    _addressButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_addressButton setTitle: @"Enter an Address" forState:UIControlStateNormal];
    [LBButtonFactory styleButton:_addressButton];
    
    [_addressButton addTarget:self action:@selector(addressButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_addressButton];
}

#pragma mark Button Tap Events

- (void)gpsButtonWasTapped:(UIButton *)button;
{
    if ([LBLocationManager.shared isAuthorized]) {
        [LBLocationManager.shared startFindingLocation];
        HouseImagesViewController *vc = HouseImagesViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
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
    vc.shouldAutoFillAddress = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        
    } else if (buttonIndex == 1) {
        [LBLocationManager.shared startFindingLocation];
        LBAddressEntryViewController *vc = [[LBAddressEntryViewController alloc] init];
        vc.shouldAutoFillAddress = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
