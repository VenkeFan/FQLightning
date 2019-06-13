//
//  LGMatchDetailViewModel.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/13.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGMatchListKeys.h"

@class LGMatchDetailViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol LGMatchDetailViewModelDelegate <NSObject>

- (void)matchDetailDidFetch:(LGMatchDetailViewModel *)viewModel
                   matchDic:(NSMutableDictionary *)matchDic
                    oddsDic:(NSMutableDictionary *)oddsDic
                    errCode:(NSInteger)errCode;

@end

@interface LGMatchDetailViewModel : NSObject

@property (nonatomic, weak) id<LGMatchDetailViewModelDelegate> delegate;

- (void)fetchDataWithMatchID:(NSString *)matchID;
+ (NSString *)matchStage:(NSString *)stageKey;

@end

NS_ASSUME_NONNULL_END
