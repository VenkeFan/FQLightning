//
//  UIView+FQExtension.h
//  FQWidgets
//
//  Created by fanqi on 2017/8/3.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FQExtension)

#pragma mark - Property

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

#pragma mark - Method

- (UIViewController *)parentController;

- (void)addCorner:(CGFloat)radius
      borderWidth:(CGFloat)borderWidth
      borderColor:(UIColor *)borderColor
  backgroundColor:(UIColor *)backgroundColor;

- (void)removeCorner;

- (void)setHiddenWithAnimation:(BOOL)hidden;

- (void)removeAllSubviews;

@end
