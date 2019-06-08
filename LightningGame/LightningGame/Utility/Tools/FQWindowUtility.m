//
//  FQWindowUtility.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/28.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "FQWindowUtility.h"

@implementation FQWindowUtility

+ (UIViewController *)currentViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self p_getCurrentCtrFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)p_getCurrentCtrFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        rootVC = (UIViewController *)[rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        currentVC = [self p_getCurrentCtrFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        currentVC = [self p_getCurrentCtrFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        currentVC = (UIViewController *)rootVC;
    }
    
    return (UIViewController *)currentVC;
}

+ (CGFloat)visibleKeyboardHeight {
    // UITextEffectsWindow / UIRemoteKeyboardWindow
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if (![testWindow isMemberOfClass:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    for (UIView *possibleKeyboard in [keyboardWindow subviews]) {
        if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")]
           || [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")]) {
            return CGRectGetHeight(possibleKeyboard.bounds);
        } else if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIInputSetContainerView")]) {
            for (UIView *possibleKeyboardSubview in [possibleKeyboard subviews]) {
                if([possibleKeyboardSubview isKindOfClass:NSClassFromString(@"UIInputSetHostView")]) {
                    return CGRectGetHeight(possibleKeyboardSubview.bounds);
                }
            }
        }
    }
    
    return 0;
}

+ (UIView *)visibleKeyboard {
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator]) {
        keyboardView = [self p_findKeyboardInView:window];
        if (keyboardView) {
            return keyboardView;
        }
    }
    return nil;
}

+ (UIView *)p_findKeyboardInView:(UIView *)view {
    for (UIView *subView in [view subviews]) {
        if (strstr(object_getClassName(subView), "UIInputSetHostView")) {
            return subView;
        } else {
            UIView *tempView = [self p_findKeyboardInView:subView];
            if (tempView) {
                return tempView;
            }
        }
    }
    return nil;
}

+ (BOOL)changeKeyWindowRootViewController:(UIViewController *)newCtr {
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[newCtr class]]) {
        return NO;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    newCtr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *navCtr = [[UINavigationController alloc] initWithRootViewController:newCtr];
    
    [UIView transitionWithView:window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        window.rootViewController = navCtr;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
    
    return YES;
}

+ (void)resignFirstResponder {
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
