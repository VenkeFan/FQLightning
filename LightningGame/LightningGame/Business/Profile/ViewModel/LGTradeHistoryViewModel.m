//
//  LGTradeHistoryViewModel.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGTradeHistoryViewModel.h"
#import "LGTradeHistoryRequest.h"

NSString * const kTradeHistoryKeyWithdrawStatus     = @"cash_status";
NSString * const kTradeHistoryKeyID                 = @"id";
NSString * const kTradeHistoryKeyMoney              = @"money";
NSString * const kTradeHistoryKeyChargeStatus       = @"recharge_status";
NSString * const kTradeHistoryKeyTimestamp          = @"time";
NSString * const kTradeHistoryKeyType               = @"type";

@interface LGTradeHistoryViewModel ()

@property (nonatomic, strong) LGTradeHistoryRequest *request;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation LGTradeHistoryViewModel

- (void)fetchData {
    _pageIndex = 1;
    
    [self p_requsetData];
}

- (void)loadMoreData {
    _pageIndex++;
    
    [self p_requsetData];
}

- (void)p_requsetData {
    if (_request) {
        return;
    }
    
    _request = [LGTradeHistoryRequest new];
    
    [_request requestWithPageIndex:_pageIndex
                              type:self.tradeType
                           success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                               self.request = nil;
                               
                               NSInteger totalPage = [responseObject[@"pages"] integerValue];
                               NSInteger currentPage = [responseObject[@"page_num"] integerValue];
                               NSArray *data = responseObject[@"records"];
                               
                               if ([self.delegate respondsToSelector:@selector(tradeHistoryDidFetch:data:last:isRefresh:error:)]) {
                                   [self.delegate tradeHistoryDidFetch:self data:data last:(currentPage >= totalPage) isRefresh:(currentPage <= 1) error:nil];
                               }
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               self.request = nil;
                               
                               if ([self.delegate respondsToSelector:@selector(tradeHistoryDidFetch:data:last:isRefresh:error:)]) {
                                   [self.delegate tradeHistoryDidFetch:self data:nil last:YES isRefresh:(self.pageIndex <= 1) error:error];
                               }
                           }];
}

@end
