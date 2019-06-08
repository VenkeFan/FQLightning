//
//  LGVerifyCodeRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/5.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGVerifyCodeRequest.h"

@implementation LGVerifyCodeRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPIVerifyCodeURL method:HTTPRequestMethod_GET]) {
        
    }
    return self;
}

- (void)requestWithMobile:(NSString *)mobile
                  success:(nullable RequestSucceedBlock)success
                  failure:(nullable RequestFailBlock)failure {
    if (mobile.length == 0) {
        return;
    }
    
    [self.paraDic setObject:mobile forKey:@"mobile"];
    
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
