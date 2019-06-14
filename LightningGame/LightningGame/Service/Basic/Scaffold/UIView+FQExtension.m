//
//  UIView+FQExtension.m
//  FQWidgets
//
//  Created by fanqi on 2017/8/3.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "UIView+FQExtension.h"

@implementation UIView (FQExtension)

#pragma mark - Property

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

#pragma mark - Method

- (UIViewController *)parentController {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}


- (void)addCorner:(CGFloat)radius
      borderWidth:(CGFloat)borderWidth
      borderColor:(UIColor *)borderColor
  backgroundColor:(UIColor *)backgroundColor {
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    imgView.image = [self drawRectWithRoundedCorner:radius borderWidth:borderWidth borderColor:borderColor backgroundColor:backgroundColor];
    imgView.tag = -999;
    [self insertSubview:imgView atIndex:0];
}

- (void)removeCorner {
    UIView *subView = [self viewWithTag:-999];
    [subView removeFromSuperview];
}

- (UIImage *)drawRectWithRoundedCorner:(CGFloat)radius
                           borderWidth:(CGFloat)borderWidth
                           borderColor:(UIColor *)borderColor
                       backgroundColor:(UIColor *)backgroundColor {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, borderWidth);
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextSetFillColorWithColor(ctx, backgroundColor.CGColor);
    
    CGFloat halfBorderWidth = borderWidth / 2.0;
    CGFloat width = self.bounds.size.width, height = self.bounds.size.height;
    
    CGContextMoveToPoint(ctx, width - halfBorderWidth, radius + halfBorderWidth);  // 开始坐标右边开始
    CGContextAddArcToPoint(ctx, width - halfBorderWidth, height - halfBorderWidth, width - radius - halfBorderWidth, height - halfBorderWidth, radius);  // 右下角角度
    CGContextAddArcToPoint(ctx, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height - radius - halfBorderWidth, radius); // 左下角角度
    CGContextAddArcToPoint(ctx, halfBorderWidth, halfBorderWidth, width - halfBorderWidth, halfBorderWidth, radius); // 左上角
    CGContextAddArcToPoint(ctx, width - halfBorderWidth, halfBorderWidth, width - halfBorderWidth, radius + halfBorderWidth, radius); // 右上角
    
    
    //    CGRect frame = self.bounds;
    //    CGFloat minX = CGRectGetMinX(frame), midX = CGRectGetMidX(frame), maxX = CGRectGetMaxX(frame);
    //    CGFloat minY = CGRectGetMinY(frame), midY = CGRectGetMidY(frame), maxY = CGRectGetMaxY(frame);
    //
    //    CGContextMoveToPoint(ctx, minX, midY);
    //    CGContextAddArcToPoint(ctx, minX, minY, midX, minY, radius);
    //    CGContextAddArcToPoint(ctx, maxX, minY, maxX, midY, radius);
    //    CGContextAddArcToPoint(ctx, maxX, maxY, midX, maxY, radius);
    //    CGContextAddArcToPoint(ctx, minX, maxY, minX, midY, radius);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setHiddenWithAnimation:(BOOL)hidden {
    [self.layer removeAnimationForKey:@"transition"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.type = kCATransitionFade;
    [self.layer addAnimation:transition forKey:@"transition"];
    self.hidden = hidden;
}

- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
