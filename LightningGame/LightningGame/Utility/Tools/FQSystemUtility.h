//
//  FQSystemUtility.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/28.
//  Copyright © 2019 fanqi_company. All rights reserved.
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
