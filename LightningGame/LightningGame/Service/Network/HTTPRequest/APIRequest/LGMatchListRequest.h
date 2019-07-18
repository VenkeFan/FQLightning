//
//  LGMatchListRequest.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGBasicRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGMatchListRequest : LGBasicRequest

- (instancetype)initWithType:(NSInteger)type;

- (void)requestWithPageIndex:(NSInteger)pageIndex
                     success:(nullable RequestSucceedBlock)success
                     failure:(nullable RequestFailBlock)failure;

- (void)requestWithPageIndex:(NSInteger)pageIndex
                 gameIDArray:(nullable NSArray *)gameIDArray
                     success:(nullable RequestSucceedBlock)success
                     failure:(nullable RequestFailBlock)failure;

@end

NS_ASSUME_NONNULL_END
