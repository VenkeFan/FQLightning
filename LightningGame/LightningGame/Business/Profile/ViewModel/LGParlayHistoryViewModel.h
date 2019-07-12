//
//  LGParlayHistoryViewModel.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/12.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGOrderMetaKeys.h"

@class LGParlayHistoryViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol LGParlayHistoryViewModelDelegate <NSObject>

- (void)parlayHistoryDidFetch:(LGParlayHistoryViewModel *)viewModel data:(nullable NSArray *)data last:(BOOL)last isRefresh:(BOOL)isRefresh error:(nullable NSError *)error;

@end

@interface LGParlayHistoryViewModel : NSObject

@property (nonatomic, weak) id<LGParlayHistoryViewModelDelegate> delegate;
@property (nonatomic, assign) LGOrderStatus orderStatus;

- (void)fetchData;
- (void)loadMoreData;

@end

NS_ASSUME_NONNULL_END
