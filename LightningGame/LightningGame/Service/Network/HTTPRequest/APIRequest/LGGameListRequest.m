//
//  LGGameListRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGGameListRequest.h"

@implementation LGGameListRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPIGameListURL method:HTTPRequestMethod_GET]) {
        
    }
    return self;
}

- (void)requestWithSuccess:(RequestSucceedBlock)success failure:(RequestFailBlock)failure {
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
