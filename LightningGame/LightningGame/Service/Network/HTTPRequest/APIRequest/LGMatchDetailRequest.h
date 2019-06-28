//
//  LGMatchDetailRequest.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGBasicRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGMatchDetailRequest : LGBasicRequest

- (instancetype)initWithMatchID:(NSNumber *)matchID;

@end

NS_ASSUME_NONNULL_END
