//
//  LGUserManager.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGUserManager.h"
#import "NSDate+FQExtension.h"
#import "LGAddBankCardRequest.h"
#import "LGUserBankListRequest.h"
#import "LGWithdrawRequest.h"
#import "LGModifyBirthRequest.h"

NSString * const kCardKeyNumber                 = @"card";
NSString * const kCardKeyName                   = @"card_name";
NSString * const kCardKeyLogo                   = @"logo";
NSString * const kCardKeyCreatedTimestamp       = @"create_time";
NSString * const kCardKeyBindID                 = @"id";
NSString * const kCardKeyUserID                 = @"uid";

@interface LGUserManager ()

@property (nonatomic, copy, readwrite) NSArray *cardArray;

@end

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

- (void)addCardNum:(NSString *)cardNum bankName:(NSString *)bankName completed:(void(^)(BOOL result))completed {
    LGAddBankCardRequest *request = [LGAddBankCardRequest new];
    [request requestWithCardNum:cardNum
                       bankName:bankName
                        success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                            if (completed) {
                                completed(YES);
                            }
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            if (completed) {
                                completed(NO);
                            }
                        }];
}

- (void)fetchUserBankListWithCompleted:(void(^)(BOOL result))completed {
    LGUserBankListRequest *request = [LGUserBankListRequest new];
    [request requestWithSuccess:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        self.cardArray = (NSArray *)responseObject;
        
        if (completed) {
            completed(self.cardArray.count > 0);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completed) {
            completed(NO);
        }
    }];
}

- (void)withDrawWithCardID:(NSNumber *)cardID money:(NSInteger)money completed:(void(^)(BOOL result))completed {
    LGWithdrawRequest *request = [LGWithdrawRequest new];
    [request requestWithCardID:cardID
                         money:money
                       success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                           if (completed) {
                               completed(YES);
                           }
                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           if (completed) {
                               completed(NO);
                           }
                       }];
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
