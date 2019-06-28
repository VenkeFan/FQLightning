//
//  LGBetRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/21.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGBetRequest.h"

@implementation LGBetRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPIBetURL method:HTTPRequestMethod_POST]) {
        
    }
    return self;
}

- (void)requestWithOddsID:(NSNumber *)oddsID amount:(NSNumber *)amount success:(RequestSucceedBlock)success failure:(RequestFailBlock)failure {
    if (oddsID == nil || amount == nil) {
        return;
    }
    
    [[FQNetworkManager sharedManager] setJSONRequestSerializer];
    [FQNetworkManager setContentType:@"application/json;charset=utf-8"];
    [FQNetworkManager setAccessToken:[[LGAccountManager instance].account objectForKey:kAccountKeyAccountAccessToken]];
    
    NSDictionary *dic = @{@"oddsid": oddsID, @"amount": amount};
    [self.paraDic setObject:@[dic] forKey:@"datas"];
    
    [super requestWithSuccess:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [[FQNetworkManager sharedManager] setHTTPRequestSerializer];
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[FQNetworkManager sharedManager] setHTTPRequestSerializer];
        if (failure) {
            failure(task, error);
        }
    }];
}

- (void)requestWithOddsDic:(NSDictionary *)oddsDic success:(RequestSucceedBlock)success failure:(RequestFailBlock)failure {
    if (oddsDic == nil) {
        return;
    }
    
    [[FQNetworkManager sharedManager] setJSONRequestSerializer];
    [FQNetworkManager setContentType:@"application/json;charset=utf-8"];
    [FQNetworkManager setAccessToken:[[LGAccountManager instance].account objectForKey:kAccountKeyAccountAccessToken]];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    [oddsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [arrayM addObject:@{@"oddsid": key, @"amount": obj}];
    }];
    
    [self.paraDic setObject:arrayM forKey:@"datas"];
    
    [super requestWithSuccess:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [[FQNetworkManager sharedManager] setHTTPRequestSerializer];
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[FQNetworkManager sharedManager] setHTTPRequestSerializer];
        if (failure) {
            failure(task, error);
        }
    }];
}

@end
