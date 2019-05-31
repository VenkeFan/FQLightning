//
//  LGMarqueeViewModel.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/30.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGMarqueeViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol LGMarqueeViewModelDelegate <NSObject>

- (void)marqueeViewModel:(LGMarqueeViewModel *)viewModel displayTxt:(NSString *)displayTxt;

@end

@interface LGMarqueeViewModel : NSObject

+ (instancetype)instance;

- (void)fetchData;
- (void)addListener:(id<LGMarqueeViewModelDelegate>)listener;

@end

NS_ASSUME_NONNULL_END
