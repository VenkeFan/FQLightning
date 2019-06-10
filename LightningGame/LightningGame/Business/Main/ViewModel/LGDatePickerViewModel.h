//
//  LGDatePickerViewModel.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/10.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGDatePickerViewModel : NSObject

@property (nonatomic, copy, readonly) NSString *dateStr;
@property (nonatomic, copy, readonly) NSArray<NSDate *> *itemArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL canPreviously;
@property (nonatomic, assign) BOOL canFuture;

- (void)generateDateList:(BOOL)isPreviously;

- (void)previours;
- (void)future;

- (NSString *)stringFromDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
