//
//  FQTimeTickManager.h
//  FQWidgets
//
//  Created by fanqi on 2017/9/8.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kFQTimeTickProgressNotificationName;
extern NSString * const kFQTimeTickEndNotificationName;

@interface FQTimeTickManager : NSObject

+ (instancetype)manager;

@property (nonatomic, assign, readonly) NSInteger tickSeconds;
@property (nonatomic, assign) CGFloat interval;

- (void)start;
- (void)reset;
- (void)invalidate;

@end
