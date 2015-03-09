
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>


@interface LBGoogleMapStreetViewController : UIViewController
- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)location;
- (instancetype)initWithLocationManagerLocation;
@end
