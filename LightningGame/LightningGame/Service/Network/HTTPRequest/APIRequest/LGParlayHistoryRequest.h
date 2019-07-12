//
//  LGParlayHistoryRequest.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/12.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGBasicRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGParlayHistoryRequest : LGBasicRequest

- (void)requestWithPageIndex:(NSInteger)pageIndex
                      status:(NSInteger)status
                     success:(nullable RequestSucceedBlock)success
                     failure:(nullable RequestFailBlock)failure;

@end

NS_ASSUME_NONNULL_END
