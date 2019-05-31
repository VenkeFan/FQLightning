//
//  UIImage+FQExtension.h
//  FQWidgets
//
//  Created by fan qi on 2018/4/17.
//  Copyright © 2018年 fan qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FQExtension)

+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)fixOrientation;
- (UIImage *)compress;
- (UIImage *)resizeToSize:(CGSize)size;
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius;
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin;

@end
