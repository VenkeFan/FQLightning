//
//  FQNetworkManager.m
//  FQWidgets
//
//  Created by fanqi on 17/6/27.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "FQNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "FQNetworkReachabilityManager.h"

#define kMaxRequestCount            (5)
#define kMaxTimeoutInterval         (15.0)

@interface FQNetworkManager ()

@property (nonatomic, strong) NSMutableArray<NSURLSessionDataTask *> *allTasks;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation FQNetworkManager

+ (instancetype)sharedManager {
    static FQNetworkManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        
        _instance.sessionManager = [[AFHTTPSessionManager alloc] init];
        _instance.sessionManager.operationQueue.maxConcurrentOperationCount = kMaxRequestCount;
        // 请求
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        requestSerializer.timeoutInterval = kMaxTimeoutInterval;
        _instance.sessionManager.requestSerializer = requestSerializer;
        // 解析
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                     @"application/json", @"text/html",
                                                     @"text/json", @"text/javascript",
                                                     @"text/plain", nil];
        _instance.sessionManager.responseSerializer = responseSerializer;
        // 设置 cookie
        _instance.sessionManager.requestSerializer.HTTPShouldHandleCookies = YES;
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [FQNetworkManager sharedManager];
}

#pragma mark - Public

- (NSURLSessionDataTask *)requestWithURLString:(NSString *)URLString
                                        method:(HTTPRequestMethod)method
                                    parameters:(nullable NSDictionary *)parameters
                                       success:(nullable RequestSucceedBlock)success
                                       failure:(nullable RequestFailBlock)failure {
    return [self requestWithURLString:URLString
                               method:method
                           parameters:parameters
                             progress:nil
                              success:success
                              failure:failure];
}

- (NSURLSessionDataTask *)requestWithURLString:(NSString *)URLString
                                        method:(HTTPRequestMethod)method
                                    parameters:(nullable NSDictionary *)parameters
                                      progress:(nullable void (^)(NSProgress * _Nonnull))downloadProgress
                                       success:(nullable RequestSucceedBlock)success
                                       failure:(nullable RequestFailBlock)failure {
    return [self p_requestWithMethod:method
                           URLString:URLString
                          parameters:parameters
                            progress:downloadProgress
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

+ (void)setCookie:(NSString *)cookie {
    [[FQNetworkManager sharedManager].sessionManager.requestSerializer setValue:cookie
                                                             forHTTPHeaderField:@"Cookie"];
}

+ (void)setAccessToken:(NSString *)accessToken {
    [[FQNetworkManager sharedManager].sessionManager.requestSerializer setValue:accessToken
                                                             forHTTPHeaderField:@"Authorization"];
}

#pragma mark - Private

+ (NSURLSessionConfiguration *)setProxyWithConfig {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    config.connectionProxyDictionary = @{
                                         @"HTTPEnable":@YES,
                                         (id)kCFStreamPropertyHTTPProxyHost:@"192.168.1.116",
                                         (id)kCFStreamPropertyHTTPProxyPort:@9001,
                                         @"HTTPSEnable":@YES,
                                         (id)kCFStreamPropertyHTTPSProxyHost:@"192.168.1.116",
                                         (id)kCFStreamPropertyHTTPSProxyPort:@9001};
    
    return config;
}

- (NSURLSessionDataTask *)p_requestWithMethod:(HTTPRequestMethod)method
                                    URLString:(NSString *)URLString
                                   parameters:(NSDictionary *)parameters
                                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                    constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block
                                      success:(RequestSucceedBlock)success
                                      failure:(RequestFailBlock)failure {
    NSURLSessionDataTask *task = nil;
    
    switch (method) {
        case HTTPRequestMethod_GET: {
            task = [self.sessionManager GET:URLString
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
            task = [self.sessionManager POST:URLString
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
            task = [self.sessionManager PUT:URLString
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
            task = [self.sessionManager DELETE:URLString
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
            task = [self.sessionManager POST:URLString
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

@end
