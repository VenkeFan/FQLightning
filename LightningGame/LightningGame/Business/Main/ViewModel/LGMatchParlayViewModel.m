//
//  LGMatchParlayViewModel.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/21.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchParlayViewModel.h"
#import "LGBetRequest.h"

@interface LGMatchParlayViewModel ()

@end

@implementation LGMatchParlayViewModel

- (void)parlayWithBet:(NSNumber *)bet oddsID:(NSNumber *)oddsID {
    LGBetRequest *request = [LGBetRequest new];
    [request requestWithOddsID:oddsID
                        amount:bet
                       success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                           if ([self.delegate respondsToSelector:@selector(matchParlayViewModel:responseObj:error:)]) {
                               [self.delegate matchParlayViewModel:self responseObj:responseObject error:nil];
                           }
                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           if ([self.delegate respondsToSelector:@selector(matchParlayViewModel:responseObj:error:)]) {
                               [self.delegate matchParlayViewModel:self responseObj:nil error:error];
                           }
                       }];
}

@end
