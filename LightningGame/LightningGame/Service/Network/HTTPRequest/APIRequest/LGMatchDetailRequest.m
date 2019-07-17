//
//  LGMatchDetailRequest.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchDetailRequest.h"

@implementation LGMatchDetailRequest

- (instancetype)initWithMatchID:(NSNumber *)matchID {
    if (self = [super initWithAPIName:[NSString stringWithFormat:@"%@%@", kAPIMatchDetailURL, matchID] method:HTTPRequestMethod_GET]) {
        
    }
    return self;
}

@end
