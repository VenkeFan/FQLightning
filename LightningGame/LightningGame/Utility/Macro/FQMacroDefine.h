//
//  FQMacroDefine.h
//  FQWidgets
//
//  Created by fanqi on 17/6/27.
//  Copyright © 2017年 fanqi. All rights reserved.
//


#ifndef FQMacroDefine_h
#define FQMacroDefine_h

#pragma mark - 自定义TODO

#define STRINGIFY(S) #S
#define DEFER_STRINGIFY(S) STRINGIFY(S)
#define PRAGMA_MESSAGE(MSG) _Pragma(STRINGIFY(message(MSG)))
#define FORMATTED_MESSAGE(MSG) "[TODO-" DEFER_STRINGIFY(__COUNTER__) "] " MSG " \n" \
DEFER_STRINGIFY(__FILE__) " line " DEFER_STRINGIFY(__LINE__)
#define KEYWORDIFY @try {} @catch (...) {}
// 最终使用下面的宏
#define TODO(MSG) KEYWORDIFY PRAGMA_MESSAGE(FORMATTED_MESSAGE(MSG))

#pragma mark - 自定义NSLog

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t  %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

#pragma mark - Abstract

#define FQAbstractMethodNotImplemented() \
@throw [NSException exceptionWithName:NSInternalInconsistencyException \
reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
userInfo:nil]

#pragma mark - Color

#define kUIColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#define kUIColorFromRGB(rgbValue) (kUIColorFromRGBA(rgbValue, 1.0))

#pragma mark - Font

//#define kFontName                   @"Heiti SC"
//#define kRegularFont(fontSize)      ([UIFont fontWithName:kFontName size:fontSize])

#define kRegularFont(size)   \
({  \
UIFont *font;   \
if (@available(iOS 8.2, *)) {   \
font = [UIFont systemFontOfSize:size weight:UIFontWeightRegular];  \
} else {    \
font = [UIFont systemFontOfSize:size];    \
}   \
font;   \
})

#define kMediumFont(size)   \
({  \
UIFont *font;   \
if (@available(iOS 8.2, *)) {   \
font = [UIFont systemFontOfSize:size weight:UIFontWeightMedium];  \
} else {    \
font = [UIFont systemFontOfSize:size];    \
}   \
font;   \
})

#define kBoldFont(size)   \
({  \
UIFont *font;   \
if (@available(iOS 8.2, *)) {   \
font = [UIFont systemFontOfSize:size weight:UIFontWeightBold];  \
} else {    \
font = [UIFont systemFontOfSize:size];    \
}   \
font;   \
})

#pragma mark - Screen Bound

#define kIsiPhoneX   \
({  \
BOOL isiPhoneX;   \
UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];\
if (@available(iOS 11.0, *)) {\
if (mainWindow.safeAreaInsets.bottom > 0.0) {\
isiPhoneX = YES;\
} \
else\
{\
isiPhoneX = NO; \
}\
} else { \
isiPhoneX = NO; \
} \
isiPhoneX;   \
})

#define kCurrentWindow                      ([UIApplication sharedApplication].keyWindow)
#define kScreenBounds                       ([UIScreen mainScreen].bounds)
#define kScreenWidth                        ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight                       ([UIScreen mainScreen].bounds.size.height)
#define kScreenScale                        ([UIScreen mainScreen].scale)

#define kSystemStatusBarHeight              ([UIApplication sharedApplication].statusBarFrame.size.height)
#define kSingleNavBarHeight                 (44.0)
#define kNavBarHeight                       (kSystemStatusBarHeight + kSingleNavBarHeight)
#define kSafeAreaBottomConstHeight          (34.0)
#define kSingleTabBarHeight                 (48.0)
#define kTabBarHeight                       (kIsiPhoneX ? (kSafeAreaBottomConstHeight + kSingleTabBarHeight) : kSingleTabBarHeight)
#define kSafeAreaBottomY                    (kIsiPhoneX ? kSafeAreaBottomConstHeight : 0)

// 适配
//#define kSizeScale(size)                    ((size) * (kScreenWidth / 375.0))
#define kSizeScale(size)                    (size)

#pragma mark - Custom Method

#define kIsNull(obj) ((NSNull *)obj == [NSNull null] || !obj ? YES : NO)
#define kIsNullOrEmpty(obj) (kIsNull(obj) || (obj.length == 0) ? YES : NO)

#define kResignFirstResponder   [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil]
//#define kResignFirstResponder   [[UIApplication sharedApplication].keyWindow endEditing:YES] // 效果等价

// version
#pragma mark - Version

#define kSystemVersion      ([UIDevice currentDevice].systemVersion.doubleValue)

#ifndef kiOS8Later
#define kiOS8Later  (kSystemVersion >= 8.0)
#endif

#ifndef kiOS9Later
#define kiOS9Later  (kSystemVersion >= 9.0)
#endif

#ifndef kiOS10Later
#define kiOS10Later (kSystemVersion >= 10.0)
#endif

#ifndef kiOS11Later
#define kiOS11Later (kSystemVersion >= 11.0)
#endif

#ifndef kiOS12Later
#define kiOS12Later (kSystemVersion >= 12.0)
#endif

#endif /* FQMacroDefine_h */
