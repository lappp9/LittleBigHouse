
#import "LBConnectivityMonitor.h"

@interface LBConnectivityMonitor()

@property (nonatomic) UILabel *networkNotAvailableLabel;

@end

static CGFloat widthOfPhone;
static const CGFloat heightOfLabel = 44;

@implementation LBConnectivityMonitor

+ (instancetype)shared;
{
    static LBConnectivityMonitor *monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        widthOfPhone = UIScreen.mainScreen.bounds.size.width;
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        monitor = LBConnectivityMonitor.new;
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"No Internet Connection");
                    [NSNotificationCenter.defaultCenter postNotificationName:@"noInternetConnection" object:nil];
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [NSNotificationCenter.defaultCenter postNotificationName:@"internetConnection" object:nil];
                    NSLog(@"WIFI");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    [NSNotificationCenter.defaultCenter postNotificationName:@"internetConnection" object:nil];
                    NSLog(@"3G");
                    break;
                default:
                    NSLog(@"Unknown network status");
                    [NSNotificationCenter.defaultCenter postNotificationName:@"noInternetConnection" object:nil];
                    break;
            }
        }];
    });
    return monitor;
}

- (BOOL)connected;
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

- (UILabel *)networkNotAvailableLabel;
{
    _networkNotAvailableLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -heightOfLabel, widthOfPhone, heightOfLabel)];
    _networkNotAvailableLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"warning"]];
    _networkNotAvailableLabel.textAlignment = NSTextAlignmentCenter;
    _networkNotAvailableLabel.textColor = UIColor.whiteColor;
    _networkNotAvailableLabel.adjustsFontSizeToFitWidth = YES;
    _networkNotAvailableLabel.numberOfLines = 2;
    _networkNotAvailableLabel.text = @"The Internet connection appears to be offline.";
    _networkNotAvailableLabel.alpha = 0.0;
    
    return _networkNotAvailableLabel;
}

- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
