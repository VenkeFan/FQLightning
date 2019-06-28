//
//  FQLanguageManager.h
//  FQWidgets
//
//  Created by fan qi on 2019/5/28.
//  Copyright © 2019 fan qi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kLocalizedString(string)               [[FQLanguageManager manager] getStringForKey:string]

typedef NS_ENUM(NSInteger, FQLanguageType) {
    FQLanguageType_CN,
    FQLanguageType_EN
};

@interface FQLanguageManager : NSObject

+ (instancetype)manager;
- (NSString *)getStringForKey:(NSString *)key;

@property (nonatomic, assign) FQLanguageType userLanguage;
@property (nonatomic, copy) NSString *logogram;

@end

NS_ASSUME_NONNULL_END
