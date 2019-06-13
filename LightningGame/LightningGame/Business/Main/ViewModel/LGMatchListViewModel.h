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

typedef NS_ENUM(NSInteger, LGMatchListType) {
    LGMatchListType_Today,
    LGMatchListType_Rolling,
    LGMatchListType_Before,
    LGMatchListType_Finished
};

NS_ASSUME_NONNULL_BEGIN

@protocol LGMatchListViewModelDelegate <NSObject>

- (void)matchListDidFetch:(LGMatchListViewModel *)viewModel data:(NSArray *)data last:(BOOL)last errCode:(NSInteger)errCode;
- (void)matchListDidMore:(LGMatchListViewModel *)viewModel data:(NSArray *)data last:(BOOL)last errCode:(NSInteger)errCode;

@end

@interface LGMatchListViewModel : NSObject

@property (nonatomic, weak) id<LGMatchListViewModelDelegate> delegate;
@property (nonatomic, assign) LGMatchListType listType;

- (void)fetchData;
- (void)loadMoreData;

@end

NS_ASSUME_NONNULL_END
