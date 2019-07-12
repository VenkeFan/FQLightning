//
//  LGMatchParlayViewModel.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/21.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchParlayViewModel.h"
#import "LGOrderMetaKeys.h"
#import "LGBetRequest.h"

#pragma mark - Order Meta

NSString * const kOrderMetaKeyCode                  = @"code";
NSString * const kOrderMetaKeyOddsID                = @"odds_id";
NSString * const kOrderMetaKeyOddsValue             = @"odds_value";
NSString * const kOrderMetaKeyBetMoney              = @"bet_money";
NSString * const kOrderMetaKeyGainMoney             = @"bet_win_money";
NSString * const kOrderMetaKeyCreatedTimeStamp      = @"bet_created_time";
NSString * const kOrderMetaKeyID                    = @"bet_id";
NSString * const kOrderMetaKeyBetOddsValue          = @"bet_odds";
NSString * const kOrderMetaKeySite                  = @"bet_site";
NSString * const kOrderMetaKeyGameID                = @"game_id";
NSString * const kOrderMetaKeyGameLogo              = @"game_logo";
NSString * const kOrderMetaKeyGameName              = @"game_name";
NSString * const kOrderMetaKeyGroupID               = @"group_id";
NSString * const kOrderMetaKeyGroupName             = @"group_name";
NSString * const kOrderMetaKeyGroupShortName        = @"group_short_name";
NSString * const kOrderMetaKeyMatchID               = @"match_id";
NSString * const kOrderMetaKeyMatchName             = @"match_name";
NSString * const kOrderMetaKeyMatchShortName        = @"match_short_name";
NSString * const kOrderMetaKeyMatchStage            = @"match_stage";
NSString * const kOrderMetaKeyOddsName              = @"odds_name";
NSString * const kOrderMetaKeyOrderNumber           = @"order_num";
NSString * const kOrderMetaKeyOperationStatus       = @"platform_operation_status";
NSString * const kOrderMetaKeyRealGainMoney         = @"real_win_money";
NSString * const kOrderMetaKeyMatchStartTimeStamp   = @"start_time";
NSString * const kOrderMetaKeyOrderStatus           = @"status";
NSString * const kOrderMetaKeyBetResult             = @"win";

@interface LGMatchParlayViewModel ()

@end

@implementation LGMatchParlayViewModel

- (void)parlayWithOddsDic:(NSDictionary *)oddsDic {
    LGBetRequest *request = [LGBetRequest new];
    [request requestWithOddsDic:oddsDic
                        success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                            NSArray *arrayI = (NSArray *)responseObject;
                            NSMutableArray *validateArray = [NSMutableArray array];
                            [arrayI enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if ([obj[kOrderMetaKeyCode] integerValue] == LGErrorCode_Success) {
                                    [validateArray addObject:obj];
                                }
                            }];
                            
                            if ([self.delegate respondsToSelector:@selector(matchParlayViewModel:data:error:)]) {
                                [self.delegate matchParlayViewModel:self data:validateArray error:nil];
                            }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            if ([self.delegate respondsToSelector:@selector(matchParlayViewModel:data:error:)]) {
                                [self.delegate matchParlayViewModel:self data:nil error:error];
                            }
                        }];
}

@end
