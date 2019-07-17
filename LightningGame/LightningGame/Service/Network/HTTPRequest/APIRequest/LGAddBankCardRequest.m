//
//  LGAddBankCardRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGAddBankCardRequest.h"

@implementation LGAddBankCardRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPIAddBankCardURL method:HTTPRequestMethod_POST]) {
        
    }
    return self;
}

- (void)requestWithCardNum:(NSString *)cardNum
                  bankName:(NSString *)bankName
                   success:(nullable RequestSucceedBlock)success
                   failure:(nullable RequestFailBlock)failure {
    if (cardNum.length == 0 || bankName.length == 0) {
        return;
    }
    
    [self.paraDic setObject:cardNum forKey:@"card"];
    [self.paraDic setObject:bankName forKey:@"bank_name"];
    
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
