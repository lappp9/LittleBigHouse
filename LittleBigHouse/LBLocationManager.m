
#import "LBLocationManager.h"

@interface LBLocationManager()<CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *cllLocationManager;
@end

@implementation LBLocationManager

+ (instancetype)shared
{
    static LBLocationManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super allocWithZone:nil] init];
    });
    return shared;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return self.shared;
}

- (instancetype)init
{
    if (!(self = [super init])) { return nil; }
    
    self.cllLocationManager = CLLocationManager.new;
    self.cllLocationManager.delegate = self;
    self.cllLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    return self;
}

- (void)startFindingLocation;
{
    if ([self.cllLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.cllLocationManager requestWhenInUseAuthorization];
    }
    
    [self.cllLocationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
{
    [self.cllLocationManager stopUpdatingLocation];
    
    [CLGeocoder.new reverseGeocodeLocation:locations.lastObject completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            self.deviceZipCode = ((CLPlacemark *)placemarks.firstObject).postalCode;
            self.deviceCity = ((CLPlacemark *)placemarks.firstObject).locality;
            self.deviceState = ((CLPlacemark *)placemarks.firstObject).administrativeArea;
            [[NSNotificationCenter defaultCenter] postNotificationName:kZipCodeWasSetNotification object:self userInfo:@{@"ZipCode" : self.deviceZipCode,
                                                                                                                         @"City" : self.deviceCity,
                                                                                                                         @"State" : self.deviceState}];
        }
    }];
}

- (CLLocation *)currentLocation;
{
    return self.cllLocationManager.location;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
{
    if (status == 2) {
        NSLog(@"Location status changed to denied");
    } else if (status == 3) {
        NSLog(@"Location status changed to allowed");
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:self.isAuthorized ? kAuthorizationWasGrantedNotification : kAuthorizationWasDeniedNotification object:self];
}

- (CLLocationCoordinate2D)coordinatesFromAddress;
{
//    CLGeocoder *g = [[CLGeocoder alloc] init];
//    [g geocodeAddressDictionary:@{} completionHandler:^(NSArray *placemarks, NSError *error) {
//        //
//    }];
    return CLLocationCoordinate2DMake(0, 0);
}

- (BOOL)isAuthorized;
{
    return !(CLLocationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined ||
             CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied ||
             CLLocationManager.authorizationStatus == kCLAuthorizationStatusRestricted);
}

- (BOOL)wasDenied;
{
    return CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied;
}

@end
