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

@property (nonatomic, readonly) NSInteger year; ///< Year component
@property (nonatomic, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger second; 
- (NSInteger)weekday;
- (NSString *)weekdayString;
- (NSInteger)weekdayOrdinal;
- (NSInteger)weekOfMonth;
- (NSInteger)weekOfYear;

@end
