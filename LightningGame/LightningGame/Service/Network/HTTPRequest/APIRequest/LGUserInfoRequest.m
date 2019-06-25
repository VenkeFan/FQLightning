//
//  LGUserInfoRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/25.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGUserInfoRequest.h"

@implementation LGUserInfoRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPIUserInfoURL method:HTTPRequestMethod_GET]) {
        
    }
    return self;
}

- (void)requestWithUserID:(NSNumber *)userID
              accessToken:(NSString *)accessToken
                  success:(RequestSucceedBlock)success
                  failure:(RequestFailBlock)failure {
    if (userID == nil || accessToken.length == 0) {
        return;
    }
    
    [self.paraDic setObject:userID forKey:@"openid"];
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
