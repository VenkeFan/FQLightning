//
//  FQPlayerOperateView.m
//  FQWidgets
//
//  Created by fan qi on 2018/4/10.
//  Copyright © 2018年 fan qi. All rights reserved.
//

#import "FQPlayerOperateView.h"
#import "FQAbstractPlayerView.h"

#define kBottomHeight           44
#define kSecondsLabelWidth      35
#define kLabelsViewWidth        74
#define kLabelsViewHeight       30
#define kPaddingX               8
#define kMarginX                12

static BOOL _mute = NO;

@interface FQPlayerOperateView ()

@property (nonatomic, weak) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UIButton *fillBtn;

@end

@implementation FQPlayerOperateView

#pragma mark - LifeCycle

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        _playProgress = 0.0;
        _cacheProgress = 0.0;
        _displayToos = NO;
        _downloading = NO;
        _downloaded = NO;
        _playerOrientation = FQPlayerViewOrientation_Portrait;
        
        [self initializeUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    CGFloat statusBarHeight = kIsiPhoneX ? 44 : 20;
    
    CGFloat padding = kSizeScale(6.0);
    
    self.loadingView.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
    self.fillBtn.center = CGPointMake(CGRectGetWidth(self.bounds) - padding - CGRectGetWidth(self.fillBtn.bounds) * 0.5,
                                      CGRectGetHeight(self.bounds) - padding - CGRectGetHeight(self.fillBtn.bounds) * 0.5);
}

- (void)initializeUI {
    [self addSubview:self.fillBtn];
}

#pragma mark - Public

- (void)prepare {
    [self setCaching:YES];
}

#pragma mark - Events

- (void)fillBtnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(playerOperateViewDidClickedFill:)]) {
        [self.delegate playerOperateViewDidClickedFill:self];
    }
}

#pragma mark - Setter

+ (void)setMute:(BOOL)mute {
    _mute = mute;
}

- (void)setWindowMode:(FQPlayerViewWindowMode)windowMode {
    _windowMode = windowMode;
    
    switch (windowMode) {
        case FQPlayerViewWindowMode_Screen: {
            
        }
            break;
        case FQPlayerViewWindowMode_Widget: {
            
        }
            break;
    }
}

- (void)setPlayerOrientation:(FQPlayerViewOrientation)playerOrientation {
    _playerOrientation = playerOrientation;
    
    if (playerOrientation == FQPlayerViewOrientation_Portrait) {
        
    } else {
        
    }
}

- (void)setPlayerViewStatus:(FQPlayerViewStatus)playerViewStatus {
    if (playerViewStatus == _playerViewStatus) {
        return;
    }
    _playerViewStatus = playerViewStatus;
    
    switch (playerViewStatus) {
        case FQPlayerViewStatus_ReadyToPlay:
        case FQPlayerViewStatus_CachingPaused:
            [self setCaching:YES];
            break;
        default:
            [self setCaching:NO];
            break;
    }
}

- (void)setCaching:(BOOL)caching {
    _caching = caching;
    
    if (caching) {
        [self.loadingView startAnimating];
    } else {
        [self.loadingView stopAnimating];
    }
}

#pragma mark - Getter

+ (BOOL)isMute {
    return _mute;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:view];
        
        _loadingView = view;
    }
    return _loadingView;
}

- (UIButton *)fillBtn {
    if (!_fillBtn) {
        _fillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fillBtn.backgroundColor = [UIColor redColor];
        _fillBtn.frame = CGRectMake(0, 0, kSizeScale(40.0), kSizeScale(40.0));
        [_fillBtn addTarget:self action:@selector(fillBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fillBtn;
}

@end
