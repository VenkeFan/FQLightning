//
//  FQAbstractPlayerView.h
//  FQWidgets
//
//  Created by fan qi on 2018/6/21.
//  Copyright © 2018年 redefine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQPlayerOperateView.h"

typedef NS_ENUM(NSInteger, WLPlayerViewGravity) {
    WLPlayerViewGravity_ResizeAspectFill,
    WLPlayerViewGravity_ResizeAspect
};

@protocol WLBasicPlayerProtocol <NSObject>

@optional
- (void)play;
- (void)pause;
- (void)stop;
- (void)seekToPosition:(CGFloat)position;

@end

@class FQAbstractPlayerView;

@protocol WLPlayerViewDelegate <NSObject>

@optional
- (void)playerView:(FQAbstractPlayerView *)playerView statusDidChanged:(FQPlayerViewStatus)status;
- (void)playerViewOrientationDidChanged:(FQAbstractPlayerView *)playerView;
- (void)playerView:(FQAbstractPlayerView *)playerView didDiaplayToolsChanged:(BOOL)displayTools;

@end

@interface FQAbstractPlayerView : UIView <WLBasicPlayerProtocol>

@property (nonatomic, strong) FQPlayerOperateView *operateView;

@property (nonatomic, assign) FQPlayerViewStatus playerViewStatus;
@property (nonatomic, assign) WLPlayerViewGravity videoGravity;
@property (nonatomic, assign) FQPlayerViewWindowMode windowMode;
@property (nonatomic, assign) FQPlayerViewOrientation playerOrientation;

@property (nonatomic, assign, readonly) CGFloat position;
@property (nonatomic, assign, getter=isLoop) BOOL loop;

@property (nonatomic, weak) id<WLPlayerViewDelegate> delegate;

@end
