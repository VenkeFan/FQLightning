//
//  LGParlayHistoryView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/12.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGParlayHistoryView.h"
#import <MJRefresh/MJRefresh.h>
#import "LGParlayHistoryViewModel.h"
#import "LGParlayHistoryCell.h"

static NSString * const kParlayHistoryCellReuseID = @"kParlayHistoryCellReuseID";

@interface LGParlayHistoryView () <LGParlayHistoryViewModelDelegate, UITableViewDelegate, UITableViewDataSource> {
    BOOL _isLoaded;
}

@property (nonatomic, strong) LGParlayHistoryViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LGParlayHistoryView

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isLoaded = NO;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[LGParlayHistoryCell class] forCellReuseIdentifier:kParlayHistoryCellReuseID];
        _tableView.rowHeight = kLGParlayHistoryCellHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(beginRefresh)];
        //        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        //        [header setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
        //        [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _tableView.mj_header = header;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _tableView.frame = self.bounds;
}

#pragma mark - Public

- (void)display {
    if (!_isLoaded) {
        _isLoaded = YES;
        
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - Network

- (void)beginRefresh {
    [self.viewModel fetchData];
}

- (void)loadMore {
    [self.viewModel loadMoreData];
}

#pragma mark - LGParlayHistoryViewModelDelegate

- (void)parlayHistoryDidFetch:(LGParlayHistoryViewModel *)viewModel data:(NSArray *)data last:(BOOL)last isRefresh:(BOOL)isRefresh error:(NSError *)error {
    [self.tableView.mj_header endRefreshing];
    
    if (error) {
        return;
    }
    
    if (isRefresh) {
        [self.dataArray removeAllObjects];
    }
    
    [self.dataArray addObjectsFromArray:data];
    
    last ? [self p_removeFooter] : [self p_addFooter];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGParlayHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kParlayHistoryCellReuseID];
    [cell setItemDic:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - Private

- (void)p_addFooter {
    if (!self.tableView.mj_footer) {
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self
                                                                                 refreshingAction:@selector(loadMore)];
        //        [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
        //        [footer setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
        //        [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
        footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        self.tableView.mj_footer = footer;
    }
}

- (void)p_removeFooter {
    self.tableView.mj_footer = nil;
}

#pragma mark - Getter

- (LGParlayHistoryViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [LGParlayHistoryViewModel new];
        _viewModel.delegate = self;
        _viewModel.orderStatus = self.orderStatus;
    }
    return _viewModel;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
