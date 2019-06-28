//
//  LGUserInfoRequest.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/25.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGBasicRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGUserInfoRequest : LGBasicRequest

- (void)requestWithUserID:(NSNumber *)userID
              accessToken:(NSString *)accessToken
                  success:(nullable RequestSucceedBlock)success
                  failure:(nullable RequestFailBlock)failure;

@end

NS_ASSUME_NONNULL_END
