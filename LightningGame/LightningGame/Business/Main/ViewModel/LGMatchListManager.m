//
//  LGMatchListManager.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchListManager.h"
#import "LGMatchBeforeRequest.h"
#import "LGMatchTodayRequest.h"
#import "LGMatchRollingRequest.h"
#import "LGMatchFinishedRequest.h"
#import "NSDictionary+FQExtension.h"

#pragma mark - ListKey

NSString * const kMatchListKeyGameID                   = @"game_id";
NSString * const kMatchListKeyStatus                   = @"status";
NSString * const kMatchListKeyID                       = @"id";
NSString * const kMatchListKeyEnableParlay             = @"enable_parlay";
NSString * const kMatchListKeyGameName                 = @"game_name";
NSString * const kMatchListKeyMatchName                = @"match_name";
NSString * const kMatchListKeyMatchShortName           = @"match_short_name";
NSString * const kMatchListKeyStartTime                = @"start_time";
NSString * const kMatchListKeyEndTime                  = @"end_time";
NSString * const kMatchListKeyRound                    = @"round";
NSString * const kMatchListKeyTournamentID             = @"tournament_id";
NSString * const kMatchListKeyTournamentName           = @"tournament_name";
NSString * const kMatchListKeyTournamentShortName      = @"tournament_short_name";
NSString * const kMatchListKeyPlayCount                = @"play_count";
NSString * const kMatchListKeyTeam                     = @"team";
NSString * const kMatchListKeyOdds                     = @"odds";

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

NSString * const kMatchOddsKeyGroupID                  = @"odds_group_id";
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
NSString * const kMatchOddsKeyOddsID                   = @"odds_id";
NSString * const kMatchOddsKeyTeamID                   = @"team_id";
NSString * const kMatchOddsKeyName                     = @"name";
NSString * const kMatchOddsKeyMatchID                  = @"match_id";
NSString * const kMatchOddsKeyOdds                     = @"odds";
NSString * const kMatchOddsKeyTag                      = @"tag";
NSString * const kMatchOddsExoticKeyIsSelected         = @"isSelected";

#pragma mark - LGMatchListManager

@interface LGMatchListManager ()

@property (nonatomic, strong) LGBasicRequest *requset;

@end

@implementation LGMatchListManager

- (void)fetchData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"list_sample.json" ofType:nil];
    if (!filePath) {
        return;
    }
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSMutableDictionary *dic = [[LGMatchListManager dictionaryWithJSON:data] fq_mutableDictionary];
    
    NSArray *array = [dic objectForKey:@"result"];
    
    if ([self.delegate respondsToSelector:@selector(managerDidFetch:data:last:errCode:)]) {
        [self.delegate managerDidFetch:self data:array last:YES errCode:-1];
    }
}

- (void)loadMoreData {
    
}

#pragma mark - Private

+ (NSDictionary *)dictionaryWithJSON:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

#pragma mark - Getter

- (LGBasicRequest *)requset {
    if (!_requset) {
        switch (self.listType) {
            case LGMatchListType_Today:
                _requset = [[LGMatchTodayRequest alloc] init];
                break;
            case LGMatchListType_Before:
                _requset = [[LGMatchBeforeRequest alloc] init];
                break;
            case LGMatchListType_Rolling:
                _requset = [[LGMatchRollingRequest alloc] init];
                break;
            case LGMatchListType_Finished:
                _requset = [[LGMatchFinishedRequest alloc] init];
                break;
        }
    }
    return _requset;
}

@end
