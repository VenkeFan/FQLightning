//
//  LGTradeHistoryViewModel.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGTradeHistoryKeys.h"

@class LGTradeHistoryViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol LGTradeHistoryViewModelDelegate <NSObject>

- (void)tradeHistoryDidFetch:(LGTradeHistoryViewModel *)viewModel data:(nullable NSArray *)data last:(BOOL)last isRefresh:(BOOL)isRefresh error:(nullable NSError *)error;

@end

@interface LGTradeHistoryViewModel : NSObject

@property (nonatomic, weak) id<LGTradeHistoryViewModelDelegate> delegate;
@property (nonatomic, assign) LGTradeType tradeType;

- (void)fetchData;
- (void)loadMoreData;

@end

NS_ASSUME_NONNULL_END
