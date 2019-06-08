//
//  NSDate+FQExtension.m
//  FQWidgets
//
//  Created by fanqi on 17/7/12.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "NSDate+FQExtension.h"

@implementation NSDate (FQExtension)

+ (NSDate *)dateWithTimestamp:(NSTimeInterval)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
}

+ (NSTimeInterval)currentUnixTimeInterval {
    return [[NSDate date] timeIntervalSince1970] * 1000;
}

@end
