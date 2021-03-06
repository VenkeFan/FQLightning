//
//  FQPlayerOperateView.m
//  FQWidgets
//
//  Created by fan qi on 2018/4/10.
//  Copyright © 2018年 fan qi. All rights reserved.
//

#import "FQPlayerOperateView.h"
#import "FQAbstractPlayerView.h"
#import "FQPlayerConfig.h"

@interface FQPlayerOperateView ()

@property (nonatomic, weak) UIActivityIndicatorView *loadingView;

@property (nonatomic, strong) UIView *btmView;
@property (nonatomic, strong) UIButton *fillBtn;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, assign, getter=isCaching) BOOL caching;

@end

@implementation FQPlayerOperateView

#pragma mark - LifeCycle

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self initializeUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = kSizeScale(4.0);
    
    self.loadingView.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
    
    self.closeBtn.center = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(self.closeBtn.bounds) * 0.5 - padding,
                                       CGRectGetHeight(self.closeBtn.bounds) * 0.5 + padding);
    
    self.btmView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), kSizeScale(28.0));
    self.btmView.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) - CGRectGetHeight(self.btmView.bounds) * 0.5);
    
    self.fillBtn.frame = CGRectMake(0, 0, CGRectGetHeight(self.btmView.bounds), CGRectGetHeight(self.btmView.bounds));
    self.fillBtn.center = CGPointMake(CGRectGetWidth(self.btmView.bounds) - CGRectGetWidth(self.fillBtn.bounds) * 0.5,
                                      CGRectGetHeight(self.btmView.bounds) - CGRectGetHeight(self.fillBtn.bounds) * 0.5);
}

- (void)dealloc {
    NSLog(@"!!!!!!!!!!!! FQPlayerOperateView dealloc");
}

- (void)initializeUI {
    [self addSubview:self.closeBtn];
    
    [self addSubview:self.btmView];
    [self.btmView addSubview:self.fillBtn];
}

#pragma mark - Public

- (void)prepare {
    [self setCaching:YES];
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[FQAbstractPlayerView class]]) {
        if ([keyPath isEqualToString:@"playProgress"]) {
            
        } else if ([keyPath isEqualToString:@"cacheProgress"]) {
            
        } else if ([keyPath isEqualToString:@"playSeconds"]) {
            
        } else if ([keyPath isEqualToString:@"duration"]) {
            
        } else if ([keyPath isEqualToString:@"playerViewStatus"]) {
            FQPlayerViewStatus status = (FQPlayerViewStatus)[change[@"new"] integerValue];
            
            switch (status) {
                case FQPlayerViewStatus_Unknown:
                case FQPlayerViewStatus_ReadyToPlay:
                case FQPlayerViewStatus_CachingPaused:
                    [self setCaching:YES];
                    break;
                default:
                    [self setCaching:NO];
                    break;
            }
        } else if ([keyPath isEqualToString:@"windowMode"]) {
            
        } else if ([keyPath isEqualToString:@"playerOrientation"]) {
            
        }
    }
}

#pragma mark - Events

- (void)fillBtnClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if ([self.delegate respondsToSelector:@selector(playerOperateViewDidClickedFill:)]) {
        [self.delegate playerOperateViewDidClickedFill:self];
    }
}

- (void)closeBtnClicked {
    if ([self.delegate respondsToSelector:@selector(playerOperateViewDidClickedClose:)]) {
        [self.delegate playerOperateViewDidClickedClose:self];
    }
}

#pragma mark - Setter

- (void)setCaching:(BOOL)caching {
    _caching = caching;
    
    if (caching) {
        [self.loadingView startAnimating];
    } else {
        [self.loadingView stopAnimating];
    }
}

#pragma mark - Getter

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:view];
        
        _loadingView = view;
    }
    return _loadingView;
}

- (UIView *)btmView {
    if (!_btmView) {
        _btmView = [UIView new];
        _btmView.backgroundColor = kUIColorFromRGBA(0x000000, 0.5);
    }
    return _btmView;
}

- (UIButton *)fillBtn {
    if (!_fillBtn) {
        _fillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fillBtn setImage:[UIImage imageNamed:@"player_fill"] forState:UIControlStateNormal];
        [_fillBtn setImage:[UIImage imageNamed:@"player_shrink"] forState:UIControlStateSelected];
        [_fillBtn addTarget:self action:@selector(fillBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fillBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = kUIColorFromRGBA(0x000000, 0.5);
        _closeBtn.frame = CGRectMake(0, 0, kSizeScale(20.0), kSizeScale(20.0));
        [_closeBtn setImage:[UIImage imageNamed:@"player_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
