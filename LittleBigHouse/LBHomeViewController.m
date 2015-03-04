
#import "LBHomeViewController.h"
#import "LBButtonFactory.h"
#import "LBAddressEntryViewController.h"
#import "LBLocationManager.h"
#import "HouseImagesViewController.h"
#import "FXBlurView.h"
#import <AsyncDisplayKit.h>
#import <pop/POP.h>

@interface LBHomeViewController ()
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;

@property (strong, nonatomic) UIButton *myLocationButton;
@property (strong, nonatomic) UIButton *enterAddressButton;

@property (strong, nonatomic) UIButton *infoButton;
@property (strong, nonatomic) UIButton *infoDismissButton;

@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) UILabel *infoLabel;

@property (strong, nonatomic) UILabel *orLabel;
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
    [self layoutInfoDismissButton];
    
    [self layoutInfoLabels];
    
    [self layoutMyLocationButton];
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
    _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_infoButton setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    _infoButton.bounds = CGRectMake(0, 0, _infoButton.imageView.image.size.width, _infoButton.imageView.image.size.height);
    _infoButton.center = CGPointMake(_screenWidth - 8 - _infoButton.frame.size.width, 8 + _infoButton.frame.size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoButtonWasTapped:)];
    [_infoButton addGestureRecognizer:tap];
    
    [self.view addSubview:_infoButton];
}

- (void)layoutInfoDismissButton;
{
    _infoDismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_infoDismissButton setImage:[UIImage imageNamed:@"info_exit"] forState:UIControlStateNormal];
    _infoDismissButton.bounds = CGRectMake(0, 0, _infoDismissButton.imageView.image.size.width, _infoDismissButton.imageView.image.size.height);
    _infoDismissButton.center = CGPointMake(_screenWidth - 8 - _infoDismissButton.frame.size.width, 8 + _infoDismissButton.frame.size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoDismissButtonWasTapped:)];
    [_infoDismissButton addGestureRecognizer:tap];
    _infoDismissButton.alpha = 0.0;
    
    [self.view addSubview:_infoDismissButton];
}

- (void)layoutInfoLabels;
{
    _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _screenHeight * (1.6/4.0), _screenWidth - 40, 50)];
    _questionLabel.numberOfLines = 2;
    _questionLabel.text = @"Ever wanted a keepsake\n of your old house?";
    _questionLabel.textAlignment = NSTextAlignmentCenter;
    _questionLabel.textColor = [UIColor whiteColor];
    
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_screenWidth/4, _screenHeight * (1.6/4.0), _screenWidth/2, _screenHeight/2.0)];
    _infoLabel.numberOfLines = 9;
    _infoLabel.textColor = [UIColor whiteColor];
    _infoLabel.textAlignment = NSTextAlignmentLeft;
//    _infoLabel.minimumScaleFactor = 

    UIFont *boldFont    = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    UIFont *nonBoldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    
    NSDictionary *regularAttributes = @{ NSFontAttributeName : nonBoldFont };
    NSDictionary *boldAttributes    = @{ NSFontAttributeName : boldFont };
    
    NSMutableAttributedString *final = [[NSMutableAttributedString alloc] initWithString:@"1." attributes:boldAttributes];
    [final appendAttributedString:[[NSAttributedString alloc] initWithString:@"  Select a location\n\n" attributes:regularAttributes]];
    
    NSMutableAttributedString *second = [[NSMutableAttributedString alloc] initWithString:@"2." attributes:boldAttributes];
    [second appendAttributedString:[[NSAttributedString alloc] initWithString:@"  Capture Views\n\n" attributes:regularAttributes]];
    
    NSMutableAttributedString *third = [[NSMutableAttributedString alloc] initWithString:@"3." attributes:boldAttributes];
    [third appendAttributedString:[[NSAttributedString alloc] initWithString:@"  Select a product\n\n" attributes:regularAttributes]];
    
    NSMutableAttributedString *fourth = [[NSMutableAttributedString alloc] initWithString:@"4." attributes:boldAttributes];
    [fourth appendAttributedString:[[NSAttributedString alloc] initWithString:@"  Place an order\n\n" attributes:regularAttributes]];
    
    NSMutableAttributedString *fifth = [[NSMutableAttributedString alloc] initWithString:@"5." attributes:boldAttributes];
    [fifth appendAttributedString:[[NSAttributedString alloc] initWithString:@"  Enjoy sweet nostalgia\n" attributes:regularAttributes]];
    
    [final appendAttributedString:second];
    [final appendAttributedString:third];
    [final appendAttributedString:fourth];
    [final appendAttributedString:fifth];
    
    _infoLabel.attributedText = final;
    
    _questionLabel.alpha = 0.0;
    _infoLabel.alpha = 0.0;
    
    [self.view addSubview:_questionLabel];
    [self.view addSubview:_infoLabel];
}

- (void)layoutMyLocationButton;
{
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width/2;
    
    _myLocationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _myLocationButton.bounds = CGRectMake(0, 0, buttonWidth, 60);
    _myLocationButton.center = CGPointMake(_screenWidth/2, _screenHeight * (3.0/5.0));
    [_myLocationButton setTitle:@"My Location" forState:UIControlStateNormal];
    [LBButtonFactory clearStyleButton:_myLocationButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gpsButtonWasTapped:)];
    [_myLocationButton addGestureRecognizer:tap];
    
    [self.view addSubview:_myLocationButton];
}

- (void)layoutOrLabel;
{
    _orLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 44)];
    _orLabel.center = CGPointMake(_screenWidth/2, _screenHeight * (3.5/5.0));
    _orLabel.text = @"Or";
    _orLabel.textAlignment = NSTextAlignmentCenter;
    _orLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    _orLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_orLabel];
}

- (void)layoutAddressButton;
{
    _enterAddressButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _enterAddressButton.bounds = CGRectMake(0, 0, _screenWidth/2, 60);
    _enterAddressButton.center = CGPointMake(_screenWidth/2, _screenHeight * (4.0/5.0));
    [_enterAddressButton setTitle: @"Enter an Address" forState:UIControlStateNormal];
    [LBButtonFactory clearStyleButton:_enterAddressButton];
    
    [_enterAddressButton addTarget:self action:@selector(addressButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_enterAddressButton];
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

- (void)infoButtonWasTapped:(UITapGestureRecognizer *)tap;
{
    POPBasicAnimation *hideAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    hideAnim.toValue = @(0.0);
    
    POPBasicAnimation *showAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    showAnim.toValue = @(1.0);
    
    [_myLocationButton pop_addAnimation:hideAnim forKey:nil];
    [_enterAddressButton pop_addAnimation:hideAnim forKey:nil];
    [_infoButton pop_addAnimation:hideAnim forKey:nil];
    [_orLabel pop_addAnimation:hideAnim forKey:nil];

    [_infoDismissButton pop_addAnimation:showAnim forKey:nil];
    [_questionLabel pop_addAnimation:showAnim forKey:nil];
    [_infoLabel pop_addAnimation:showAnim forKey:nil];
}

- (void)infoDismissButtonWasTapped:(UITapGestureRecognizer *)tap;
{
    POPBasicAnimation *hideAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    hideAnim.toValue = @(0.0);
    
    POPBasicAnimation *showAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    showAnim.toValue = @(1.0);
    
    [_infoDismissButton pop_addAnimation:hideAnim forKey:nil];
    [_questionLabel pop_addAnimation:hideAnim forKey:nil];
    [_infoLabel pop_addAnimation:hideAnim forKey:nil];
    
    [_myLocationButton pop_addAnimation:showAnim forKey:nil];
    [_enterAddressButton pop_addAnimation:showAnim forKey:nil];
    [_infoButton pop_addAnimation:showAnim forKey:nil];
    [_orLabel pop_addAnimation:showAnim forKey:nil];
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
