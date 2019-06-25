//
//  LGBasicRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGBasicRequest.h"

@interface LGBasicRequest ()

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, assign) HTTPRequestMethod method;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation LGBasicRequest

- (instancetype)init {
    NSAssert(![self isKindOfClass:[LGBasicRequest class]], @"You should not init LGBasicRequest directly, use -initWithAPIName:method: instead");
    return nil;
}

- (instancetype)initWithAPIName:(NSString *)apiName method:(HTTPRequestMethod)method {
    NSAssert(![self isMemberOfClass:[LGBasicRequest class]], @"LGBasicRequest is an abstract class, you should not instantiate it directly.");
    if (self = [super init]) {
        _urlStr = [NSString stringWithFormat:@"%@%@", kBasicURL, apiName];
        _method = method;
        _paraDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)requestWithSuccess:(RequestSucceedBlock)success failure:(RequestFailBlock)failure {
    NSError* (^generateError)(NSInteger) = ^(NSInteger errorCode) {
        NSError *error = [NSError errorWithDomain:@""
                                             code:errorCode
                                         userInfo:nil];
        return error;
    };
    
    FQNetworkManager *manager = [FQNetworkManager sharedManager];
    _task = [manager requestWithURLString:self.urlStr
                                   method:self.method
                               parameters:self.paraDic
                                  success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                                      if (!responseObject) {
                                          if (failure) {
                                              failure(task, generateError(LGErrorCode_UnDefine));
                                          }
                                          return;
                                      }
                                      
                                      id errorObj = responseObject[@"code"];
                                      if (!errorObj) {
                                          if (failure) {
                                              failure(task, generateError(LGErrorCode_UnDefine));
                                          }
                                          return;
                                      }
                                      
                                      @try {
                                          NSInteger errorCode = [errorObj integerValue];
                                          if (errorCode != LGErrorCode_Success) {
                                              if (failure) {
                                                  failure(task, generateError(errorCode));
                                              }
                                              return;
                                          }
                                          
                                          if (success) {
                                              success(task, responseObject[@"result"]);
                                          }
                                      } @catch (NSException *exception) {
                                          if (failure) {
                                              failure(task, generateError(LGErrorCode_UnDefine));
                                          }
                                      } @finally {
                                          
                                      }
                                  }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      if (failure) {
                                          failure(task, error);
                                      }
                                  }];
}

- (void)cancel {
    [_task cancel];
    _task = nil;
}

@end
