//
//  FQPlayerOperateView.h
//  FQWidgets
//
//  Created by fan qi on 2018/4/10.
//  Copyright © 2018年 fan qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FQAbstractPlayerView;

typedef NS_ENUM(NSInteger, FQPlayerViewStatus) {
    FQPlayerViewStatus_Unknown,
    FQPlayerViewStatus_ReadyToPlay,
    FQPlayerViewStatus_Playing,
    FQPlayerViewStatus_Paused,
    FQPlayerViewStatus_CachingPaused,
    FQPlayerViewStatus_Stopped,
    FQPlayerViewStatus_Completed,
    FQPlayerViewStatus_Failed
};

typedef NS_ENUM(NSInteger, FQPlayerViewWindowMode) {
    FQPlayerViewWindowMode_Screen,
    FQPlayerViewWindowMode_Widget
};

typedef NS_ENUM(NSInteger, FQPlayerViewType) {
    FQPlayerViewType_Stream,
    FQPlayerViewType_YouTube,
    FQPlayerViewType_Local
};

typedef NS_ENUM(NSInteger, FQPlayerViewOrientation) {
    FQPlayerViewOrientation_Portrait,
    FQPlayerViewOrientation_Landscape
};

@class FQPlayerOperateView;

@protocol FQPlayerOperateViewDelegate <NSObject>

@optional
- (void)playerOperateViewDidClickedFill:(FQPlayerOperateView *)operateView;

@end

@interface FQPlayerOperateView : UIView

@property (class, nonatomic, assign, getter=isMute) BOOL mute;

@property (nonatomic, weak) FQAbstractPlayerView *playerView;

@property (nonatomic, assign) CGFloat playProgress;
@property (nonatomic, assign) CGFloat cacheProgress;
@property (nonatomic, assign) CGFloat playSeconds;
@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, assign, getter=isCaching) BOOL caching;
@property (nonatomic, assign) FQPlayerViewStatus playerViewStatus;
@property (nonatomic, weak) id<FQPlayerOperateViewDelegate> delegate;

@property (nonatomic, assign) FQPlayerViewWindowMode windowMode;
@property (nonatomic, assign) FQPlayerViewType playerViewType;
@property (nonatomic, assign) FQPlayerViewOrientation playerOrientation;

@property (nonatomic, assign, readonly, getter=isDisplayTools) BOOL displayToos;

@property (nonatomic, strong, readonly) CAShapeLayer *downloadProgressLayer;
@property (nonatomic, assign) BOOL downloading;
@property (nonatomic, assign) BOOL downloaded;

- (void)prepare;

@end
