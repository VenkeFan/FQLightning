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

- (void)requestWithOddsID:(NSString *)oddsID amount:(CGFloat)amount success:(RequestSucceedBlock)success failure:(RequestFailBlock)failure {
    if (oddsID.length == 0 || amount <= 0) {
        return;
    }
    
    [FQNetworkManager setAccessToken:[[LGAccountManager instance].account objectForKey:kAccountKeyAccountAccessToken]];
    [self.paraDic setObject:oddsID forKey:@"oddsid"];
    [self.paraDic setObject:@(amount) forKey:@"amount"];
    
    [super requsetWithSuccess:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

@end
