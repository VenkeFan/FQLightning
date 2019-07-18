//
//  LGMatchListView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchListView.h"
#import <MJRefresh/MJRefresh.h>
#import "LGMatchListPrepareCell.h"
#import "LGMatchListTodayCell.h"
#import "LGMatchListRollingCell.h"
#import "LGMatchListFinishedCell.h"
#import "LGMarqueeView.h"
#import "LGDatePickerView.h"
#import "LGDatePickerTableView.h"
#import "LGMatchParlayTableView.h"
#import "LGMatchDetailViewController.h"
#import "LGGameListKeys.h"

static NSString * const kMatchPrepareCellReuseID = @"kMatchPrepareCellReuseID";
static NSString * const kMatchTodayCellReuseID = @"kMatchTodayCellReuseID";
static NSString * const kMatchRollingCellReuseID = @"kMatchRollingCellReuseID";
static NSString * const kMatchFinishedCellReuseID = @"kMatchFinishedCellReuseID";

@interface LGMatchListView () <LGMatchListViewModelDelegate, LGDatePickerViewDelegate, LGDatePickerTableViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    BOOL _isAutoScrolling;
}

@property (nonatomic, strong) LGMatchListViewModel *viewModel;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray *> *dataDic;
@property (nonatomic, copy) NSArray<NSString *> *sortedKeys;

@property (nonatomic, strong) LGMarqueeView *marqueeView;
@property (nonatomic, strong) LGDatePickerView *datePickerView;
@property (nonatomic, strong) LGDatePickerTableView *dateTableView;

@end

@implementation LGMatchListView

@synthesize loaded;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.loaded = NO;
        _isAutoScrolling = NO;
        
        _headerView = [UIView new];
        _headerView.backgroundColor = kMainBgColor;
        [self addSubview:_headerView];
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, kLGMatchListBasicCellHeight * 0.5, 0);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[LGMatchListPrepareCell class] forCellReuseIdentifier:kMatchPrepareCellReuseID];
        [_tableView registerClass:[LGMatchListTodayCell class] forCellReuseIdentifier:kMatchTodayCellReuseID];
        [_tableView registerClass:[LGMatchListRollingCell class] forCellReuseIdentifier:kMatchRollingCellReuseID];
        [_tableView registerClass:[LGMatchListFinishedCell class] forCellReuseIdentifier:kMatchFinishedCellReuseID];
        _tableView.rowHeight = kLGMatchListBasicCellHeight;
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
        
        [self addNotification];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _headerView.frame = CGRectMake(0, 0, self.width, kCellMarginY * 2 + kMarqueeViewHeight);
    _tableView.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame), self.width, self.height - CGRectGetMaxY(_headerView.frame));
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public

- (void)setListType:(LGMatchListType)listType {
    _listType = listType;
    
    if (self.listType == LGMatchListType_Today || self.listType == LGMatchListType_Rolling) {
        self.marqueeView.frame = CGRectMake(kCellMarginX, kCellMarginY, kScreenWidth - kCellMarginX * 2, kMarqueeViewHeight);
        [self.headerView addSubview:self.marqueeView];
    } else {
        self.datePickerView.frame = CGRectMake(kCellMarginX, kCellMarginY, kScreenWidth - kCellMarginX * 2, kDatePickerViewHeight);
        [self.headerView addSubview:self.datePickerView];
    }
}

- (void)setFilterGameIDDic:(NSDictionary *)filterGameIDDic {
    _filterGameIDDic = filterGameIDDic;
    
//    NSArray *filteredItemArray = [self p_filterData:filterGameIDDic data:self.dataArray];
//    [self p_handleData:filteredItemArray];
    
    self.viewModel.gameIDArray = filterGameIDDic.allKeys;
    [self beginRefresh];
}

- (void)display {
    if (!self.isLoaded) {
        self.loaded = YES;
        
        [self.marqueeView fetchData];
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

#pragma mark - LGMatchListViewModelDelegate

- (void)matchListDidFetch:(LGMatchListViewModel *)manager data:(NSArray *)data last:(BOOL)last isRefresh:(BOOL)isRefresh error:(nullable NSError *)error {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (error) {
        return;
    }
    
    if (isRefresh) {
        [self.dataArray removeAllObjects];
    }
    
    [self.dataArray addObjectsFromArray:data];
    
    last ? [self p_removeFooter] : [self p_addFooter];
    
//    NSArray *filteredItemArray = [self p_filterData:self.filterGameIDDic data:self.dataArray];
//    [self p_handleData:filteredItemArray];
    
    [self p_handleData:self.dataArray];
}

#pragma mark - LGDatePickerViewDelegate

- (void)datePickerViewDidClickedDate:(LGDatePickerView *)view {
    [self.dateTableView displayInParentView:self];
}

- (void)datePickerViewDidChanged:(LGDatePickerView *)view newIndex:(NSUInteger)newIndex {
    if (newIndex >= 0 && newIndex < self.sortedKeys.count) {
        _isAutoScrolling = YES;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:newIndex];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - LGDatePickerTableViewDelegate

- (void)datePickerTableView:(LGDatePickerTableView *)view didSelectIndex:(NSUInteger)index {
    if (index >= 0 && index < self.sortedKeys.count) {
        _isAutoScrolling = YES;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

        [self.datePickerView.viewModel setCurrentIndex:index];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortedKeys.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataDic objectForKey:self.sortedKeys[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGMatchListBasicCell *cell;
    switch (self.listType) {
        case LGMatchListType_Today: {
            cell = [tableView dequeueReusableCellWithIdentifier:kMatchTodayCellReuseID];
        }
            break;
        case LGMatchListType_Rolling: {
            cell = [tableView dequeueReusableCellWithIdentifier:kMatchRollingCellReuseID];
        }
            break;
        case LGMatchListType_Prepare: {
            cell = [tableView dequeueReusableCellWithIdentifier:kMatchPrepareCellReuseID];
        }
            break;
        case LGMatchListType_Finished: {
            cell = [tableView dequeueReusableCellWithIdentifier:kMatchFinishedCellReuseID];
        }
            break;
    }
    if (!cell) {
        cell = [[LGMatchListTodayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMatchTodayCellReuseID];
    }
    [cell setDataDic:[self.dataDic objectForKey:self.sortedKeys[indexPath.section]][indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataDic objectForKey:self.sortedKeys[indexPath.section]][indexPath.row];
    
    LGMatchDetailViewController *ctr = [[LGMatchDetailViewController alloc] initWithMatchID:dic[kMatchKeyID]];
    [FQWindowUtility.currentViewController.navigationController pushViewController:ctr animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isAutoScrolling) {
        return;
    }
    LGMatchListBasicCell *cell = self.tableView.visibleCells.firstObject;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section != self.datePickerView.viewModel.currentIndex) {
        [self.datePickerView.viewModel setCurrentIndex:indexPath.section];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _isAutoScrolling = NO;
}

#pragma mark - Notification

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(matchParlayDidRemoveItemNotif:)
                                                 name:kMatchParlayTableViewRemoveItemNotif
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(matchParlayDidRemoveAllItemsNotif:)
                                                 name:kMatchParlayTableViewRemoveAllItemsNotif
                                               object:nil];
}

- (void)matchParlayDidRemoveItemNotif:(NSNotification *)notification {
//    NSDictionary *oddsDic = notification.object;
//    for (int i = 0; i < self.dataArray.count; i++) {
//        NSArray *oddsArray = [self.dataArray[i] objectForKey:kMatchKeyOddsArray];
//        if (oddsArray) {
//            for (int j = 0; j < oddsArray.count; j++) {
//                NSMutableDictionary *tmpOdds = oddsArray[j];
//                if ([tmpOdds[kMatchOddsKeyOddsID] isEqual:oddsDic[kMatchOddsKeyOddsID]]) {
//                    [tmpOdds setObject:@(NO) forKey:kMatchOddsExoticKeyIsSelected];
//
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                }
//            }
//        }
//    }
    
    NSDictionary *notiOddsDic = notification.object;
    __block NSIndexPath *indexPath = nil;
    [self traversalOddsDicM:^(NSInteger section, NSInteger row, NSMutableDictionary *oddsDic, BOOL *stop) {
        if ([oddsDic[kMatchOddsKeyOddsID] isEqual:notiOddsDic[kMatchOddsKeyOddsID]]) {
            [oddsDic setObject:@(NO) forKey:kMatchOddsExoticKeyIsSelected];
            
            indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            *stop = YES;
        }
    }];
    
    if (indexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)matchParlayDidRemoveAllItemsNotif:(NSNotification *)notification {
//    NSArray *notiOddsArray = notification.object;
//    for (int i = 0; i < self.dataArray.count; i++) {
//        NSArray *oddsArray = [self.dataArray[i] objectForKey:kMatchKeyOddsArray];
//        if (!oddsArray) {
//            continue;
//        }
//
//        for (int j = 0; j < oddsArray.count; j++) {
//            NSMutableDictionary *tmpOdds = oddsArray[j];
//
//            for (int k = 0; k < notiOddsArray.count; k++) {
//                NSDictionary *notiOdds = notiOddsArray[k];
//
//                if ([tmpOdds[kMatchOddsKeyOddsID] isEqual:notiOdds[kMatchOddsKeyOddsID]]) {
//                    [tmpOdds setObject:@(NO) forKey:kMatchOddsExoticKeyIsSelected];
//
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                }
//            }
//        }
//    }
    
    NSArray *notiOddsArray = notification.object;
    NSMutableArray<NSIndexPath *> *indexPathArray = [NSMutableArray array];
    
    [self traversalOddsDicM:^(NSInteger section, NSInteger row, NSMutableDictionary *oddsDic, BOOL *stop) {
        for (int l = 0; l < notiOddsArray.count; l++) {
            NSDictionary *notiOdds = notiOddsArray[l];
            
            if ([oddsDic[kMatchOddsKeyOddsID] isEqual:notiOdds[kMatchOddsKeyOddsID]]) {
                [oddsDic setObject:@(NO) forKey:kMatchOddsExoticKeyIsSelected];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                [indexPathArray addObject:indexPath];
                
                if (indexPathArray.count == notiOddsArray.count) {
                    *stop = YES;
                }
            }
        }
    }];
    
    if (indexPathArray.count > 0) {
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)traversalOddsDicM:(void(^)(NSInteger section, NSInteger row, NSMutableDictionary *oddsDic, BOOL *stop))block {
    BOOL finished = NO;
    for (int i = 0; i < self.sortedKeys.count; i++) {
        NSArray *matchArray = [self.dataDic objectForKey:self.sortedKeys[i]];
        
        for (int j = 0; j < matchArray.count; j++) {
            NSArray *oddsArray = [matchArray[j] objectForKey:kMatchKeyOddsArray];
            
            for (int k = 0; k < oddsArray.count; k++) {
                NSMutableDictionary *tmpOdds = oddsArray[k];
                
                if (block) {
                    block(i, j, tmpOdds, &finished);
                    
                    if (finished) {
                        break;
                    }
                }
            }
        }
    }
}

#pragma mark - Private

- (NSArray *)p_filterData:(NSDictionary *)filterGameIDDic data:(NSArray *)data {
    if (filterGameIDDic.count == 0) {
        return data;
    }
    
    if (filterGameIDDic.count == 1 && [filterGameIDDic.allKeys.firstObject isEqual:kAllGameID]) {
        return data;
    }
    
    
    NSMutableArray *filteredItemArray = [NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = obj[kMatchKeyGameID];
        if (filterGameIDDic[key]) {
            [filteredItemArray addObject:obj];
        }
    }];
    
    return filteredItemArray;
}

- (void)p_handleData:(NSArray *)data {
    [self.dataDic removeAllObjects];
    self.sortedKeys = nil;
    
    self.dataDic = [NSMutableDictionary dictionary];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [obj[kMatchKeyStartTime] substringToIndex:[obj[kMatchKeyStartTime] rangeOfString:@" "].location];
//        NSString *key = obj[kMatchKeyStartTime];
        
        if ([self.dataDic objectForKey:key]) {
            NSMutableArray *subArrayM = [self.dataDic objectForKey:key];
            [subArrayM addObject:obj];
        } else {
            NSMutableArray *subArrayM = [NSMutableArray array];
            [subArrayM addObject:obj];
            [self.dataDic setObject:subArrayM forKey:key];
        }
    }];
    
    if (self.listType == LGMatchListType_Finished) {
        self.sortedKeys = [self.dataDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2] == NSOrderedAscending;
        }];
    } else {
        self.sortedKeys = [self.dataDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2] == NSOrderedDescending;
        }];
    }
    
    [self.datePickerView.viewModel setItemArray:self.sortedKeys];
    
    [self.tableView reloadData];
}

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

- (LGMatchListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [LGMatchListViewModel new];
        _viewModel.delegate = self;
        _viewModel.listType = self.listType;
    }
    return _viewModel;
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
    }
    return _datePickerView;
}

- (LGDatePickerTableView *)dateTableView {
    if (!_dateTableView) {
        _dateTableView = [LGDatePickerTableView new];
        _dateTableView.delegate = self;
        _dateTableView.viewModel = _datePickerView.viewModel;
    }
    return _dateTableView;
}

@end
