//
//  NSDate+FQExtension.h
//  FQWidgets
//
//  Created by fanqi on 17/7/12.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FQExtension)

/**
 13位时间戳转UTC时间
 */
+ (NSDate *)dateWithTimestamp:(NSTimeInterval)timestamp;

/**
 当前13位时间戳
 */
+ (NSTimeInterval)currentUnixTimeInterval;

@end
