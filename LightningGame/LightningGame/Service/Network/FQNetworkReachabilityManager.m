//
//  FQNetworkReachabilityManager.m
//  FQWidgets
//
//  Created by fanqi on 17/7/5.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "FQNetworkReachabilityManager.h"
#import "AFNetworkReachabilityManager.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

NSString * const NetworkStatusName[] = {
    [NetworkStatusNone] = @"Other",
    [NetworkStatus2G] = @"WWAN_2G",
    [NetworkStatus3G] = @"WWAN_3G",
    [NetworkStatus4G] = @"WWAN_4G",
    [NetworkStatus5G] = @"WWAN_5G",
    [NetworkStatusWIFI] = @"WiFi"
};

@implementation FQNetworkReachabilityManager

+ (NetworkStatus)getNetworkStatus {
    
    // 保存网络状态
    __block NetworkStatus status = NetworkStatusNone;
    
    if (kiOS8Later) {
        CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
        
        NSString *currentRadioAccessTechnology = telephonyInfo.currentRadioAccessTechnology;
        
        if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge]
            || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
            status = NetworkStatus2G;
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
            status = NetworkStatus4G;
        } else {
            status = NetworkStatus3G;
        }
        
//        [NSNotificationCenter.defaultCenter addObserverForName:CTRadioAccessTechnologyDidChangeNotification
//                                                        object:nil
//                                                         queue:nil
//                                                    usingBlock:^(NSNotification *note) {
//                                                        
//                                                    }];
    } else {
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *subviews;
        if([[application valueForKeyPath:@"statusBar"] isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
            subviews = [[[[application valueForKeyPath:@"statusBar"] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
        } else{
            subviews = [[[application valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
        }
        
        for (id child in subviews) {
            if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                //获取到状态栏码
                int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
                switch (networkType) {
                    case 0:
                        status = NetworkStatusNone;
                        //无网模式
                        break;
                    case 1:
                        status = NetworkStatus2G;
                        break;
                    case 2:
                        status = NetworkStatus3G;
                        break;
                    case 3:
                        status = NetworkStatus4G;
                        break;
                    case 5:
                        status = NetworkStatusWIFI;
                        break;
                }
            }
        }
    }
    
    //根据状态选择
    return status;
}

+ (NSString *)getNetworkStatusName {
    return NetworkStatusName[[self getNetworkStatus]];
}

+ (void)checkNetworkStatus {
    AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
    __block NetworkStatus preStatus;
    
        [reachManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            NetworkStatus currentStatus;
            
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    currentStatus = NetworkStatusNone;
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    currentStatus = NetworkStatusNone;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    currentStatus = NetworkStatusWIFI;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    currentStatus = [self getNetworkStatus];
                    break;
            }
            
//#if DEBUG
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CCSystemHelper appName]
//                                                                           message:[NSString stringWithFormat:@"AFStatus = %zd, NetworkStatus = %zd - %@",
//                                                                                    status,
//                                                                                    currentStatus, NetworkStatusName[currentStatus]]
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//            }]];
//            [[CCSystemHelper currentViewController] presentViewController:alert animated:YES completion:nil];
//#endif
            
            if (currentStatus == preStatus) {
                return;
            }
            
            preStatus = currentStatus;
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:kCCNetworkTypeChangedNotificationName object:@(currentStatus)];
        }];
    
    [reachManager startMonitoring];
}

@end
