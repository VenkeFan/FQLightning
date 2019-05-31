//
//  FQSystemUtility.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/28.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "FQSystemUtility.h"
#import <sys/sysctl.h>
#import <sys/utsname.h>

#define kApplicationUUIDKey @"ApplicationUUID"

@implementation FQSystemUtility

+ (NSString *)appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

//+ (NSString *)deviceName {
//    return [UIDevice currentDevice].model;
//}

+ (NSString *)deviceName {
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString *model = [self machineModel];
        if (!model) return;
        NSDictionary *dic = @{
                              @"iPod1,1" : @"iPod touch 1G",
                              @"iPod2,1" : @"iPod touch 2G",
                              @"iPod3,1" : @"iPod touch 3G",
                              @"iPod4,1" : @"iPod touch 4G",
                              @"iPod5,1" : @"iPod touch 5G",
                              @"iPod7,1" : @"iPod touch 6G",
                              
                              @"iPhone1,1" : @"iPhone 1G",
                              @"iPhone1,2" : @"iPhone 3G",
                              @"iPhone2,1" : @"iPhone 3GS",
                              @"iPhone3,1" : @"iPhone 4 (GSM)",
                              @"iPhone3,2" : @"iPhone 4 (GSM Rev A)",
                              @"iPhone3,3" : @"iPhone 4 (CDMA)",
                              @"iPhone4,1" : @"iPhone 4S",
                              @"iPhone5,1" : @"iPhone 5 (GSM)",
                              @"iPhone5,2" : @"iPhone 5 (Global)",
                              @"iPhone5,3" : @"iPhone 5c (GSM)",
                              @"iPhone5,4" : @"iPhone 5c (Global)",
                              @"iPhone6,1" : @"iPhone 5s (GSM)",
                              @"iPhone6,2" : @"iPhone 5s (Global)",
                              @"iPhone7,1" : @"iPhone 6 Plus",
                              @"iPhone7,2" : @"iPhone 6",
                              @"iPhone8,1" : @"iPhone 6s",
                              @"iPhone8,2" : @"iPhone 6s Plus",
                              @"iPhone8,4" : @"iPhone SE",
                              @"iPhone9,1" : @"iPhone 7",
                              @"iPhone9,2" : @"iPhone 7 Plus",
                              @"iPhone9,3" : @"iPhone 7",
                              @"iPhone9,4" : @"iPhone 7 Plus",
                              
                              @"iPad1,1" : @"iPad 1G",
                              @"iPad2,1" : @"iPad 2 (WiFi)",
                              @"iPad2,2" : @"iPad 2 (GSM)",
                              @"iPad2,3" : @"iPad 2 (CDMA)",
                              @"iPad2,4" : @"iPad 2 (Rev A)",
                              @"iPad2,5" : @"iPad mini 1G (Wi-Fi)",
                              @"iPad2,6" : @"iPad mini 1G (GSM)",
                              @"iPad2,7" : @"iPad mini 1G (Global)",
                              @"iPad3,1" : @"iPad 3 (Wi-Fi)",
                              @"iPad3,2" : @"iPad 3 (GSM)",
                              @"iPad3,3" : @"iPad 3 (Global)",
                              @"iPad3,4" : @"iPad 4 (Wi-Fi)",
                              @"iPad3,5" : @"iPad 4 (GSM)",
                              @"iPad3,6" : @"iPad 4 (Global)",
                              @"iPad4,1" : @"iPad Air (Wi-Fi)",
                              @"iPad4,2" : @"iPad Air (Cellular)",
                              @"iPad4,3" : @"iPad Air",
                              @"iPad4,4" : @"iPad mini 2G (Wi-Fi)",
                              @"iPad4,5" : @"iPad mini 2G (Cellular)",
                              @"iPad4,6" : @"iPad mini 2G (Cellular)",
                              @"iPad4,7" : @"iPad mini 3G (Wi-Fi)",
                              @"iPad4,8" : @"iPad mini 3G (Cellular)",
                              @"iPad4,9" : @"iPad mini 3G (Cellular)",
                              @"iPad5,1" : @"iPad mini 4G (Wi-Fi)",
                              @"iPad5,2" : @"iPad mini 4G (Cellular)",
                              @"iPad5,3" : @"iPad Air 2 (Wi-Fi)",
                              @"iPad5,4" : @"iPad Air 2 (Cellular)",
                              @"iPad6,3" : @"iPad Pro (9.7 inch) 1G (Wi-Fi)",
                              @"iPad6,4" : @"iPad Pro (9.7 inch) 1G (Cellular)",
                              @"iPad6,7" : @"iPad Pro (12.9 inch) 1G (Wi-Fi)",
                              @"iPad6,8" : @"iPad Pro (12.9 inch) 1G (Cellular)",
                              
                              @"AppleTV1,1" : @"Apple TV 1G",
                              @"AppleTV2,1" : @"Apple TV 2G",
                              @"AppleTV3,1" : @"Apple TV 3G",
                              @"AppleTV3,2" : @"Apple TV 3G",
                              @"AppleTV5,3" : @"Apple TV 4G",
                              
                              @"i386" : @"Simulator x86",
                              @"x86_64" : @"Simulator x64",
                              };
        name = dic[model];
        if (!name) name = model;
    });
    return name;
}

+ (NSString *)machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

+ (NSString *)deviceSystemVersion {
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)UUID {
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

+ (NSString *)deviceId {
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kApplicationUUIDKey];
    if (deviceId == nil || [deviceId length] == 0) {
        deviceId = [FQSystemUtility UUID];
        [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:kApplicationUUIDKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return deviceId;
}

+ (NSInteger)appVersionCode {
    return [[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey] integerValue];
}

+ (NSString *)preferredLanguage {
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    return [languages objectAtIndex:0];
}

+ (NSString *)deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

@end
