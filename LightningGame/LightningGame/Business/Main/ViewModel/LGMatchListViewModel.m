//
//  LGMatchListViewModel.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchListViewModel.h"
#import "LGMatchListRequest.h"
#import "NSDictionary+FQExtension.h"

#pragma mark - MatchKey

NSString * const kMatchKeyGameID                       = @"game_id";
NSString * const kMatchKeyStatus                       = @"status";
NSString * const kMatchKeyID                           = @"id";
NSString * const kMatchKeyEnableParlay                 = @"enable_parlay";
NSString * const kMatchKeyGameName                     = @"game_name";
NSString * const kMatchKeyMatchName                    = @"match_name";
NSString * const kMatchKeyMatchShortName               = @"match_short_name";
NSString * const kMatchKeyStartTime                    = @"start_time";
NSString * const kMatchKeyEndTime                      = @"end_time";
NSString * const kMatchKeyRound                        = @"round";
NSString * const kMatchKeyTournamentID                 = @"tournament_id";
NSString * const kMatchKeyTournamentName               = @"tournament_name";
NSString * const kMatchKeyTournamentShortName          = @"tournament_short_name";
NSString * const kMatchKeyPlayCount                    = @"play_count";
NSString * const kMatchKeyTeamArray                    = @"team";
NSString * const kMatchKeyOddsArray                    = @"odds";
NSString * const kMatchKeyLiveUrl                      = @"live_url";

#pragma mark - TeamKey

NSString * const kMatchTeamKeyTeamID                   = @"team_id";
NSString * const kMatchTeamKeyLogo                     = @"team_logo";
NSString * const kMatchTeamKeyName                     = @"team_name";
NSString * const kMatchTeamKeyShortName                = @"team_short_name";
NSString * const kMatchTeamKeyScore                    = @"score";
NSString * const kMatchTeamKeyPos                      = @"pos";
NSString * const kMatchTeamKeyID                       = @"id";
NSString * const kMatchTeamKeyMatchID                  = @"match_id";

#pragma mark - ScoreKey

NSString * const kMatchScoreKeyTotal                   = @"total";

#pragma mark - OddsKey

NSString * const kMatchOddsKeyEnableParlay             = @"enable_parlay";
NSString * const kMatchOddsKeyGameID                   = @"game_id";
NSString * const kMatchOddsKeyTournamentID             = @"tournament_id";
NSString * const kMatchOddsKeySortIndex                = @"sort_index";
NSString * const kMatchOddsKeyGroupID                  = @"group_id";
NSString * const kMatchOddsKeyValue                    = @"value";
NSString * const kMatchOddsKeyWin                      = @"win";
NSString * const kMatchOddsKeyStatus                   = @"status";
NSString * const kMatchOddsKeyBetLimit                 = @"bet_limit";
NSString * const kMatchOddsKeyLastUpdate               = @"last_update";
NSString * const kMatchOddsKeyMatchStage               = @"match_stage";
NSString * const kMatchOddsKeyMatchName                = @"match_name";
NSString * const kMatchOddsKeyGroupName                = @"group_name";
NSString * const kMatchOddsKeyGroupShortName           = @"group_short_name";
NSString * const kMatchOddsKeyID                       = @"id";
NSString * const kMatchOddsKeyOddsID                   = @"id";
NSString * const kMatchOddsKeyTeamID                   = @"team_id";
NSString * const kMatchOddsKeyName                     = @"name";
NSString * const kMatchOddsKeyMatchID                  = @"match_id";
NSString * const kMatchOddsKeyOddsValue                = @"odds";
NSString * const kMatchOddsKeyTag                      = @"tag";
NSString * const kMatchOddsExoticKeyIsSelected         = @"isSelected";

#pragma mark - LGMatchListViewModel

@interface LGMatchListViewModel ()

@property (nonatomic, strong) LGMatchListRequest *requset;

@end

@implementation LGMatchListViewModel

- (void)fetchData {
    {
//        TODO("test data");
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"list_sample.json" ofType:nil];
//        if (!filePath) {
//            return;
//        }
//        NSData *data = [NSData dataWithContentsOfFile:filePath];
//        NSMutableDictionary *dic = [[NSDictionary dictionaryWithJSON:data] fq_mutableDictionary];
//        
//        NSArray *array = [dic objectForKey:@"result"];
//        
//        if ([self.delegate respondsToSelector:@selector(matchListDidFetch:data:last:error:)]) {
//            [self.delegate matchListDidFetch:self data:array last:YES error:nil];
//        }
//        return;
    }
    
    LGMatchListRequest *request = [[LGMatchListRequest alloc] initWithType:self.listType];
    [request requestWithSuccess:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray *arrayI = (NSArray *)responseObject;
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:arrayI.count];
        [arrayI enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *dic = [obj fq_mutableDictionary];
            [arrayM addObject:dic];
        }];
        
//        if (self.listType == LGMatchListType_Finished) {
//            [arrayM sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//                return [obj1[kMatchKeyStartTime] compare:obj2[kMatchKeyStartTime]] == NSOrderedDescending;
//            }];
//        } else {
//            [arrayM sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//                return [obj1[kMatchKeyStartTime] compare:obj2[kMatchKeyStartTime]] == NSOrderedAscending;
//            }];
//        }
        
        if ([self.delegate respondsToSelector:@selector(matchListDidFetch:data:last:error:)]) {
            [self.delegate matchListDidFetch:self data:arrayM last:YES error:nil];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(matchListDidFetch:data:last:error:)]) {
            [self.delegate matchListDidFetch:self data:nil last:YES error:error];
        }
    }];
}

- (void)loadMoreData {
    
}

@end
