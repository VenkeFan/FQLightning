//
//  LGMarqueeViewModel.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/30.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMarqueeViewModel.h"
#import "FQTimerManager.h"

@interface LGMarqueeViewModel () {
    NSInteger _flag;
}

@property (nonatomic, strong) FQTimerManager *timerManager;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSPointerArray *listenerArray;

@end

@implementation LGMarqueeViewModel

+ (instancetype)instance {
    static LGMarqueeViewModel *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        _instance->_flag = 0;
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [LGMarqueeViewModel instance];
}

- (void)dealloc {
    _flag = 0;
    [_timerManager shutdown];
}

#pragma mark - Public

- (void)fetchData {
    if (_timerManager) {
        return;
    }
    
    [self.dataArray addObject:@"111111111111111111"];
    [self.dataArray addObject:@"222222222222222222"];
    [self.dataArray addObject:@"333333333333333333"];
    [self.dataArray addObject:@"444444444444444444"];
    [self.dataArray addObject:@"555555555555555555"];
    [self.dataArray addObject:@"666666666666666666"];
    
    if (self.dataArray.count == 0) {
        return;
    }
    
    _timerManager = [[FQTimerManager alloc] initWithTarget:self
                                                  selector:@selector(timerStep)
                                              timeInterval:5.0
                                                  userInfo:nil
                                                   repeats:YES];
    [_timerManager start];
}

- (void)addListener:(id<LGMarqueeViewModelDelegate>)listener {
    [self.listenerArray addPointer:(void *)listener];
}

#pragma mark - Event

- (void)timerStep {    
    NSString *txt = self.dataArray[_flag % self.dataArray.count];
    _flag++;
    
    for (int i = 0; i < self.listenerArray.count; i++) {
        id delegate = [self.listenerArray pointerAtIndex:i];
        if ([delegate respondsToSelector:@selector(marqueeViewModel:displayTxt:)]) {
            [delegate marqueeViewModel:self displayTxt:txt];
        }
    }
}

#pragma mark - Getter

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSPointerArray *)listenerArray {
    if (!_listenerArray) {
        _listenerArray = [NSPointerArray weakObjectsPointerArray];
    }
    return _listenerArray;
}

@end
