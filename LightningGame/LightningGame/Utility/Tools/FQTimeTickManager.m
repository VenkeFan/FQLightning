//
//  FQTimeTickManager.m
//  FQWidgets
//
//  Created by fanqi on 2017/9/8.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "FQTimeTickManager.h"

NSString * const kFQTimeTickProgressNotificationName = @"kFQTimeTickProgressNotificationName";
NSString * const kFQTimeTickEndNotificationName = @"kFQTimeTickEndNotificationName";

@interface FQTimeTickManager () {
    dispatch_source_t _timer;
}

@end

@implementation FQTimeTickManager

+ (instancetype)manager {
    static FQTimeTickManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[super allocWithZone:NULL] init];
        _manager.interval = 1.0;
    });
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [FQTimeTickManager manager];
}

- (void)start {
    if (!_timer) {
        _tickSeconds = 0;
        
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, self.interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                self->_tickSeconds++;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kFQTimeTickProgressNotificationName object:@(self->_tickSeconds) userInfo:nil];
            });
        });
        
        dispatch_source_set_cancel_handler(_timer, ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kFQTimeTickEndNotificationName object:@(self->_tickSeconds) userInfo:nil];
            });
        });
        
        dispatch_resume(_timer);
    }
}

- (void)reset {
    _tickSeconds = 0;
}

- (void)invalidate {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

@end
