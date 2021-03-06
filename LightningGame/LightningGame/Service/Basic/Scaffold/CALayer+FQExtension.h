//
//  CALayer+FQExtension.h
//  FQWidgets
//
//  Created by fan qi on 2019/5/29.
//  Copyright © 2019 fan qi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (FQExtension)

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGFloat positionX;
@property (nonatomic, assign) CGFloat positionY;

@end

NS_ASSUME_NONNULL_END
