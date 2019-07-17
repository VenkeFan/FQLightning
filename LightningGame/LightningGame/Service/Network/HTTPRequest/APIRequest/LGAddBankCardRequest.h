//
//  LGAddBankCardRequest.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGBasicRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGAddBankCardRequest : LGBasicRequest

- (void)requestWithCardNum:(NSString *)cardNum
                  bankName:(NSString *)bankName
                   success:(nullable RequestSucceedBlock)success
                   failure:(nullable RequestFailBlock)failure;

@end

NS_ASSUME_NONNULL_END
