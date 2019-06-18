//
//  FQAbstractPlayerView.h
//  FQWidgets
//
//  Created by fan qi on 2018/6/21.
//  Copyright © 2018年 redefine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQPlayerOperateView.h"
#import "FQPlayerConfig.h"

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

@property (class, nonatomic, assign, getter=isMute) BOOL mute;

@property (nonatomic, strong) FQPlayerOperateView *operateView;

@property (nonatomic, assign) FQPlayerViewStatus playerViewStatus;
@property (nonatomic, assign) WLPlayerViewGravity videoGravity;
@property (nonatomic, assign) FQPlayerViewWindowMode windowMode;
@property (nonatomic, assign) FQPlayerViewOrientation playerOrientation;

@property (nonatomic, assign, getter=isLoop) BOOL loop;
@property (nonatomic, assign) CGFloat playProgress;
@property (nonatomic, assign) CGFloat cacheProgress;
@property (nonatomic, assign) CGFloat playSeconds;
@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, weak) id<WLPlayerViewDelegate> delegate;

@end
