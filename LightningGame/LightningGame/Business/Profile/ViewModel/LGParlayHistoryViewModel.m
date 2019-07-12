//
//  LGParlayHistoryViewModel.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/12.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGParlayHistoryViewModel.h"
#import "LGParlayHistoryRequest.h"

@interface LGParlayHistoryViewModel ()

@property (nonatomic, strong) LGParlayHistoryRequest *request;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation LGParlayHistoryViewModel

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
    
    _request = [LGParlayHistoryRequest new];
    
    [_request requestWithPageIndex:_pageIndex
                            status:self.orderStatus
                           success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                               self.request = nil;
                               
                               NSInteger totalPage = [responseObject[@"pages"] integerValue];
                               NSInteger currentPage = [responseObject[@"page_num"] integerValue];
                               NSArray *data = responseObject[@"records"];
                               
                               if ([self.delegate respondsToSelector:@selector(parlayHistoryDidFetch:data:last:isRefresh:error:)]) {
                                   [self.delegate parlayHistoryDidFetch:self data:data last:(currentPage >= totalPage) isRefresh:(currentPage == 1) error:nil];
                               }
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               self.request = nil;
                               
                               if ([self.delegate respondsToSelector:@selector(parlayHistoryDidFetch:data:last:isRefresh:error:)]) {
                                   [self.delegate parlayHistoryDidFetch:self data:nil last:YES isRefresh:(self.pageIndex == 1) error:error];
                               }
                           }];
}

@end
