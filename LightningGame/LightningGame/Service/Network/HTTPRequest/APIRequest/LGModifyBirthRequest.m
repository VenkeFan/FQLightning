//
//  LGModifyBirthRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGModifyBirthRequest.h"

@implementation LGModifyBirthRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPIModifyBirthURL method:HTTPRequestMethod_POST]) {
        
    }
    return self;
}

- (void)requestWithBirthday:(NSString *)birthday
                    success:(nullable RequestSucceedBlock)success
                    failure:(nullable RequestFailBlock)failure {
    if (birthday.length == 0) {
        return;
    }
    
    [self.paraDic setObject:birthday forKey:@"birthday"];
    
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
