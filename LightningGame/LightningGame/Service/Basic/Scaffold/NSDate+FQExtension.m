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

+ (NSDate *)dateFromISO8601String:(NSString *)string {
    if (!string) {
        return nil;
    }
    
    struct tm tm;
    time_t t;
    
    strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%Y-%m-%dT%H:%M:%S%z", &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    
    return [NSDate dateWithTimeIntervalSince1970:t + [[NSTimeZone localTimeZone] secondsFromGMT]];
}

- (NSString *)ISO8601StringRaw {
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = [self timeIntervalSince1970] - [[NSTimeZone localTimeZone] secondsFromGMT];
    timeinfo = localtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%dT%H:%M:%S%z", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

- (NSString *)ISO8601StringDateAndTime {
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = [self timeIntervalSince1970] - [[NSTimeZone localTimeZone] secondsFromGMT];
    timeinfo = localtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

- (NSString *)ISO8601StringOnlyDate {
    NSString *str = [self ISO8601StringRaw];
    return [str substringToIndex:[str rangeOfString:@"T"].location];
}

- (NSString *)ISO8601StringOnlyTime {
    NSString *str = [self ISO8601StringRaw];
    return [str substringWithRange:NSMakeRange([str rangeOfString:@"T"].location + 1, 8)];
}

- (NSInteger)year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSString *)weekdayString {
    return [[self weekdayStringArray] objectAtIndex:[self weekday] % [[self weekdayStringArray] count]];
}

- (NSInteger)weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

#pragma mark - Private

- (NSArray *)weekdayStringArray {
    return @[[NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
}

@end
