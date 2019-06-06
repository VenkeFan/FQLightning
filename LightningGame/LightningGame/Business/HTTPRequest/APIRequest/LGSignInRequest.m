//
//  LGSignInRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/6.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGSignInRequest.h"

@implementation LGSignInRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPISignInURL method:HTTPRequestMethod_POST]) {
        
    }
    return self;
}

- (void)signInWithAccountName:(NSString *)accountName
                          pwd:(NSString *)pwd
                      success:(RequestSucceedBlock)success
                      failure:(RequestFailBlock)failure {
    if (accountName.length == 0 || pwd.length == 0) {
        return;
    }
    
    [self.paraDic setObject:accountName forKey:@"username"];
    [self.paraDic setObject:pwd forKey:@"password"];
    
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
