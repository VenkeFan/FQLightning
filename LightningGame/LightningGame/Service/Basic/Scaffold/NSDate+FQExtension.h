//
//  NSDate+FQExtension.h
//  FQWidgets
//
//  Created by fanqi on 17/7/12.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FQExtension)

+ (NSDate *)dateWithTimestamp:(NSTimeInterval)timestamp;
+ (NSTimeInterval)currentUnixTimeInterval;
+ (NSDate *)dateFromISO8601String:(NSString *)string;
- (NSString *)ISO8601String;

- (NSInteger)weekday;
- (NSString *)weekdayString;
- (NSInteger)weekdayOrdinal;
- (NSInteger)weekOfMonth;
- (NSInteger)weekOfYear;

@end
