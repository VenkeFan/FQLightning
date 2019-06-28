//
//  UINavigationController+FQExtension.m
//  FQWidgets
//
//  Created by fan qi on 2019/5/27.
//  Copyright © 2019 fan qi. All rights reserved.
//

#import "UINavigationController+FQExtension.h"
#import "FQRunTimeUtility.h"
#import "FQAnimatedTransitioning.h"

@interface UINavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation UINavigationController (FQExtension)

+ (void)load {
    swizzleInstanceMethod(self, @selector(viewDidLoad), @selector(fqswizzle_viewDidLoad));
}

- (void)fqswizzle_viewDidLoad {
    [self fqswizzle_viewDidLoad];
    
    self.navigationBarHidden = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if (navigationController.viewControllers.count > 1) {
        if ([NSStringFromClass([navigationController.topViewController class]) isEqualToString:@"LGProfileViewController"]) {
            self.interactivePopGestureRecognizer.enabled = NO;
        } else {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    } else {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if ([NSStringFromClass([fromVC class]) isEqualToString:@"LGProfileViewController"]
        || [NSStringFromClass([toVC class]) isEqualToString:@"LGProfileViewController"]) {
        return [FQAnimatedTransitioning new];
    }

    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return nil;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return [self.viewControllers count] > 1;
    } else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
            [otherGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        }
        
        return YES;
    }
    return NO;
}

@end
