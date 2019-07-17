//
//  LGWithdrawRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGWithdrawRequest.h"

@implementation LGWithdrawRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPIWithdrawURL method:HTTPRequestMethod_GET]) {
        
    }
    return self;
}

- (void)requestWithCardID:(NSNumber *)cardID
                    money:(NSInteger)money
                  success:(nullable RequestSucceedBlock)success
                  failure:(nullable RequestFailBlock)failure {
    if (!cardID || money <= 0) {
        return;
    }
    
    [self.paraDic setObject:cardID forKey:@"bind_id"];
    [self.paraDic setObject:@(money) forKey:@"amount"];
    
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
