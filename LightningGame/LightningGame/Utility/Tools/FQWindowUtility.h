//
//  FQWindowUtility.h
//  FQWidgets
//
//  Created by fan qi on 2019/5/28.
//  Copyright © 2019 fan qi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FQWindowUtility : NSObject

@property (class, nonatomic, strong, readonly) UIViewController *currentViewController;
@property (class, nonatomic, assign, readonly) CGFloat visibleKeyboardHeight;
@property (class, nonatomic, strong, readonly) UIView *visibleKeyboard;
+ (BOOL)changeKeyWindowRootViewController:(UIViewController *)newCtr;
+ (void)resignFirstResponder;

@end

NS_ASSUME_NONNULL_END
