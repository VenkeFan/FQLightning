//
//  LGMatchListViewModel.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGMatchListKeys.h"

@class LGMatchListViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol LGMatchListViewModelDelegate <NSObject>

- (void)matchListDidFetch:(LGMatchListViewModel *)viewModel data:(nullable NSArray *)data last:(BOOL)last error:(nullable NSError *)error;

@end

@interface LGMatchListViewModel : NSObject

@property (nonatomic, weak) id<LGMatchListViewModelDelegate> delegate;
@property (nonatomic, assign) LGMatchListType listType;

- (void)fetchData;
- (void)loadMoreData;

@end

NS_ASSUME_NONNULL_END
