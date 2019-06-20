//
//  FQAbstractPlayerView.m
//  FQWidgets
//
//  Created by fan qi on 2018/6/21.
//  Copyright © 2018年 redefine. All rights reserved.
//

#import "FQAbstractPlayerView.h"
#import "FQNetworkReachabilityManager.h"
#import "UIView+FQRotatable.h"

static BOOL _mute = NO;

@interface FQAbstractPlayerView () <FQPlayerOperateViewDelegate> {
    __weak UIView *_previousSuperView;
    CGRect _originalFrame;
}

@end

@implementation FQAbstractPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _loop = NO;
        _playProgress = 0.0;
        _cacheProgress = 0.0;
        
        [self rt_initializeArgument];
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self setVideoGravity:WLPlayerViewGravity_ResizeAspectFill];
        [self setWindowMode:FQPlayerViewWindowMode_Widget];
        [self setPlayerOrientation:FQPlayerViewOrientation_Portrait];
        
        [self initializeUI];
        [self addPlayerObservers];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.operateView.frame = self.bounds;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview && !_previousSuperView) {
        _previousSuperView = newSuperview;
    }
}

- (void)dealloc {
    [self removeAllObservers];
    
    [self rt_clearArgument];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)initializeUI {
    [self addSubview:self.operateView];
    [self.operateView prepare];
}

#pragma mark - Observer

- (void)addPlayerObservers {
    void (^addObserverBlock)(id, id, NSString *) = ^(id obj, id observer, NSString *keyPath) {
        [obj addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    };
    
    addObserverBlock(self, self.operateView, @"playProgress");
    addObserverBlock(self, self.operateView, @"cacheProgress");
    addObserverBlock(self, self.operateView, @"playSeconds");
    addObserverBlock(self, self.operateView, @"duration");
    addObserverBlock(self, self.operateView, @"playerViewStatus");
    addObserverBlock(self, self.operateView, @"windowMode");
    addObserverBlock(self, self.operateView, @"playerOrientation");
}

- (void)removeAllObservers {
    void (^removeObserverBlock)(id, id, NSString *) = ^(id obj, id observer, NSString *keyPath) {
        [obj removeObserver:observer forKeyPath:keyPath];
    };
    
    removeObserverBlock(self, self.operateView, @"playProgress");
    removeObserverBlock(self, self.operateView, @"cacheProgress");
    removeObserverBlock(self, self.operateView, @"playSeconds");
    removeObserverBlock(self, self.operateView, @"duration");
    removeObserverBlock(self, self.operateView, @"playerViewStatus");
    removeObserverBlock(self, self.operateView, @"windowMode");
    removeObserverBlock(self, self.operateView, @"playerOrientation");
}

#pragma mark - FQPlayerOperateViewDelegate

- (void)playerOperateViewDidClickedFill:(FQPlayerOperateView *)operateView {
    if (self.windowMode == FQPlayerViewWindowMode_Widget) {
        _originalFrame = self.frame;
        [self p_playerFillScreen];
    } else {
        [self p_playerShrink];
    }
    [self p_changeOrientation];
}

- (void)playerOperateViewDidClickedClose:(FQPlayerOperateView *)operateView {
    [self p_changeOrientation];
    [self p_playerShrink];
    [self stop];
}

#pragma mark - Private

- (void)p_playerFillScreen {
    [self setWindowMode:FQPlayerViewWindowMode_Screen];
    
    CGRect frame = [self convertRect:self.bounds
                              toView:kCurrentWindow];
//    UIView *tmpView = [[UIView alloc] initWithFrame:frame];
//    tmpView.backgroundColor = [UIColor redColor];
//    [kCurrentWindow addSubview:tmpView];
    
    self.frame = frame;
    [kCurrentWindow addSubview:self];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.frame = kScreenBounds;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)p_playerShrink {
    [self setWindowMode:FQPlayerViewWindowMode_Widget];
    
    CGRect frame = [_previousSuperView convertRect:_originalFrame
                                            toView:kCurrentWindow];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         self.frame = self->_originalFrame;
                         [self->_previousSuperView addSubview:self];
                     }];
}

- (void)p_changeOrientation {
    __weak typeof(self) weakSelf = self;
    [self rt_manualChangeOrientation:^{
        __strong typeof(weakSelf) strSelf = weakSelf;
        switch (strSelf.orientation) {
            case UIDeviceOrientationPortrait: {
                [strSelf setVideoGravity:WLPlayerViewGravity_ResizeAspectFill];
                [strSelf setPlayerOrientation:FQPlayerViewOrientation_Portrait];
            }
                break;
            case UIDeviceOrientationLandscapeLeft: {
                [strSelf setVideoGravity:WLPlayerViewGravity_ResizeAspect];
                [strSelf setPlayerOrientation:FQPlayerViewOrientation_Landscape];
            }
                break;
            case UIDeviceOrientationLandscapeRight: {
                [strSelf setVideoGravity:WLPlayerViewGravity_ResizeAspect];
                [strSelf setPlayerOrientation:FQPlayerViewOrientation_Landscape];
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - Setter

+ (void)setMute:(BOOL)mute {
    _mute = mute;
}

- (void)setWindowMode:(FQPlayerViewWindowMode)windowMode {
    _windowMode = windowMode;
    
    switch (windowMode) {
        case FQPlayerViewWindowMode_Screen: {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        }
            break;
        case FQPlayerViewWindowMode_Widget: {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        }
            break;
    }
}

- (void)setPlayerOrientation:(FQPlayerViewOrientation)playerOrientation {
    if (_playerOrientation == playerOrientation) {
        return;
    }
    
    _playerOrientation = playerOrientation;
    
    if ([self.delegate respondsToSelector:@selector(playerViewOrientationDidChanged:)]) {
        [self.delegate playerViewOrientationDidChanged:self];
    }
}

- (void)setPlayerViewStatus:(FQPlayerViewStatus)playerViewStatus {
    _playerViewStatus = playerViewStatus;
    
    switch (playerViewStatus) {
        case FQPlayerViewStatus_Unknown:
            
            break;
        case FQPlayerViewStatus_ReadyToPlay:
            
            break;
        case FQPlayerViewStatus_Playing:
            
            break;
        case FQPlayerViewStatus_Paused:
            
            break;
        case FQPlayerViewStatus_CachingPaused:
            
            break;
        case FQPlayerViewStatus_Stopped:
            
            break;
        case FQPlayerViewStatus_Completed: {
            if (self.isLoop) {
                [self play];
            }
        }
            break;
        case FQPlayerViewStatus_Failed:
            
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(playerView:statusDidChanged:)]) {
        [self.delegate playerView:self statusDidChanged:playerViewStatus];
    }
}

- (void)setPlaySeconds:(CGFloat)playSeconds {
    _playSeconds = playSeconds;
    
    if (_duration > 0) {
        [self setPlayProgress:_playSeconds / _duration];
    }
}

- (void)setDuration:(CGFloat)duration {
    _duration = duration;
    
    if (_duration > 0) {
        [self setPlayProgress:_playSeconds / _duration];
    }
}

- (void)setPlayProgress:(CGFloat)playProgress {
    _playProgress = playProgress;
}

- (void)setCacheProgress:(CGFloat)cacheProgress {
    _cacheProgress = cacheProgress;
}

#pragma mark - Getter

+ (BOOL)isMute {
    return _mute;
}

- (FQPlayerOperateView *)operateView {
    if (!_operateView) {
        FQPlayerOperateView *view = [[FQPlayerOperateView alloc] init];
        view.delegate = self;
        _operateView = view;
    }
    return _operateView;
}

@end
