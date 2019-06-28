//
//  LGOAuthRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/18.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGOAuthRequest.h"

@implementation LGOAuthRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPIOAuth2URL method:HTTPRequestMethod_POST]) {
        
    }
    return self;
}

- (void)requestWithAccessToken:(NSString *)accessToken
                       success:(RequestSucceedBlock)success
                       failure:(RequestFailBlock)failure {
    if (accessToken.length == 0) {
        return;
    }
    
    [self.paraDic setObject:accessToken forKey:@"access_token"];
    
    [super requestWithSuccess:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
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
