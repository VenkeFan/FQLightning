//
//  LGBasicRequest.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FQNetworkManager.h"
#import "LGAPIURLConfig.h"
#import "LGAPIErrorCode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGBasicRequest : NSObject

- (instancetype)initWithAPIName:(NSString *)apiName method:(HTTPRequestMethod)method;

- (void)requestWithSuccess:(nullable RequestSucceedBlock)success
                   failure:(nullable RequestFailBlock)failure;
- (void)cancel;

@property (nonatomic, copy) NSMutableDictionary *paraDic;

@end

NS_ASSUME_NONNULL_END
