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

@property (nonatomic, copy) NSArray<NSString *> *itemArray;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL canPreviously;
@property (nonatomic, assign) BOOL canFuture;

- (void)previous;
- (void)future;

@end

NS_ASSUME_NONNULL_END
