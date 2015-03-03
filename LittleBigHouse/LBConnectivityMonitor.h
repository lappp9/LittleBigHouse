
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <UIKit/UIKit.h>

@interface LBConnectivityMonitor : NSObject

+ (instancetype)shared;

- (BOOL)connected;
- (UILabel *)networkNotAvailableLabel;

@end
