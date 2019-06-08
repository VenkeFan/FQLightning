//
//  LGSignUpRequest.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/6.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGBasicRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGSignUpRequest : LGBasicRequest

- (void)requestWithAccountName:(NSString *)accountName
                           pwd:(NSString *)pwd
                          name:(NSString *)name
                        mobile:(NSString *)mobile
                    verifyCode:(NSString *)verifyCode
                       success:(nullable RequestSucceedBlock)success
                       failure:(nullable RequestFailBlock)failure;

@end

NS_ASSUME_NONNULL_END
