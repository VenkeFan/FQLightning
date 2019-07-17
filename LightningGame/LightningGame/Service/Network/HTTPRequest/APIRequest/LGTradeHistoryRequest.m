//
//  LGTradeHistoryRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGTradeHistoryRequest.h"

@implementation LGTradeHistoryRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPITradeHistoryURL method:HTTPRequestMethod_GET]) {
        
    }
    return self;
}

- (void)requestWithPageIndex:(NSInteger)pageIndex
                        type:(NSInteger)type
                     success:(nullable RequestSucceedBlock)success
                     failure:(nullable RequestFailBlock)failure {
    [self.paraDic setObject:@(pageIndex) forKey:@"page_num"];
    [self.paraDic setObject:@(type) forKey:@"type"];
    
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
