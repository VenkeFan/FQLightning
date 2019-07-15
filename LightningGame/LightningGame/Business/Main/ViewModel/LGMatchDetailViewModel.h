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

extern NSString * const KMatchStageFinalKey;

@protocol LGMatchDetailViewModelDelegate <NSObject>

- (void)matchDetailDidFetch:(LGMatchDetailViewModel *)viewModel
                   matchDic:(nullable NSMutableDictionary *)matchDic
                  teamArray:(nullable NSArray *)teamArray
                    oddsDic:(nullable NSMutableDictionary *)oddsDic
                      error:(nullable NSError *)error;;

@end

@interface LGMatchDetailViewModel : NSObject

@property (nonatomic, weak) id<LGMatchDetailViewModelDelegate> delegate;

- (void)fetchDataWithMatchID:(NSNumber *)matchID;
+ (NSString *)matchStage:(NSString *)stageKey;
+ (NSString *)matchStage:(NSString *)stageKey index:(nullable NSInteger *)index;

@end

NS_ASSUME_NONNULL_END
