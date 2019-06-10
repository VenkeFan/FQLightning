//
//  FQNetworkManager.h
//  FQWidgets
//
//  Created by fanqi on 17/6/27.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTTPResponseStatus){
    HTTPResponseStatus_ERROR = 0,               /**< 失败*/
    HTTPResponseStatus_SUCCEED = 1,             /**< 成功 */
    HTTPResponseStatus_Authorize = 100001,      /**< 登录授权 */
};

typedef NS_ENUM(NSInteger, HTTPRequestMethod){
    HTTPRequestMethod_GET,
    HTTPRequestMethod_POST,
    HTTPRequestMethod_PUT,
    HTTPRequestMethod_DELETE,
    HTTPRequestMethod_UPLOAD,
    HTTPRequestMethod_HEAD,
    HTTPRequestMethod_PATCH
};

NS_ASSUME_NONNULL_BEGIN

typedef void(^RequestSucceedBlock)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject);
typedef void(^RequestFailBlock)(NSURLSessionDataTask * _Nullable task, NSError * error);


@interface FQNetworkManager : NSObject

+ (instancetype)sharedManager;

- (NSURLSessionDataTask *)requestWithURLString:(NSString *)URLString
                                        method:(HTTPRequestMethod)method
                                    parameters:(nullable NSDictionary *)parameters
                                       success:(nullable RequestSucceedBlock)success
                                       failure:(nullable RequestFailBlock)failure;

- (NSURLSessionDataTask *)requestWithURLString:(NSString *)URLString
                                        method:(HTTPRequestMethod)method
                                    parameters:(nullable NSDictionary *)parameters
                                      progress:(nullable void (^)(NSProgress * _Nonnull))downloadProgress
                                       success:(nullable RequestSucceedBlock)success
                                       failure:(nullable RequestFailBlock)failure;

- (void)cancelAllRequest;
- (void)cancelRequestWithURL:(NSString *)url;
+ (void)updateCookie:(NSString *)cookie;

@end

NS_ASSUME_NONNULL_END
