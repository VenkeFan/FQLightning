//
//  FQNetworkManager.h
//  FQWidgets
//
//  Created by fanqi on 17/6/27.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, HTTPResponseStatus){
    HTTPResponseStatus_ERROR = 0,               /**< 失败*/
    HTTPResponseStatus_SUCCEED = 1,             /**< 成功 */
    HTTPResponseStatus_Authorize = 100001,      /**< 登录授权 */
};

NS_ASSUME_NONNULL_BEGIN

/** 请求完成回调 */
typedef void(^RequestSucceedBlock)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject);
typedef void(^RequestFailBlock)(NSURLSessionDataTask * _Nullable task, NSError * error);


@interface FQNetworkManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(nullable NSDictionary *)parameters
                      success:(nullable RequestSucceedBlock)success
                      failure:(nullable RequestFailBlock)failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(nullable NSDictionary *)parameters
                       success:(nullable RequestSucceedBlock)success
                       failure:(nullable RequestFailBlock)failure;

+ (void)updateCookie:(NSString *)cookie;
- (void)cancelAllRequest;
- (void)cancelRequestWithURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
