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
        if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] || [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")]) {
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

+ (BOOL)changeKeyWindowRootViewControllerWithNewClass:(Class)newClass {
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:newClass]) {
        return NO;
    }
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = [newClass new];
    rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [UIView transitionWithView:window
                      duration:0.25f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        window.rootViewController = rootViewController;
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
