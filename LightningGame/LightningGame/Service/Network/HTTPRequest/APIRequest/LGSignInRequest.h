//
//  LGSignInRequest.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/6.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGBasicRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGSignInRequest : LGBasicRequest

- (void)requestWithAccountName:(NSString *)accountName
                           pwd:(NSString *)pwd
                       success:(RequestSucceedBlock)success
                       failure:(RequestFailBlock)failure;

@end

NS_ASSUME_NONNULL_END
