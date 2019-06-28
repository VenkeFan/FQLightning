//
//  FQSystemUtility.h
//  FQWidgets
//
//  Created by fan qi on 2019/5/28.
//  Copyright © 2019 fan qi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FQSystemUtility : NSObject

+ (NSString *)appName;
+ (NSString *)appVersion;
+ (NSString *)deviceName;
+ (NSString *)deviceSystemVersion;
+ (NSString *)UUID;
+ (NSString *)deviceId;
+ (NSInteger)appVersionCode;
+ (NSString *)preferredLanguage;
+ (NSString *)deviceModel;

@end
