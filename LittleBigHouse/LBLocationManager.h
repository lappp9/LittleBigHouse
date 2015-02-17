
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

static NSString *kZipCodeWasSetNotification = @"ZipCodeWasSetNotification";
static NSString *kAuthorizationWasGrantedNotification = @"AuthorizationWasGrantedNotification";
static NSString *kAuthorizationWasDeniedNotification = @"AuthorizationWasDeniedNotification";

@interface LBLocationManager : NSObject
@property (nonatomic) NSString *deviceZipCode;
@property (nonatomic) NSString *chosenZipCode;
@property (nonatomic) NSString *deviceCity;
@property (nonatomic) NSString *deviceState;

+ (instancetype)shared;

- (void)startFindingLocation;

- (BOOL)isAuthorized;

- (BOOL)wasDenied;

- (CLLocation *)currentLocation;

@end
