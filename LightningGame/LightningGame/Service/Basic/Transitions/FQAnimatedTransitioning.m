//
//  FQAnimatedTransitioning.m
//  FQWidgets
//
//  Created by fan qi on 2018/4/13.
//  Copyright © 2018年 fan qi. All rights reserved.
//

#import "FQAnimatedTransitioning.h"

@implementation FQAnimatedTransitioning

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromCtr = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toCtr = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView *containerView = transitionContext.containerView;
    
    if ([NSStringFromClass([toCtr class]) isEqualToString:@"LGProfileViewController"]) {
        toCtr.view.transform = CGAffineTransformMakeTranslation(-[UIScreen mainScreen].bounds.size.width, 0);
        [containerView addSubview:toCtr.view];
        
        [UIView animateWithDuration:duration
                         animations:^{
                             toCtr.view.transform = CGAffineTransformMakeTranslation(0, 0);
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    } else if ([NSStringFromClass([fromCtr class]) isEqualToString:@"LGProfileViewController"]) {
        [containerView insertSubview:toCtr.view belowSubview:fromCtr.view];
        
        [UIView animateWithDuration:duration
                         animations:^{
                             fromCtr.view.transform = CGAffineTransformMakeTranslation(-[UIScreen mainScreen].bounds.size.width, 0);
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
}

@end
