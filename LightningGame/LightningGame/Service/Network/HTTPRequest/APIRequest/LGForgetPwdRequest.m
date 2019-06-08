//
//  LGForgetPwdRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/6.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGForgetPwdRequest.h"

@implementation LGForgetPwdRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPIForgetPwdURL method:HTTPRequestMethod_POST]) {
        
    }
    return self;
}

- (void)requestWithMobile:(NSString *)mobile
                   newPwd:(NSString *)newPwd
               verifyCode:(NSString *)verifyCode
                  success:(nullable RequestSucceedBlock)success
                  failure:(nullable RequestFailBlock)failure {
    if (mobile.length == 0 || newPwd.length == 0 || verifyCode.length == 0) {
        return;
    }
    
    [self.paraDic setObject:mobile forKey:@"mobile"];
    [self.paraDic setObject:newPwd forKey:@"password"];
    [self.paraDic setObject:verifyCode forKey:@"sms"];
    
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
