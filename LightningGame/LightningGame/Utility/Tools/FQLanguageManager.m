//
//  FQLanguageManager.m
//  FQWidgets
//
//  Created by fan qi on 2019/5/28.
//  Copyright © 2019 fan qi. All rights reserved.
//

#import "FQLanguageManager.h"

#define kUserLanguage @"UserLanguage"

NSString * const FQLanguageTypeMapping[] = {
    [FQLanguageType_CN] = @"zh-Hans",
    [FQLanguageType_EN] = @"en"
};

@implementation FQLanguageManager

+ (instancetype)manager {
    static FQLanguageManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [FQLanguageManager manager];
}

- (void)setUserLanguage:(FQLanguageType)languageType {
    [[NSUserDefaults standardUserDefaults] setObject:FQLanguageTypeMapping[languageType] forKey:kUserLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (FQLanguageType)userLanguage {
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLanguage];
    
    if (kIsNullOrEmpty(language)) {
        NSArray *appleLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        if ([appleLang.firstObject containsString:FQLanguageTypeMapping[FQLanguageType_CN]]) {
            language = FQLanguageTypeMapping[FQLanguageType_CN];
        } else {
            language = FQLanguageTypeMapping[FQLanguageType_EN];
        }
    }
    
    if ([FQLanguageTypeMapping[FQLanguageType_EN] isEqualToString:language]) {
        return FQLanguageType_EN;
    } else {
        return FQLanguageType_CN;
    }
}

- (NSString *)logogram {
    NSString *str = @"";
    
    switch (self.userLanguage) {
        case FQLanguageType_CN:
            str = @"cn";
            break;
        case FQLanguageType_EN:
            str  = @"en";
            break;
    }
    
    return str;
}

- (NSString *)getStringForKey:(NSString *)key {
    NSString *str = @"";
    
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLanguage];
    if (kIsNullOrEmpty(language)) {
        str = NSLocalizedString(key, nil);
    } else {
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]];
        str = NSLocalizedStringFromTableInBundle(key, nil, bundle, nil);
    }
    
    return str;
}

@end
