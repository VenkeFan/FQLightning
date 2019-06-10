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

@property (nonatomic, strong) NSMutableArray<NSDate *> *itemArrayM;

@end

@implementation LGDatePickerViewModel

- (void)generateDateList:(BOOL)isPreviously {
    [self.itemArrayM removeAllObjects];
    
    NSDate *date = [NSDate date];
    [self.itemArrayM addObject:date];
    
    for (int i = 0; i < kDateSelectionRange; i++) {
        NSTimeInterval aTimeInterval = [date timeIntervalSinceReferenceDate] + 86400 * (isPreviously ? -1 : 1);
        NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
        [self.itemArrayM addObject:newDate];
        date = newDate;
    }
    self.currentIndex = 0;
}

- (void)previours {
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

- (NSString *)stringFromDate:(NSDate *)date {
    NSString *str = [date ISO8601String];
    NSString *week = [date weekdayString];
    NSRange range = [str rangeOfString:@"T"];
    str = [str substringToIndex:range.location];
    str = [NSString stringWithFormat:@"%@ %@", str, week];
    
    return str;
}

#pragma mark - Getter

- (BOOL)canPreviously {
    return self.currentIndex > 0;
}

- (BOOL)canFuture {
    return self.currentIndex < self.itemArrayM.count - 1;
}

- (NSMutableArray<NSDate *> *)itemArrayM {
    if (!_itemArrayM) {
        _itemArrayM = [NSMutableArray array];
    }
    return _itemArrayM;
}

- (NSString *)dateStr {
    return [self stringFromDate:self.itemArrayM[self.currentIndex]];
}

- (NSArray<NSDate *> *)itemArray {
    return [self.itemArrayM copy];
}

@end
