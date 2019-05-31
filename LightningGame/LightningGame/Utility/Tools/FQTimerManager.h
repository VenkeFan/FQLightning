//
//  FQTimerManager.h
//  FQWidgets
//
//  Created by fan qi on 2019/3/24.
//  Copyright © 2019 fan qi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FQTimerManager : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;

- (instancetype)initWithTarget:(id)target
                      selector:(SEL)selector
                  timeInterval:(NSTimeInterval)timeInterval
                      userInfo:(id)userInfo
                       repeats:(BOOL)yesOrNo;

- (void)start;
- (void)pause;
- (void)shutdown;

+ (dispatch_source_t)startCountDownWithSeconds:(NSUInteger)seconds
                                     executing:(void(^)(NSUInteger current))executing
                                      finished:(void(^)(void))finished;
+ (dispatch_source_t)startCountDownWithBegin:(NSUInteger)begin
                                         end:(NSUInteger)end
                                   executing:(void(^)(NSUInteger current))executing
                                    finished:(void(^)(void))finished;

@end
