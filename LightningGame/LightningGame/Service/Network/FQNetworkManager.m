//
//  FQNetworkManager.m
//  FQWidgets
//
//  Created by fanqi on 17/6/27.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "FQNetworkManager.h"
#import "FQNetworkReachabilityManager.h"
#import "LGAPIURL.h"

#define kMaxRequestCount            (5)
#define kMaxTimeoutInterval         (15.0)

typedef NS_ENUM(NSInteger, HTTPRequestMethod){
    HTTPRequestMethod_GET,
    HTTPRequestMethod_POST,
    HTTPRequestMethod_PUT,
    HTTPRequestMethod_DELETE,
    HTTPRequestMethod_UPLOAD,
    HTTPRequestMethod_HEAD,
    HTTPRequestMethod_PATCH
};


@interface FQNetworkManager ()

@property (nonatomic, strong) NSMutableArray<NSURLSessionDataTask *> *allTasks;
@property (nonatomic, strong) NSMutableDictionary *token;

@end

@implementation FQNetworkManager

+ (instancetype)sharedManager {
    static FQNetworkManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBasicURL]];
        _instance.operationQueue.maxConcurrentOperationCount = kMaxRequestCount;
        // 请求
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        requestSerializer.timeoutInterval = kMaxTimeoutInterval;
        _instance.requestSerializer = requestSerializer;
        // 解析
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                     @"application/json", @"text/html",
                                                     @"text/json", @"text/javascript",
                                                     @"text/plain", nil];
        _instance.responseSerializer = responseSerializer;
        // 设置 cookie
        _instance.requestSerializer.HTTPShouldHandleCookies = YES;
    });
    return _instance;
}

#pragma mark - Public

+ (void)updateCookie:(NSString *)cookie {
    [[FQNetworkManager sharedManager].requestSerializer setValue:cookie
                                              forHTTPHeaderField:@"Cookie"];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(nullable NSDictionary *)parameters
                      success:(nullable RequestSucceedBlock)success
                      failure:(nullable RequestFailBlock)failure {
    return [self requestMethod:HTTPRequestMethod_GET
                           URL:URLString
                    parameters:parameters
     constructingBodyWithBlock:nil
                      success:success
                       failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(nullable NSDictionary *)parameters
                      success:(nullable RequestSucceedBlock)success
                      failure:(nullable RequestFailBlock)failure {
    return [self requestMethod:HTTPRequestMethod_POST
                           URL:URLString
                    parameters:parameters
     constructingBodyWithBlock:nil
                      success:success
                       failure:failure];
}

- (void)cancelAllRequest {
    @synchronized(self) {
        [self.allTasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [self.allTasks removeAllObjects];
    };
}

- (void)cancelRequestWithURL:(NSString *)url {
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        [self.allTasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.originalRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                *stop = YES;
            }
        }];
    };
}

#pragma mark - Private

- (NSURLSessionDataTask *)requestMethod:(HTTPRequestMethod)method
                                    URL:(NSString *)URLString
                             parameters:(NSDictionary *)parameters
              constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block
                                success:(RequestSucceedBlock)success
                                failure:(RequestFailBlock)failure {
    NSURLSessionDataTask *task = nil;
    
    if (parameters == nil) {
        parameters = @{@"token": self.token};
    } else {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [dictM setObject:self.token forKey:@"token"];
        parameters = dictM;
    }
    
    switch (method) {
        case HTTPRequestMethod_GET: {
            task = [self GET:URLString
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         [self handleSuccessCallbackWithTask:task responseObject:responseObject finished:success];
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         [self handleFailureCallbackWithTask:task error:error finished:failure];
                     }];
            break;
        }
        case HTTPRequestMethod_POST: {
            task = [self POST:URLString
                   parameters:parameters
                     progress:^(NSProgress * _Nonnull downloadProgress) {
                         
                     }
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          [self handleSuccessCallbackWithTask:task responseObject:responseObject finished:success];
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          [self handleFailureCallbackWithTask:task error:error finished:failure];
                      }];
            break;
        }
        case HTTPRequestMethod_PUT: {
            task = [self PUT:URLString
                  parameters:parameters
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         
                         [self handleSuccessCallbackWithTask:task responseObject:responseObject finished:success];
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         
                         [self handleFailureCallbackWithTask:task error:error finished:failure];
                     }];
            break;
        }
        case HTTPRequestMethod_DELETE: {
            task = [self DELETE:URLString
                     parameters:parameters
                        success:^(NSURLSessionDataTask *task, id responseObject) {
                            
                            [self handleSuccessCallbackWithTask:task responseObject:responseObject finished:success];
                        }
                        failure:^(NSURLSessionDataTask *task, NSError *error) {
                            
                            [self handleFailureCallbackWithTask:task error:error finished:failure];
                        }];
            break;
        }
        case HTTPRequestMethod_UPLOAD: {
            task = [self POST:URLString
                   parameters:parameters
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    }
                     progress:^(NSProgress * _Nonnull uploadProgress) {
                         
                     }
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          [self handleSuccessCallbackWithTask:task responseObject:responseObject finished:success];
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          [self handleFailureCallbackWithTask:task error:error finished:failure];
                      }];
        }
            break;
        default:
            break;
    }
    
    if (task) {
        [self.allTasks addObject:task];
    }
    
    return task;
}

- (void)handleSuccessCallbackWithTask:(NSURLSessionDataTask *)task
                       responseObject:(id)responseObject
                             finished:(RequestSucceedBlock)finished {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self judgeResponseStatusWithObj:responseObject task:task];
        
        [[FQNetworkManager sharedManager].allTasks removeObject:task];
        
        if (finished) {
            finished(task, responseObject);
        }
    });
}

- (void)handleFailureCallbackWithTask:(NSURLSessionDataTask *)task
                                error:(NSError *)error
                             finished:(RequestFailBlock)finished {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[FQNetworkManager sharedManager].allTasks removeObject:task];
        NSLog(@"%@ -- %@", task.currentRequest.URL.absoluteString, error);
        
        if (finished) {
            finished(task, error);
        }
    });
}

/// 判断网络请求的状态
- (void)judgeResponseStatusWithObj:(id)responseObject task:(NSURLSessionDataTask *)task {
    if ([responseObject[@"status"] integerValue] == HTTPResponseStatus_Authorize) { // 登录授权判断
        
//        UIViewController *vc = [CCSystemHelper currentViewController];
//        if ([vc isKindOfClass:[CCLoginViewController class]]) {
//            return;
//        }
//        if ([vc isKindOfClass:[UIViewController class]]) {
//            CCLoginViewController *ctr = [[CCLoginViewController alloc] init];
//            [vc presentViewController:ctr animated:YES completion:nil];
//        }
    }
}

#pragma mark - Getter

- (NSMutableArray<NSURLSessionDataTask *> *)allTasks {
    if (!_allTasks) {
        _allTasks = [NSMutableArray arrayWithCapacity:kMaxRequestCount];
    }
    return _allTasks;
}

- (NSMutableDictionary *)token {
    if (!_token) {
//        _token = @{@"mobile_type": @"1",
//                   @"app_version": [CCSystemHelper appVersion],
//                   @"device_name": [CCSystemHelper deviceName],
//                   @"device_system_version": [CCSystemHelper deviceSystemVersion],
//                   @"network_type": [FQNetworkReachabilityManager getNetworkStatusName]}.mutableCopy;
        
        _token = [NSMutableDictionary dictionary];
//        [_token setObject:@"1" forKey:@"mobile_type"];
//        [_token setObject:[CCSystemHelper appVersion] forKey:@"app_version"];
//        [_token setObject:[CCSystemHelper deviceName] forKey:@"device_name"];
//        [_token setObject:[CCSystemHelper deviceSystemVersion] forKey:@"device_system_version"];
    }
    
    [_token setObject:[FQNetworkReachabilityManager getNetworkStatusName] forKey:@"network_type"];
    
    return _token;
}

@end
