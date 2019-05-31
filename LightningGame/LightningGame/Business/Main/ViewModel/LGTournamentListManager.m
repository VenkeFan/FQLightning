//
//  LGTournamentListManager.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGTournamentListManager.h"
#import "LGTournamentBeforeRequest.h"
#import "LGTournamentTodayRequest.h"
#import "LGTournamentRollingRequest.h"
#import "LGTournamentFinishedRequest.h"

#pragma mark - ListKey

NSString * const kTournamentListKeyGameID                   = @"game_id";
NSString * const kTournamentListKeyTournamentID             = @"tournament_id";
NSString * const kTournamentListKeyStatus                   = @"status";
NSString * const kTournamentListKeyID                       = @"id";
NSString * const kTournamentListKeyEnableParlay             = @"enable_parlay";
NSString * const kTournamentListKeyGameName                 = @"game_name";
NSString * const kTournamentListKeyMatchName                = @"match_name";
NSString * const kTournamentListKeyMatchShortName           = @"match_short_name";
NSString * const kTournamentListKeyStartTime                = @"start_time";
NSString * const kTournamentListKeyEndTime                  = @"end_time";
NSString * const kTournamentListKeyRound                    = @"round";
NSString * const kTournamentListKeyTournamentName           = @"tournament_name";
NSString * const kTournamentListKeyTournamentShortName      = @"tournament_short_name";
NSString * const kTournamentListKeyPlayCount                = @"play_count";
NSString * const kTournamentListKeyTeam                     = @"team";
NSString * const kTournamentListKeyOdds                     = @"odds";

#pragma mark - TeamKey

NSString * const kTournamentTeamKeyTeamID                   = @"team_id";
NSString * const kTournamentTeamKeyLogo                     = @"team_logo";
NSString * const kTournamentTeamKeyName                     = @"team_name";
NSString * const kTournamentTeamKeyShortName                = @"team_short_name";
NSString * const kTournamentTeamKeyScore                    = @"score";
NSString * const kTournamentTeamKeyPos                      = @"pos";
NSString * const kTournamentTeamKeyID                       = @"id";
NSString * const kTournamentTeamKeyMatchID                  = @"match_id";

#pragma mark - ScoreKey

NSString * const kTournamentScoreKeyTotal                   = @"total";

#pragma mark - OddsKey

NSString * const kTournamentOddsKeyGroupID                  = @"odds_group_id";
NSString * const kTournamentOddsKeyValue                    = @"value";
NSString * const kTournamentOddsKeyWin                      = @"win";
NSString * const kTournamentOddsKeyStatus                   = @"status";
NSString * const kTournamentOddsKeyBetLimit                 = @"bet_limit";
NSString * const kTournamentOddsKeyLastUpdate               = @"last_update";
NSString * const kTournamentOddsKeyMatchStage               = @"match_stage";
NSString * const kTournamentOddsKeyMatchName                = @"match_name";
NSString * const kTournamentOddsKeyGroupName                = @"group_name";
NSString * const kTournamentOddsKeyGroupShortName           = @"group_short_name";
NSString * const kTournamentOddsKeyID                       = @"id";
NSString * const kTournamentOddsKeyOddsID                   = @"odds_id";
NSString * const kTournamentOddsKeyTeamID                   = @"team_id";
NSString * const kTournamentOddsKeyName                     = @"name";
NSString * const kTournamentOddsKeyMatchID                  = @"match_id";
NSString * const kTournamentOddsKeyOdds                     = @"odds";
NSString * const kTournamentOddsKeyTag                      = @"tag";

@interface LGTournamentListManager ()

@property (nonatomic, strong) LGBasicRequest *requset;

@end

@implementation LGTournamentListManager

- (void)fetchData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"list_sample.json" ofType:nil];
    if (!filePath) {
        return;
    }
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dic = [LGTournamentListManager dictionaryWithJSON:data];
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
            case LGTournamentListType_Today:
                _requset = [[LGTournamentTodayRequest alloc] init];
                break;
            case LGTournamentListType_Before:
                _requset = [[LGTournamentBeforeRequest alloc] init];
                break;
            case LGTournamentListType_Rolling:
                _requset = [[LGTournamentRollingRequest alloc] init];
                break;
            case LGTournamentListType_Finished:
                _requset = [[LGTournamentFinishedRequest alloc] init];
                break;
        }
    }
    return _requset;
}

@end
