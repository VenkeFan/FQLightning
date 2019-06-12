//
//  LGTournamentListView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGTournamentListView.h"
#import <MJRefresh/MJRefresh.h>
#import "LGTournamentListViewCell.h"
#import "LGMarqueeView.h"
#import "LGDatePickerView.h"
#import "LGDatePickerTableView.h"
#import "LGMatchParlayTableView.h"
#import "LGMatchDetailViewController.h"

static NSString * const kTournamentCellReuseID = @"LGTournamentListViewCell";

@interface LGTournamentListView () <LGTournamentListManagerDelegate, LGDatePickerViewDelegate, LGDatePickerTableViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    BOOL _isLoaded;
}

@property (nonatomic, strong) LGTournamentListManager *manager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) LGMarqueeView *marqueeView;
@property (nonatomic, strong) LGDatePickerView *datePickerView;
@property (nonatomic, strong) LGDatePickerTableView *dateTableView;

@end

@implementation LGTournamentListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isLoaded = NO;
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[LGTournamentListViewCell class] forCellReuseIdentifier:kTournamentCellReuseID];
        _tableView.rowHeight = kLGTournamentListViewCellHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(beginRefresh)];
//        [header setTitle:@"下拉加载更多" forState:MJRefreshStateIdle];
//        [header setTitle:@"下拉加载更多" forState:MJRefreshStatePulling];
//        [header setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _tableView.mj_header = header;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(matchParlayDidRemoveItemNotif:)
                                                     name:kMatchParlayTableViewRemoveItemNotif
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(matchParlayDidRemoveAllItemsNotif:)
                                                     name:kMatchParlayTableViewRemoveAllItemsNotif
                                                   object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _tableView.frame = self.bounds;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self.manager fetchData];
}

- (void)loadMore {
    [self.manager loadMoreData];
}

#pragma mark - LGTournamentListManagerDelegate

- (void)managerDidFetch:(LGTournamentListManager *)manager data:(NSArray *)data last:(BOOL)last errCode:(NSInteger)errCode {
    [self.tableView.mj_header endRefreshing];
    
    if (data.count == 0) {
        return;
    }
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:data];
    
    [self.tableView reloadData];
}

- (void)managerDidMore:(LGTournamentListManager *)manager data:(NSArray *)data last:(BOOL)last errCode:(NSInteger)errCode {
    if (data.count == 0) {
        return;
    }
    
    [self.dataArray addObjectsFromArray:data];
}

#pragma mark - LGDatePickerViewDelegate

- (void)datePickerViewDidClickedDate:(LGDatePickerView *)view {
    self.dateTableView.viewModel = view.viewModel;
    [self.dateTableView displayInParentView:self];
}

#pragma mark - LGDatePickerTableViewDelegate

- (void)datePickerTableView:(LGDatePickerTableView *)view didSelectIndex:(NSUInteger)index {
    [self.datePickerView setIndex:index];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = kMainBgColor;
    
    if (self.listType == LGTournamentListType_Today || self.listType == LGTournamentListType_Rolling) {
        self.marqueeView.frame = CGRectMake(kCellMarginX, kCellMarginY, kScreenWidth - kCellMarginX * 2, kMarqueeViewHeight);
        [view addSubview:self.marqueeView];
        [self.marqueeView fetchData];
        
    } else {
        self.datePickerView.frame = CGRectMake(kCellMarginX, kCellMarginY, kScreenWidth - kCellMarginX * 2, kDatePickerViewHeight);
        [view addSubview:self.datePickerView];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kCellMarginY * 2 + kMarqueeViewHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGTournamentListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTournamentCellReuseID];
    [cell setDataDic:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    LGMatchDetailViewController *ctr = [[LGMatchDetailViewController alloc] initWithMatchID:dic[kTournamentListKeyID]];
    [FQWindowUtility.currentViewController.navigationController pushViewController:ctr animated:YES];
}

#pragma mark - Notification

- (void)matchParlayDidRemoveItemNotif:(NSNotification *)notification {
    NSDictionary *oddsDic = notification.object;
    for (int i = 0; i < self.dataArray.count; i++) {
        NSArray *oddsArray = [self.dataArray[i] objectForKey:kTournamentListKeyOdds];
        if (oddsArray) {
            for (int j = 0; j < oddsArray.count; j++) {
                NSMutableDictionary *tmpOdds = oddsArray[j];
                if ([tmpOdds[kTournamentOddsKeyOddsID] isEqual:oddsDic[kTournamentOddsKeyOddsID]]) {
                    [tmpOdds setObject:@(NO) forKey:kTournamentOddsExoticKeyIsSelected];
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    }
}

- (void)matchParlayDidRemoveAllItemsNotif:(NSNotification *)notification {
    NSArray *notiOddsArray = notification.object;
    for (int i = 0; i < self.dataArray.count; i++) {
        NSArray *oddsArray = [self.dataArray[i] objectForKey:kTournamentListKeyOdds];
        if (!oddsArray) {
            continue;
        }
        
        for (int j = 0; j < oddsArray.count; j++) {
            NSMutableDictionary *tmpOdds = oddsArray[j];
            
            for (int k = 0; k < notiOddsArray.count; k++) {
                NSDictionary *notiOdds = notiOddsArray[k];
                
                if ([tmpOdds[kTournamentOddsKeyOddsID] isEqual:notiOdds[kTournamentOddsKeyOddsID]]) {
                    [tmpOdds setObject:@(NO) forKey:kTournamentOddsExoticKeyIsSelected];
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    }
}

#pragma mark - Private

- (void)addFooter {
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

- (void)removeFooter {
    self.tableView.mj_footer = nil;
}

#pragma mark - Getter

- (LGTournamentListManager *)manager {
    if (!_manager) {
        _manager = [LGTournamentListManager new];
        _manager.delegate = self;
        _manager.listType = _listType;
    }
    return _manager;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (LGMarqueeView *)marqueeView {
    if (!_marqueeView) {
        _marqueeView = [[LGMarqueeView alloc] initWithFrame:CGRectZero];
    }
    return _marqueeView;
}

- (LGDatePickerView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[LGDatePickerView alloc] initWithFrame:CGRectZero];
        _datePickerView.delegate = self;
        _datePickerView.previously = (self.listType == LGTournamentListType_Finished);
    }
    return _datePickerView;
}

- (LGDatePickerTableView *)dateTableView {
    if (!_dateTableView) {
        _dateTableView = [LGDatePickerTableView new];
        _dateTableView.delegate = self;
    }
    return _dateTableView;
}

@end
