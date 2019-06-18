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

- (void)rt_initializeArgument;
- (void)rt_clearArgument;

- (void)rt_manualChangeOrientation:(RotatableViewSyncBlock)syncBlock;

@property (nonatomic, assign) BOOL rotatable;
@property (nonatomic, assign, readonly) UIDeviceOrientation orientation;
@property (nonatomic, assign, readonly) CGFloat rt_viewWidth;
@property (nonatomic, assign, readonly) CGFloat rt_viewHeight;

@end

NS_ASSUME_NONNULL_END
