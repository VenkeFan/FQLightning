//
//  LGBetRequest.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/21.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGBasicRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGBetRequest : LGBasicRequest

- (void)requestWithOddsID:(NSString *)oddsID
                   amount:(CGFloat)amount
                  success:(nullable RequestSucceedBlock)success
                  failure:(nullable RequestFailBlock)failure;

@end

NS_ASSUME_NONNULL_END
