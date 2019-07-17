//
//  LGUserBankListRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGUserBankListRequest.h"

@implementation LGUserBankListRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPIBankCardListURL method:HTTPRequestMethod_GET]) {
        
    }
    return self;
}

@end
