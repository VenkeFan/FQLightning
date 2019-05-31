//
//  FQTimerManager.m
//  FQWidgets
//
//  Created by fan qi on 2019/3/24.
//  Copyright © 2019 fan qi. All rights reserved.
//

#import "FQTimerManager.h"

@interface FQTimerManager ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation FQTimerManager

- (instancetype)initWithTarget:(id)target
                      selector:(SEL)selector
                  timeInterval:(NSTimeInterval)timeInterval
                      userInfo:(id)userInfo
                       repeats:(BOOL)yesOrNo {
    if (self = [super init]) {
        _target = target;
        _selector = selector;
        
        _timer = [NSTimer timerWithTimeInterval:timeInterval
                                         target:self
                                       selector:@selector(timerStep:)
                                       userInfo:userInfo
                                        repeats:yesOrNo];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Public

- (void)start {
    [_timer setFireDate:[NSDate date]];
}

- (void)pause {
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)shutdown {
    [_timer invalidate];
    _timer = nil;
}

+ (dispatch_source_t)startCountDownWithSeconds:(NSUInteger)seconds
                                     executing:(void(^)(NSUInteger current))executing
                                      finished:(void(^)(void))finished {
    return [self startCountDownWithBegin:seconds end:0 executing:executing finished:finished];
}

+ (dispatch_source_t)startCountDownWithBegin:(NSUInteger)begin
                                         end:(NSUInteger)end
                                   executing:(void(^)(NSUInteger current))executing
                                    finished:(void(^)(void))finished {
    BOOL isAscend = begin < end ? YES : NO;
    
    __block NSUInteger duration = begin;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (duration == end) {
            dispatch_source_cancel(timer);
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (executing) {
                    executing(duration);
                }
            });
            
            isAscend ? duration ++ : duration--;
        }
    });
    
    dispatch_source_set_cancel_handler(timer, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (finished) {
                finished();
            }
        });
    });
    
    dispatch_resume(timer);
    
    return timer;
}

#pragma mark - Private

- (void)timerStep:(NSTimer *)timer {
    
    if (_target && [_target respondsToSelector:_selector]) {
        IMP imp = [_target methodForSelector:_selector];
        void (*fun)(id, SEL) = (void *)imp;
        fun(_target, _selector);
    }
}

@end
