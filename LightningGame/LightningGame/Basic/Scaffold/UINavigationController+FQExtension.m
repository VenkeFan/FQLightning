//
//  UINavigationController+FQExtension.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/27.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "UINavigationController+FQExtension.h"
#import "FQRunTimeUtility.h"

@interface UINavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation UINavigationController (FQExtension)

+ (void)load {
    swizzleInstanceMethod(self, @selector(viewDidLoad), @selector(swizzle_viewDidLoad));
}

- (void)swizzle_viewDidLoad {
    [self swizzle_viewDidLoad];
    
    self.navigationBarHidden = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if (navigationController.viewControllers.count > 1) {
        self.interactivePopGestureRecognizer.enabled = YES;
    } else {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
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
