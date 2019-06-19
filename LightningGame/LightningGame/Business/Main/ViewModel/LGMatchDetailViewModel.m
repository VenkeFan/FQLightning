//
//  LGMatchDetailViewModel.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/13.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchDetailViewModel.h"
#import "LGMatchDetailRequest.h"
#import "NSDictionary+FQExtension.h"

NSString * const LGMatchStageMapping[] = {
    [1] = @"一",
    [2] = @"二",
    [3] = @"三",
    [4] = @"四",
    [5] = @"五",
    [6] = @"六",
    [7] = @"七",
    [8] = @"八",
    [9] = @"九"
};

@interface LGMatchDetailViewModel ()

@property (nonatomic, strong) NSMutableDictionary *matchStateDicM;

@end

@implementation LGMatchDetailViewModel

- (void)fetchDataWithMatchID:(NSString *)matchID {
    {
//        TODO(@"test data");
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"detail_sample1.json" ofType:nil];
//        if (!filePath) {
//            return;
//        }
//        NSData *data = [NSData dataWithContentsOfFile:filePath];
//        NSMutableDictionary *dic = [[NSDictionary dictionaryWithJSON:data] fq_mutableDictionary];
//        NSMutableDictionary *resultDic = [dic objectForKey:@"result"];
//
//        NSArray *oddsArray = resultDic[kMatchKeyOdds];
//        NSArray *teamArray = resultDic[kMatchKeyTeam];
//        NSMutableDictionary *oddsDic = [self p_handleMatchStage:oddsArray];
//
//        if ([self.delegate respondsToSelector:@selector(matchDetailDidFetch:matchDic:teamArray:oddsDic:errCode:)]) {
//            [self.delegate matchDetailDidFetch:self matchDic:resultDic teamArray:teamArray oddsDic:oddsDic errCode:-1];
//        }
//        return;
    }
    
    LGMatchDetailRequest *request = [[LGMatchDetailRequest alloc] initWithMatchID:matchID];
    [request requsetWithSuccess:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray *oddsArray = responseObject[kMatchKeyOdds];
        NSArray *teamArray = responseObject[kMatchKeyTeam];
        NSMutableDictionary *oddsDic = [[self p_handleMatchStage:oddsArray] fq_mutableDictionary];
        
        if ([self.delegate respondsToSelector:@selector(matchDetailDidFetch:matchDic:teamArray:oddsDic:errCode:)]) {
            [self.delegate matchDetailDidFetch:self matchDic:responseObject teamArray:teamArray oddsDic:oddsDic errCode:LGErrorCode_Success];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(matchDetailDidFetch:matchDic:teamArray:oddsDic:errCode:)]) {
            [self.delegate matchDetailDidFetch:self matchDic:nil teamArray:nil oddsDic:nil errCode:error.code];
        }
    }];
}

+ (NSString *)matchStage:(NSString *)stageKey {
    if ([stageKey isEqualToString:@"final"]) {
        return @"全场";
    } else if ([stageKey isEqualToString:@"r1"]) {
        return @"第一局";
    } else if ([stageKey isEqualToString:@"r2"]) {
        return @"第二局";
    } else if ([stageKey isEqualToString:@"r3"]) {
        return @"第三局";
    } else if ([stageKey isEqualToString:@"map1"]) {
        return @"地图一";
    } else if ([stageKey isEqualToString:@"map2"]) {
        return @"地图二";
    } else if ([stageKey isEqualToString:@"map3"]) {
        return @"地图三";
    }
    
//    if ([stageKey isEqualToString:@"final"]) {
//        return @"全场";
//    } else if ([stageKey hasPrefix:@"r"]) {
//        NSString *index = [stageKey substringFromIndex:[stageKey rangeOfString:@"r"].length];
//
//    } else if ([stageKey hasPrefix:@"map"]) {
//
//    }
    
    return @"";
}

- (NSMutableDictionary *)p_handleMatchStage:(NSArray *)oddsArray {
    NSMutableDictionary *matchStageDic = [NSMutableDictionary dictionary];
    
    [oddsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *oddsDic = (NSDictionary *)obj;
        NSString *stageKey = oddsDic[kMatchOddsKeyMatchStage];
        
        if (nil == matchStageDic[stageKey]) {
            NSMutableArray *arrayM = [NSMutableArray array];
            [arrayM addObject:oddsDic];
            [matchStageDic setObject:arrayM forKey:stageKey];
        } else {
            NSMutableArray *arrayM = matchStageDic[stageKey];
            [arrayM addObject:oddsDic];
        }
    }];
    
    [self p_handleMatchStageGroup:matchStageDic];
    
    return matchStageDic;
}

- (void)p_handleMatchStageGroup:(NSMutableDictionary *)matchStageDic {
    
    [matchStageDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableDictionary *groupDic = [NSMutableDictionary dictionary];
        NSMutableArray *tmpArray = (NSMutableArray *)obj;

        for (int i = 0; i < tmpArray.count; i++) {
            NSDictionary *oddsDic = (NSDictionary *)tmpArray[i];
            NSString *groupKey = [oddsDic[kMatchOddsKeyGroupID] stringValue];

            if (nil == groupDic[groupKey]) {
                NSMutableArray *arrayM = [NSMutableArray array];
                [arrayM addObject:oddsDic];
                [groupDic setObject:arrayM forKey:groupKey];
            } else {
                NSMutableArray *arrayM = groupDic[groupKey];
                [arrayM addObject:oddsDic];
            }
        }
        
        NSMutableArray *groupArray = [NSMutableArray arrayWithCapacity:groupDic.count];
        [groupDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key2, id  _Nonnull obj2, BOOL * _Nonnull stop2) {
            [groupArray addObject:obj2];
        }];
        
        [self p_sortGroupArray:groupArray];

        [matchStageDic setObject:groupArray forKey:key];
    }];
}

- (void)p_sortGroupArray:(NSMutableArray *)groupArray {
    [groupArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSArray *array1 = (NSArray *)obj1;
        NSArray *array2 = (NSArray *)obj2;
        
        NSDictionary *oddsDic1 = array1.firstObject;
        NSDictionary *oddsDic2 = array2.firstObject;
        
        return [oddsDic1[kMatchOddsKeySortIndex] integerValue] < [oddsDic2[kMatchOddsKeySortIndex] integerValue];
    }];
}

@end
