//
//  LGParlayHistoryRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/12.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGParlayHistoryRequest.h"

@implementation LGParlayHistoryRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPIParlayHistoryURL method:HTTPRequestMethod_GET]) {
        
    }
    return self;
}

- (void)requestWithPageIndex:(NSInteger)pageIndex
                      status:(NSInteger)status
                     success:(nullable RequestSucceedBlock)success
                     failure:(nullable RequestFailBlock)failure {
    [self.paraDic setObject:@(pageIndex) forKey:@"page_num"];
    [self.paraDic setObject:@(status) forKey:@"status"];
    
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
