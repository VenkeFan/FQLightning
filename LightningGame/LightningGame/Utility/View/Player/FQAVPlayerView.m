//
//  FQAVPlayerView.m
//  FQWidgets
//
//  Created by fan qi on 2018/4/8.
//  Copyright © 2018年 fan qi. All rights reserved.
//

#import "FQAVPlayerView.h"

NSString * const FQPlayerViewStatusMapping[] = {
    [FQPlayerViewStatus_Unknown]         = @"FQPlayerViewStatus_Unknown",
    [FQPlayerViewStatus_ReadyToPlay]     = @"FQPlayerViewStatus_ReadyToPlay",
    [FQPlayerViewStatus_Playing]         = @"FQPlayerViewStatus_Playing",
    [FQPlayerViewStatus_Paused]          = @"FQPlayerViewStatus_Paused",
    [FQPlayerViewStatus_CachingPaused]   = @"FQPlayerViewStatus_CachingPaused",
    [FQPlayerViewStatus_Stopped]         = @"FQPlayerViewStatus_Stopped",
    [FQPlayerViewStatus_Completed]       = @"FQPlayerViewStatus_Completed",
    [FQPlayerViewStatus_Failed]          = @"FQPlayerViewStatus_Failed"
};

@interface FQAVPlayerView () <FQPlayerOperateViewDelegate> {
    id _timeObserver;
}

@property (nonatomic, weak) CALayer *preImgLayer;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, assign) CGFloat totalDurationSeconds;
@property (nonatomic, assign) CGFloat playBuffer;

@end

@implementation FQAVPlayerView

#pragma mark - LifeCycle

- (instancetype)initWithURLString:(NSString *)urlString {
    if (self = [self init]) {
        _urlString = [urlString copy];
    }
    return self;
}

- (instancetype)initWithAsset:(AVAsset *)asset {
    if (self = [self init]) {
        _asset = asset;
    }
    return self;
}

- (instancetype)init {
    if (self = [self initWithFrame:CGRectZero]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.preImgLayer.contentsGravity = kCAGravityResizeAspectFill;
        
        self.operateView.delegate = self;
        [self bringSubviewToFront:self.operateView];
    }
    return self;
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    self.operateView.frame = self.bounds;
//}

- (void)dealloc {
    [self p_destroyPlayer];
}

#pragma mark - Public

- (void)play {
    if (_player) {
        [_player play];
    } else {
        if (_asset) {
            [self p_playWithAsset:_asset];
        } else if (_urlString.length != 0) {
            [self p_playWithUrlString:_urlString];
        }
    }
}

- (void)pause {
    [_player pause];
}

- (void)stop {
    [self p_resetPlayer];
    
    [self setPlayerViewStatus:FQPlayerViewStatus_Stopped];
}

- (void)seekToPosition:(CGFloat)position {
    
}

#pragma mark - Notification

- (void)addNotifications {
    [self addPlayerItemNotifications];
    
    [_player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [_player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
//    [_player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didPlayTimeJumped:)
                                                 name:AVPlayerItemTimeJumpedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didPlayToEndTime:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFailedToPlayToEndTime:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didPlaybackStalled:)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:nil];
}

- (void)removeNotifications {
    [self removePlayerItemNotifications];
    
    [_player removeObserver:self forKeyPath:@"status"];
    [_player removeObserver:self forKeyPath:@"rate"];
//    [_player removeObserver:self forKeyPath:@"timeControlStatus"];
    
    [_player removeTimeObserver:_timeObserver];
    _timeObserver = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addPlayerItemNotifications {
    [_player.currentItem addObserver:self
                          forKeyPath:@"loadedTimeRanges"
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:nil];
    [_player.currentItem addObserver:self
                          forKeyPath:@"playbackLikelyToKeepUp"
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:nil];
    [_player.currentItem addObserver:self
                          forKeyPath:@"playbackBufferFull"
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:nil];
    [_player.currentItem addObserver:self
                          forKeyPath:@"playbackBufferEmpty"
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:nil];
}

- (void)removePlayerItemNotifications {
    [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [_player.currentItem removeObserver:self forKeyPath:@"playbackBufferFull"];
    [_player.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerStatusUnknown:
                [self setPlayerViewStatus:FQPlayerViewStatus_Unknown];
                break;
            case AVPlayerStatusReadyToPlay:
                [_player play];
                [self setPlayerViewStatus:FQPlayerViewStatus_ReadyToPlay];
                break;
            case AVPlayerStatusFailed:
                [self setPlayerViewStatus:FQPlayerViewStatus_Failed];
                break;
        }
        
    } else if ([keyPath isEqualToString:@"rate"]) {
        if (self.playerViewStatus == FQPlayerViewStatus_Unknown) {
            return;
        }
        
        CGFloat rate = [change[@"new"] floatValue];
        if (rate == 0 && self.playerViewStatus != FQPlayerViewStatus_Stopped && self.playerViewStatus != FQPlayerViewStatus_Completed) {
            [self setPlayerViewStatus:FQPlayerViewStatus_Paused];
        } else {
            [self setPlayerViewStatus:FQPlayerViewStatus_Playing];
        }
        
    } else if ([keyPath isEqualToString:@"timeControlStatus"]) {
//        AVPlayerTimeControlStatus ctrStatus = [change[@"new"] integerValue];
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        if (self.playerViewStatus == FQPlayerViewStatus_Unknown) {
            return;
        }
        
        CMTimeRange timeRange = [playerItem.loadedTimeRanges.firstObject CMTimeRangeValue]; // 本次缓冲时间范围
        CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
        CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds; // 缓冲总长度
        
        NSLog(@"%@", [NSString stringWithFormat:@"caching section: [%f, %f], total caching: %f, playbuffer: %f, totalDurationSeconds: %f", startSeconds, durationSeconds, totalBuffer, self.playBuffer, self.totalDurationSeconds]);
        
        if (!isnan(totalBuffer)) {
            self.operateView.cacheProgress = totalBuffer / self.totalDurationSeconds;
            
            if (self.playerViewStatus != FQPlayerViewStatus_Paused
                && self.playerViewStatus != FQPlayerViewStatus_Stopped
                && self.playerViewStatus != FQPlayerViewStatus_Completed) {
                if (self.playBuffer == 0 || startSeconds == self.playBuffer) {
                    [self setPlayerViewStatus:FQPlayerViewStatus_CachingPaused];
                } else {
                    [self setPlayerViewStatus:FQPlayerViewStatus_Playing];
                }
            }
        } else {
            [self setPlayerViewStatus:FQPlayerViewStatus_CachingPaused];
        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
//        NSLog(@"playbackLikelyToKeepUp: %zd", [change[@"new"] integerValue]);
    } else if ([keyPath isEqualToString:@"playbackBufferFull"]) {
//        NSLog(@"playbackBufferFull: %zd", [change[@"new"] integerValue]);
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
//        NSLog(@"playbackBufferEmpty: %zd", [change[@"new"] integerValue]);
    }
}

- (void)didPlayTimeJumped:(NSNotification *)notification {
//    NSLog(@"didPlayTimeJumped");
}

- (void)didPlayToEndTime:(NSNotification *)notification {
    [self p_playCompleted];
}

- (void)didFailedToPlayToEndTime:(NSNotification *)notification {
//    NSLog(@"didFailedToPlayToEndTime");
//    [self stop];
}

- (void)didPlaybackStalled:(NSNotification *)notification {
//    NSLog(@"didPlaybackStalled");
}

#pragma mark - FQPlayerOperateViewDelegate

- (void)playerOperateViewDidClickedPlay:(FQPlayerOperateView *)operateView {
    if (self.playerViewStatus != FQPlayerViewStatus_Playing) {
        [self play];
    } else {
        [self pause];
    }
}

- (void)playerOperateViewDidClickedRotate:(FQPlayerOperateView *)operateView {
    if ([self.delegate respondsToSelector:@selector(playerViewOrientationDidChanged:)]) {
        [self.delegate playerViewOrientationDidChanged:self];
    }
}

- (void)playerOperateView:(FQPlayerOperateView *)operateView didVolumeChanged:(BOOL)mute {
    [self p_setVolume:mute];
}

- (void)playerOperateView:(FQPlayerOperateView *)operateView didSliderValueChanged:(CGFloat)changedValue {
    [self pause];
    CMTime durationTime = _player.currentItem.duration;
    CGFloat changedSeconds = changedValue * self.totalDurationSeconds;
    CMTime changedTime = CMTimeMake(changedSeconds * durationTime.timescale, durationTime.timescale);
    
    if (_player) {
        [_player seekToTime:changedTime
          completionHandler:^(BOOL finished) {
              if (self.operateView.playProgress != changedValue) {
                  self.operateView.playProgress = changedValue;
              }
              [self play];
          }];
    }
}

- (void)playerOperateView:(FQPlayerOperateView *)operateView didDiaplayToolsChanged:(BOOL)displayTools {
    if ([self.delegate respondsToSelector:@selector(playerView:didDiaplayToolsChanged:)]) {
        [self.delegate playerView:self didDiaplayToolsChanged:displayTools];
    }
}

#pragma mark - Private

- (void)p_setVolume:(BOOL)mute {
    [_player setVolume:mute ? 0.0 : 1.0];
}

- (void)p_playWithUrlString:(NSString *)urlString {
    NSURL *url = nil;
    if ([urlString isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:urlString];
    } else if ([urlString isKindOfClass:[NSURL class]]) {
        url = (NSURL *)urlString;
    }
    
    if (!url) {
        return;
    }
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    [self p_playWithPlayerItem:playerItem];
}

- (void)p_playWithAsset:(AVAsset *)asset {
    if (!asset) {
        return;
    }
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self p_playWithPlayerItem:playerItem];
}

- (void)p_playWithPlayerItem:(AVPlayerItem *)playerItem {
    if (!playerItem) {
        return;
    }
    
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    [(AVPlayerLayer *)self.layer setPlayer:_player];
    [self p_setVolume:[FQPlayerOperateView isMute]];
    
    if (!_timeObserver) {
        __weak typeof(self) weakSelf = self;
        _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1)
                                                              queue:dispatch_get_main_queue()
                                                         usingBlock:^(CMTime time) {
                                                             CGFloat duration = weakSelf.totalDurationSeconds;
                                                             if (!isnan(duration)) {
                                                                 CGFloat seconds = CMTimeGetSeconds(time);
                                                                 
                                                                 weakSelf.playBuffer = seconds;
                                                                 
                                                                 weakSelf.operateView.playSeconds = seconds;
                                                                 weakSelf.operateView.duration = duration;
                                                             }
                                                         }];
        
        [self addNotifications];
    }
}

- (void)p_playCompleted {
    [self p_resetPlayer];
    
    [self setPlayerViewStatus:FQPlayerViewStatus_Completed];
}

// iOS 10.0
//- (void)p_updatePlayerViewStatusWithCtrStatus:(AVPlayerTimeControlStatus)status {
//    switch (status) {
//        case AVPlayerTimeControlStatusPlaying:
//            self.playerViewStatus = FQPlayerViewStatus_Playing;
//            break;
//        case AVPlayerTimeControlStatusPaused:
//            self.playerViewStatus = FQPlayerViewStatus_Paused;
//            break;
//        default:
//            break;
//    }
//}

- (void)p_setPreImageLayerHidden:(BOOL)hidden {
    if (_previewImage) {
        self.preImgLayer.hidden = hidden;
    } else {
        self.preImgLayer.hidden = YES;
    }
}

- (void)p_resetPlayer {
    [_player pause];
    [_player seekToTime:kCMTimeZero];
    
    self.operateView.playSeconds = 0;
    self.operateView.duration = self.totalDurationSeconds;
}

- (void)p_destroyPlayer {
    [self removeNotifications];
    [_player replaceCurrentItemWithPlayerItem:nil];
    _player = nil;
}

#pragma mark - Setter

- (void)setPlayerViewStatus:(FQPlayerViewStatus)playerViewStatus {
    if (playerViewStatus == self.playerViewStatus) {
        return;
    }
    [super setPlayerViewStatus:playerViewStatus];
    
    NSLog(@"%@", [NSString stringWithFormat:@"-------------------->%@", FQPlayerViewStatusMapping[playerViewStatus]]);
    
    [self p_setPreImageLayerHidden:YES];
    
    switch (playerViewStatus) {
        case FQPlayerViewStatus_Unknown:
            [self p_setPreImageLayerHidden:NO];
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
            [self p_setPreImageLayerHidden:NO];
            break;
        case FQPlayerViewStatus_Completed:
            [self p_setPreImageLayerHidden:NO];
            break;
        case FQPlayerViewStatus_Failed:
            [self p_setPreImageLayerHidden:NO];
            break;
    }
}

- (void)setPreviewImage:(UIImage *)previewImage {
    _previewImage = previewImage;
    self.preImgLayer.contents = (__bridge id)previewImage.CGImage;
}

- (void)setVideoGravity:(WLPlayerViewGravity)videoGravity {
    [super setVideoGravity:videoGravity];
    
    switch (videoGravity) {
        case WLPlayerViewGravity_ResizeAspectFill:
            [(AVPlayerLayer *)self.layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            break;
        case WLPlayerViewGravity_ResizeAspect:
            [(AVPlayerLayer *)self.layer setVideoGravity:AVLayerVideoGravityResizeAspect];
            break;
    }
}

- (void)setUrlString:(NSString *)urlString {
    if ([_urlString isEqualToString:urlString]) {
        return;
    }

    _urlString = [urlString copy];
    
    [self p_destroyPlayer];

//    NSURL *url = nil;
//    if ([urlString isKindOfClass:[NSString class]]) {
//        url = [NSURL URLWithString:urlString];
//    } else if ([urlString isKindOfClass:[NSURL class]]) {
//        url = (NSURL *)urlString;
//    }
//
//    [self pause];
//    [self removePlayerItemNotifications];
//
//    if (!url) {
//        [_player replaceCurrentItemWithPlayerItem:nil];
//    } else {
//        [_player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:url]];
//    }
//
//    [self addPlayerItemNotifications];
}

- (void)setAsset:(AVAsset *)asset {
    if (_asset == asset) {
        return;
    }

    _asset = asset;
    
    [self p_destroyPlayer];

//    [self pause];
//    [self removePlayerItemNotifications];
//
//    if (!asset) {
//        [_player replaceCurrentItemWithPlayerItem:nil];
//    } else {
//        [_player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
//    }
//
//    [self addPlayerItemNotifications];
}

#pragma mark - Getter

- (CALayer *)preImgLayer {
    if (!_preImgLayer) {
        CALayer *layer = [CALayer layer];
        layer.frame = self.bounds;
        layer.contentsGravity = kCAGravityResizeAspect;
        self.layer.masksToBounds = YES;
        [self.layer addSublayer:layer];
        _preImgLayer = layer;
    }
    return _preImgLayer;
}

- (CGFloat)totalDurationSeconds {
    _totalDurationSeconds = CMTimeGetSeconds(_player.currentItem.duration);
    return _totalDurationSeconds;
}

@end
