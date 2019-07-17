//
//  LGDatePickerViewModel.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/10.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGDatePickerViewModel.h"
#import "NSDate+FQExtension.h"

const NSUInteger kDateSelectionRange = 7;

@interface LGDatePickerViewModel ()

@property (nonatomic, strong) NSMutableArray<NSString *> *itemArrayM;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation LGDatePickerViewModel

//- (void)generateDateList:(BOOL)isPreviously {
//    [self.itemArrayM removeAllObjects];
//    
//    NSDate *date = [NSDate date];
//    [self.itemArrayM addObject:date];
//    
//    for (int i = 0; i < kDateSelectionRange; i++) {
//        NSTimeInterval aTimeInterval = [date timeIntervalSinceReferenceDate] + 86400 * (isPreviously ? -1 : 1);
//        NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
//        [self.itemArrayM addObject:newDate];
//        date = newDate;
//    }
//    self.currentIndex = 0;
//}

- (void)previous {
    if (!self.canPreviously) {
        return;
    }
    self.currentIndex--;
}

- (void)future {
    if (!self.canFuture) {
        return;
    }
    
    self.currentIndex++;
}

- (void)setItemArray:(NSArray<NSString *> *)itemArray {
    [self.itemArrayM removeAllObjects];
    
    [itemArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.formatter dateFromString:obj];
        date = [date dateInBeijingLocale];
        
        [self.itemArrayM addObject:[self stringFromDate:date]];
    }];
    
    self.currentIndex = 0;
}

- (NSArray<NSString *> *)itemArray {
    return [self.itemArrayM copy];
}

- (BOOL)canPreviously {
    return self.currentIndex > 0;
}

- (BOOL)canFuture {
    return self.currentIndex < self.itemArrayM.count - 1;
}

#pragma mark - Private

- (NSString *)stringFromDate:(NSDate *)date {
    NSString *str = [date ISO8601StringRaw];
    NSString *week = [date weekdayString];
    NSRange range = [str rangeOfString:@"T"];
    str = [str substringToIndex:range.location];
    str = [NSString stringWithFormat:@"%@ %@", str, week];
    
    return str;
}

#pragma mark - Getter

- (NSMutableArray<NSString *> *)itemArrayM {
    if (!_itemArrayM) {
        _itemArrayM = [NSMutableArray array];
    }
    return _itemArrayM;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        _formatter.timeZone = [NSTimeZone localTimeZone];
        _formatter.locale = [NSLocale currentLocale];
    }
    return _formatter;
}

@end
