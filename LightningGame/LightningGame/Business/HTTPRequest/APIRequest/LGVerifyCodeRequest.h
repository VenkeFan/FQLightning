//
//  LGVerifyCodeRequest.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/5.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGBasicRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGVerifyCodeRequest : LGBasicRequest

- (void)requestWithMobile:(NSString *)mobile
                  success:(nullable RequestSucceedBlock)success
                  failure:(nullable RequestFailBlock)failure;

@end

NS_ASSUME_NONNULL_END
