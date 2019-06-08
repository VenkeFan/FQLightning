//
//  FQNetworkReachabilityManager.h
//  FQWidgets
//
//  Created by fanqi on 17/7/5.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NetworkStatus) {
    NetworkStatusNone,  ///< 没有网络
    NetworkStatus2G,    ///< 2G
    NetworkStatus3G,    ///< 3G
    NetworkStatus4G,    ///< 4G
    NetworkStatus5G,    ///< 5G
    NetworkStatusWIFI   ///< WIFI
};

@interface FQNetworkReachabilityManager : NSObject

+ (NetworkStatus)getNetworkStatus;

+ (NSString *)getNetworkStatusName;

+ (void)checkNetworkStatus;

@end
