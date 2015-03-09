
#import "LBGoogleMapStreetViewController.h"
#import "LBLocationManager.h"
#import <Shimmer/FBShimmeringView.h>

@interface LBGoogleMapStreetViewController ()
@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;
@end

@implementation LBGoogleMapStreetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth  = [UIScreen mainScreen].bounds.size.width;

    if ([LBLocationManager.shared isAuthorized]) {
        CLLocationCoordinate2D panoramaNear = _coordinates;
        GMSPanoramaView *panoView = [GMSPanoramaView panoramaWithFrame:self.view.frame nearCoordinate:panoramaNear];
        self.view = panoView;
    } else {
        self.view.backgroundColor = [UIColor lightGrayColor];

        UILabel *loadingLabel = [[UILabel alloc] init];
        loadingLabel.frame = CGRectMake(8, 8, _screenWidth - 16, 100);
        loadingLabel.text = @"Finding Location…";
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.textColor = [UIColor whiteColor];
        [loadingLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
        
        FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:loadingLabel.frame];
        [self.view addSubview:shimmeringView];
        
        shimmeringView.contentView = loadingLabel;
        shimmeringView.shimmering = YES;
    }
}

- (instancetype)initWithLocationManagerLocation;
{
    if (!(self = [super init])) { return nil; }

    if ([LBLocationManager.shared isAuthorized]) {
        _coordinates = [LBLocationManager.shared currentLocation].coordinate;
    }
    
    return self;
}

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)location;
{
    if (!(self = [super init])) { return nil; }
    
    _coordinates = location;
    
    return self;
}

@end
