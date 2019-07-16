//
//  LGUserManager.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGUserManager.h"
#import "NSDate+FQExtension.h"
#import "LGModifyBirthRequest.h"

@implementation LGUserManager

+ (instancetype)manager {
    static LGUserManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [LGUserManager manager];
}

- (void)modifyBirthday:(NSDate *)birthday success:(void(^)(NSString *newBirthday))success failure:(void(^)(void))failure {
    LGModifyBirthRequest *request = [LGModifyBirthRequest new];
    [request requestWithBirthday:[birthday ISO8601StringRaw]
                         success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                             if (success) {
                                 success(responseObject[@"birthday"]);
                             }
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             if (failure) {
                                 failure();
                             }
                         }];
}

@end
