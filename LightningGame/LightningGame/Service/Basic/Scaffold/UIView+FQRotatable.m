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

@property (nonatomic, assign, readwrite) UIDeviceOrientation orientation;
@property (nonatomic, assign, readwrite) CGFloat rt_viewWidth;
@property (nonatomic, assign, readwrite) CGFloat rt_viewHeight;

@property (nonatomic, copy) RotatableViewSyncBlock rotatableBlock;

@end

@implementation UIView (FQRotatable)

#pragma mark - Public

- (void)rt_initializeArgument {
    self.rotatable = YES;
    self.orientation = [[UIDevice currentDevice] orientation];
    self.rt_viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.rt_viewHeight = [UIScreen mainScreen].bounds.size.height;
    
    [self addDeviceOrientationNotifications];
}

- (void)rt_clearArgument {
    [self removeDeviceOrientationNotifications];
}

- (void)rt_manualChangeOrientation:(RotatableViewSyncBlock)syncBlock {
    if (!self.rotatable) {
        return;
    }
    
    self.rotatableBlock = syncBlock;
    
    UIDeviceOrientation orientation = UIDeviceOrientationUnknown;
    if (self.orientation != UIDeviceOrientationPortrait) {
        orientation = UIDeviceOrientationPortrait;
    } else {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
            orientation = UIDeviceOrientationLandscapeRight;
        } else {
            orientation = UIDeviceOrientationLandscapeLeft;
        }
    }
    
    [self setOrientation:orientation];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChanged:(NSNotification *)notification {
    if (self.rotatable) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        [self setOrientation:orientation];
    }
}

#pragma mark - Getter & Setter

- (BOOL)rotatable {
    return [objc_getAssociatedObject(self, @selector(rotatable)) boolValue];
}

- (void)setRotatable:(BOOL)rotatable {
    objc_setAssociatedObject(self, @selector(rotatable), @(rotatable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIDeviceOrientation)orientation {
    return (UIDeviceOrientation)[objc_getAssociatedObject(self, @selector(orientation)) integerValue];
}

- (void)setOrientation:(UIDeviceOrientation)orientation {
    objc_setAssociatedObject(self, @selector(orientation), @(orientation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    switch (orientation) {
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
