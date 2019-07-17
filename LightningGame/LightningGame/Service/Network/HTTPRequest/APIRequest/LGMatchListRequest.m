//
//  LGMatchListRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchListRequest.h"

@implementation LGMatchListRequest

- (instancetype)initWithType:(NSInteger)type {
    if (self = [super initWithAPIName:[NSString stringWithFormat:@"%@%ld", kAPIMatchListURL, (long)type] method:HTTPRequestMethod_GET]) {
        
    }
    return self;
}

@end
