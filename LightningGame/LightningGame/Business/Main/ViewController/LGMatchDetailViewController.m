//
//  LGMatchDetailViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/28.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchDetailViewController.h"
#import "LGMatchDetailViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import "FQSegmentedControl.h"
#import "LGMatchDetailHeaderView.h"
#import "LGMatchDetailTableViewCell.h"
#import "LGMatchParlayTableView.h"

#define kLGMatchDetailHeaderContentHeight           kSizeScale(148.0)
#define kLGMatchDetailHeaderPlayererHeight          kSizeScale(270.0)

static NSString * const kMatchDetailOddsReuseID = @"LGMatchDetailTableViewCell";
static CGFloat const kDetailViewEdgeAll = kSizeScale(8.0);

@interface LGMatchDetailViewController () <LGMatchDetailViewModelDelegate, FQSegmentedControlDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *matchID;

@property (nonatomic, strong) LGMatchDetailViewModel *viewModel;
@property (nonatomic, strong) NSMutableDictionary *matchDicM;
@property (nonatomic, copy) NSArray *teamArrayI;
@property (nonatomic, strong) NSMutableDictionary *oddsDicM;

@property (nonatomic, strong) UIView *topContentView;
@property (nonatomic, strong) LGMatchDetailHeaderView *headerView;

@property (nonatomic, strong) UIView *oddsContentView;
@property (nonatomic, strong) FQSegmentedControl *segmentedCtr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, NSNumber *> *cellHeightDicM;

@end

@implementation LGMatchDetailViewController

- (instancetype)initWithMatchID:(NSString *)matchID {
    if (self = [super init]) {
        _matchID = [matchID copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"detail_title");
    
    [self addNotification];
    
    [self initializeTopView];
    [self initializeOddsContentView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initializeTopView {
    _topContentView = [[UIView alloc] init];
    _topContentView.frame = CGRectMake(kDetailViewEdgeAll, kNavBarHeight, self.view.width - kDetailViewEdgeAll * 2, kLGMatchDetailHeaderContentHeight);
    _topContentView.backgroundColor = kCellBgColor;
    _topContentView.layer.cornerRadius = kCornerRadius;
    _topContentView.layer.masksToBounds = YES;
    [self.view addSubview:_topContentView];
    
    _headerView = [[LGMatchDetailHeaderView alloc] init];
    _headerView.frame = _topContentView.bounds;
    _headerView.backgroundColor = [UIColor clearColor];
    [_topContentView addSubview:_headerView];
}

- (void)initializeOddsContentView {
    _oddsContentView = [[UIView alloc] init];
    _oddsContentView.frame = CGRectMake(kDetailViewEdgeAll, CGRectGetMaxY(_topContentView.frame) + kDetailViewEdgeAll, self.view.width - kDetailViewEdgeAll * 2, self.view.height - CGRectGetMaxY(_topContentView.frame) - kDetailViewEdgeAll * 2 - kSafeAreaBottomY);
    _oddsContentView.backgroundColor = kCellBgColor;
    _oddsContentView.layer.cornerRadius = kCornerRadius;
    _oddsContentView.layer.masksToBounds = YES;
    [self.view addSubview:_oddsContentView];
    
    _segmentedCtr = ({
        FQSegmentedControl *seg = [[FQSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, _oddsContentView.width, kSegmentHeight)];
        seg.backgroundColor = kCellBgColor;
        seg.currentIndex = 0;
        seg.delegate = self;
        seg.markLineColor = kMainOnTintColor;
        seg.hSeparateLineColor = kMarqueeBgColor;
        
        seg;
    });
    [_oddsContentView addSubview:_segmentedCtr];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentedCtr.frame), _oddsContentView.width, _oddsContentView.height - CGRectGetMaxY(_segmentedCtr.frame)) style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[LGMatchDetailTableViewCell class] forCellReuseIdentifier:kMatchDetailOddsReuseID];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(beginRefresh)];
//        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//        [header setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
//        [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        tableView.mj_header = header;
        
        tableView;
    });
    [_oddsContentView addSubview:_tableView];
}

#pragma mark - Network

- (void)beginRefresh {
    [self.viewModel fetchDataWithMatchID:self.matchID];
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
    NSDictionary *notiOddsDic = notification.object;
    __block NSIndexPath *indexPath = nil;
    
//    for (int i = 0; i < self.oddsDicM.allKeys.count; i++) {
//        NSArray *stageArray = [self.oddsDicM objectForKey:self.oddsDicM.allKeys[i]];
//
//        for (int j = 0; j < stageArray.count; j++) {
//            NSArray *groupArray = stageArray[j];
//
//            for (int k = 0; k < groupArray.count; k++) {
//                NSMutableDictionary *tmpOdds = groupArray[k];
//
//                if ([tmpOdds[kMatchOddsKeyOddsID] isEqual:oddsDic[kMatchOddsKeyOddsID]]) {
//                    [tmpOdds setObject:@(NO) forKey:kMatchOddsExoticKeyIsSelected];
//
//                    indexPath = [NSIndexPath indexPathForRow:j inSection:i];
//                    break;
//                }
//            }
//        }
//    }
    
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
    NSArray *notiOddsArray = notification.object;
    NSMutableArray<NSIndexPath *> *indexPathArray = [NSMutableArray array];
    
//    for (int i = 0; i < self.oddsDicM.allKeys.count; i++) {
//        NSArray *stageArray = [self.oddsDicM objectForKey:self.oddsDicM.allKeys[i]];
//
//        for (int j = 0; j < stageArray.count; j++) {
//            NSArray *groupArray = stageArray[j];
//
//            for (int k = 0; k < groupArray.count; k++) {
//                NSMutableDictionary *tmpOdds = groupArray[k];
//
//                for (int l = 0; l < notiOddsArray.count; l++) {
//                    NSDictionary *notiOdds = notiOddsArray[l];
//
//                    if ([tmpOdds[kMatchOddsKeyOddsID] isEqual:notiOdds[kMatchOddsKeyOddsID]]) {
//                        [tmpOdds setObject:@(NO) forKey:kMatchOddsExoticKeyIsSelected];
//
//                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
//                        [indexPathArray addObject:indexPath];
//                    }
//                }
//            }
//        }
//    }
    
    [self traversalOddsDicM:^(NSInteger section, NSInteger row, NSMutableDictionary *oddsDic, BOOL *stop) {
        for (int l = 0; l < notiOddsArray.count; l++) {
            NSDictionary *notiOdds = notiOddsArray[l];
            
            if ([oddsDic[kMatchOddsKeyOddsID] isEqual:notiOdds[kMatchOddsKeyOddsID]]) {
                [oddsDic setObject:@(NO) forKey:kMatchOddsExoticKeyIsSelected];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                [indexPathArray addObject:indexPath];
            }
        }
    }];
    
    if (indexPathArray.count > 0) {
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)traversalOddsDicM:(void(^)(NSInteger section, NSInteger row, NSMutableDictionary *oddsDic, BOOL *stop))block {
    BOOL finished = NO;
    for (int i = 0; i < self.oddsDicM.allKeys.count; i++) {
        NSArray *stageArray = [self.oddsDicM objectForKey:self.oddsDicM.allKeys[i]];
        
        for (int j = 0; j < stageArray.count; j++) {
            NSArray *groupArray = stageArray[j];
            
            for (int k = 0; k < groupArray.count; k++) {
                NSMutableDictionary *tmpOdds = groupArray[k];
                
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

#pragma mark - LGMatchDetailViewModelDelegate

- (void)matchDetailDidFetch:(LGMatchDetailViewModel *)viewModel
                   matchDic:(NSMutableDictionary *)matchDic
                  teamArray:(NSArray *)teamArray
                    oddsDic:(NSMutableDictionary *)oddsDic
                    errCode:(NSInteger)errCode {
    [self.tableView.mj_header endRefreshing];
    
    self.matchDicM = matchDic;
    self.teamArrayI = teamArray;
    self.oddsDicM = oddsDic;
    
    [self.headerView setDataDic:self.matchDicM];
    
    NSMutableArray *stageArray = [NSMutableArray arrayWithCapacity:self.oddsDicM.allKeys.count];
    [self.oddsDicM.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [stageArray addObject:[LGMatchDetailViewModel matchStage:obj]];
    }];
    [self.segmentedCtr setItems:stageArray];
    
    
    [self.tableView reloadData];
}

#pragma mark - FQSegmentedControlDelegate

- (void)segmentedControl:(FQSegmentedControl *)control didSelectedIndex:(NSInteger)index preIndex:(NSInteger)preIndex {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.oddsDicM.allKeys.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForHeaderInSection:section]);
    view.backgroundColor = kCellBgColor;
    
    UIView *line = [UIView new];
    line.backgroundColor = kMainBgColor;
    line.frame = CGRectMake(0, 0, view.width - kSizeScale(54.0) * 2, kSizeScale(2.0));
    line.center = CGPointMake(view.width * 0.5, view.height * 0.5);;
    [view addSubview:line];
    
    UILabel *lab = [UILabel new];
    lab.backgroundColor = kCellBgColor;
    lab.font = kRegularFont(kNameFontSize);
    lab.textColor = kNameFontColor;
    lab.text = [LGMatchDetailViewModel matchStage:self.oddsDicM.allKeys[section]];
    lab.textAlignment = NSTextAlignmentCenter;
    [lab sizeToFit];
    lab.width += kSizeScale(12.0);
    lab.center = CGPointMake(view.width * 0.5, view.height * 0.5);
    [view addSubview:lab];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSizeScale(40.0);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.oddsDicM objectForKey:self.oddsDicM.allKeys[section]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.cellHeightDicM objectForKey:indexPath] floatValue] > 0) {
        return [[self.cellHeightDicM objectForKey:indexPath] floatValue];
    }
    
    CGFloat height = [LGMatchDetailTableViewCell cellHeight:[[self.oddsDicM objectForKey:self.oddsDicM.allKeys[indexPath.section]] objectAtIndex:indexPath.row]];
    [self.cellHeightDicM setObject:@(height) forKey:indexPath];
    
    return height;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGMatchDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMatchDetailOddsReuseID];
    [cell setMatchDic:self.matchDicM
            teamArray:self.teamArrayI
            oddsArray:[[self.oddsDicM objectForKey:self.oddsDicM.allKeys[indexPath.section]] objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    [self.segmentedCtr setCurrentIndex:section];
}

#pragma mark - Getter

- (LGMatchDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [LGMatchDetailViewModel new];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

- (NSMutableDictionary<NSIndexPath *, NSNumber *> *)cellHeightDicM {
    if (!_cellHeightDicM) {
        _cellHeightDicM = [NSMutableDictionary dictionary];
    }
    return _cellHeightDicM;
}

@end
