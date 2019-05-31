//
//  FQWindowUtility.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/28.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FQWindowUtility : NSObject

@property (class, nonatomic, strong, readonly) UIViewController *currentViewController;
@property (class, nonatomic, assign, readonly) CGFloat visibleKeyboardHeight;
+ (BOOL)changeKeyWindowRootViewControllerWithNewClass:(Class)newClass;
+ (void)resignFirstResponder;

@end

NS_ASSUME_NONNULL_END
