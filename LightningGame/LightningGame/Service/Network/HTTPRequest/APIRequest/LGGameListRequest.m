//
//  LGGameListRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGGameListRequest.h"

@implementation LGGameListRequest

- (instancetype)init {
    if (self = [super initWithAPIName:kAPIGameListURL method:HTTPRequestMethod_GET]) {
        
    }
    return self;
}

@end
