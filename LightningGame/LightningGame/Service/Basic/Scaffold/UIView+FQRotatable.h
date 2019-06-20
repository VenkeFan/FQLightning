//
//  UIView+FQRotatable.h
//  FQWidgets
//
//  Created by fan qi on 2018/8/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RotatableViewSyncBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface UIView (FQRotatable)

- (void)rt_initializeArgument:(RotatableViewSyncBlock)block;
- (void)rt_clearArgument;
- (void)rt_manualChangeOrientation;

@property (nonatomic, assign) BOOL rt_autoRotatable;
@property (nonatomic, assign, readonly) UIDeviceOrientation rt_orientation;
@property (nonatomic, assign, readonly) CGFloat rt_viewWidth;
@property (nonatomic, assign, readonly) CGFloat rt_viewHeight;

@end

NS_ASSUME_NONNULL_END
