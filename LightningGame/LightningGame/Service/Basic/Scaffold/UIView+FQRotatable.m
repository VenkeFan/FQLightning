//
//  UIView+FQRotatable.m
//  FQWidgets
//
//  Created by fan qi on 2018/8/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "UIView+FQRotatable.h"
#import "FQRunTimeUtility.h"

@interface UIView ()

@property (nonatomic, assign, readwrite) UIDeviceOrientation rt_orientation;
@property (nonatomic, assign, readwrite) CGFloat rt_viewWidth;
@property (nonatomic, assign, readwrite) CGFloat rt_viewHeight;
@property (nonatomic, copy) RotatableViewSyncBlock rotatableBlock;

@end

@implementation UIView (FQRotatable)

#pragma mark - Public

- (void)rt_initializeArgument:(RotatableViewSyncBlock)block {
    self.rt_rotatable = YES;
    self.rotatableBlock = block;
    self.rt_viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.rt_viewHeight = [UIScreen mainScreen].bounds.size.height;
    self.rt_orientation = [[UIDevice currentDevice] orientation];
    
    [self addDeviceOrientationNotifications];
}

- (void)rt_clearArgument {
    [self removeDeviceOrientationNotifications];
}

- (void)rt_manualChangeOrientation {
    if (!self.rt_rotatable) {
        return;
    }
    
    UIDeviceOrientation orientation = UIDeviceOrientationUnknown;
    if (self.rt_orientation != UIDeviceOrientationPortrait) {
        orientation = UIDeviceOrientationPortrait;
    } else {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
            orientation = UIDeviceOrientationLandscapeRight;
        } else {
            orientation = UIDeviceOrientationLandscapeLeft;
        }
    }
    
    [self setRt_orientation:orientation];
}

#pragma mark - DeviceOrientation

- (void)addDeviceOrientationNotifications {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)removeDeviceOrientationNotifications {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)deviceOrientationDidChanged:(NSNotification *)notification {
    if (self.rt_rotatable) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        [self setRt_orientation:orientation];
    }
}

#pragma mark - Getter & Setter

- (BOOL)rt_rotatable {
    return [objc_getAssociatedObject(self, @selector(rt_rotatable)) boolValue];
}

- (void)setRt_rotatable:(BOOL)rt_rotatable {
    objc_setAssociatedObject(self, @selector(rt_rotatable), @(rt_rotatable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIDeviceOrientation)rt_orientation {
    return (UIDeviceOrientation)[objc_getAssociatedObject(self, @selector(rt_orientation)) integerValue];
}

- (void)setRt_orientation:(UIDeviceOrientation)rt_orientation {
    id obj = objc_getAssociatedObject(self, @selector(rt_orientation));
    
    objc_setAssociatedObject(self, @selector(rt_orientation), @(rt_orientation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!obj) {
        return;
    }
    
    switch (rt_orientation) {
        case UIDeviceOrientationPortrait: {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
            
            [UIView animateWithDuration:0.35 animations:^{
                self.transform = CGAffineTransformMakeRotation(0);
                self.bounds = CGRectMake(0, 0, self.rt_viewWidth, self.rt_viewHeight);
                
                if (self.rotatableBlock) {
                    self.rotatableBlock();
                }
            }];
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
            
            [UIView animateWithDuration:0.35 animations:^{
                self.transform = CGAffineTransformMakeRotation(M_PI_2);
                self.bounds = CGRectMake(0, 0, self.rt_viewHeight, self.rt_viewWidth);
                
                if (self.rotatableBlock) {
                    self.rotatableBlock();
                }
            }];
        }
            break;
        case UIDeviceOrientationLandscapeRight: {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
            
            [UIView animateWithDuration:0.35 animations:^{
                self.transform = CGAffineTransformMakeRotation(-M_PI_2);
                self.bounds = CGRectMake(0, 0, self.rt_viewHeight, self.rt_viewWidth);
                
                if (self.rotatableBlock) {
                    self.rotatableBlock();
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)rt_viewWidth {
    return [objc_getAssociatedObject(self, @selector(rt_viewWidth)) floatValue];
}

- (void)setRt_viewWidth:(CGFloat)rt_viewWidth {
    objc_setAssociatedObject(self, @selector(rt_viewWidth), @(rt_viewWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)rt_viewHeight {
    return [objc_getAssociatedObject(self, @selector(rt_viewHeight)) floatValue];
}

- (void)setRt_viewHeight:(CGFloat)rt_viewHeight {
    objc_setAssociatedObject(self, @selector(rt_viewHeight), @(rt_viewHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RotatableViewSyncBlock)rotatableBlock {
    return objc_getAssociatedObject(self, @selector(rotatableBlock));
}

- (void)setRotatableBlock:(RotatableViewSyncBlock)rotatableBlock {
    objc_setAssociatedObject(self, @selector(rotatableBlock), rotatableBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
