//
//  LGSignUpRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/6.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGSignUpRequest.h"

@implementation LGSignUpRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPISignUpURL method:HTTPRequestMethod_POST]) {
        
    }
    return self;
}

- (void)requestWithAccountName:(NSString *)accountName
                           pwd:(NSString *)pwd
                          name:(NSString *)name
                        mobile:(NSString *)mobile
                    verifyCode:(NSString *)verifyCode
                       success:(RequestSucceedBlock)success
                       failure:(RequestFailBlock)failure {
    if (accountName.length == 0 || pwd.length == 0 || name.length == 0 || mobile.length == 0 || verifyCode.length == 0) {
        return;
    }
        
    [self.paraDic setObject:accountName forKey:@"username"];
    [self.paraDic setObject:pwd forKey:@"password"];
    [self.paraDic setObject:name forKey:@"name"];
    [self.paraDic setObject:mobile forKey:@"mobile"];
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
