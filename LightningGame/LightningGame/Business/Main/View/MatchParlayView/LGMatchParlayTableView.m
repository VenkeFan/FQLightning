//
//  LGMatchParlayTableView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchParlayTableView.h"
#import "LGMatchListKeys.h"
#import "LGMatchParlayKeyboard.h"
#import "LGMatchParlayTopView.h"
#import "LGMatchParlayBottomView.h"

NSString * const kMatchParlayTableViewRemoveItemNotif = @"kMatchParlayTableViewRemoveItemNotif";
NSString * const kMatchParlayTableViewRemoveAllItemsNotif = @"kMatchParlayTableViewRemoveAllItemsNotif";

NSString * const kMatchParlayCellReuseID = @"LGMatchParlayTableViewCell";

@interface LGMatchParlayTableView () <UITableViewDelegate, UITableViewDataSource, LGMatchParlayTableViewCellDelegate> {
    NSIndexPath *_keyboardIndexPath;
}

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong, readwrite) UITableView *tableView;

@end

@implementation LGMatchParlayTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _keyboardIndexPath = nil;
        self.backgroundColor = kMarqueeBgColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}

- (void)dealloc {
    
}

#pragma mark - Public

- (BOOL)addTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic matchName:(NSString *)matchName {
    if (!teamDic || !oddsDic) {
        return NO;
    }
    
    for (int i = 0; i < self.itemArray.count; i++) {
        NSMutableDictionary *dicM = self.itemArray[i];
        NSDictionary *tmpTeam = dicM[kLGMatchParlayTableViewCellKeyTeamDic];
        NSDictionary *tmpOdds = dicM[kLGMatchParlayTableViewCellKeyOddsDic];
        NSString *tmpMatchName = dicM[kLGMatchParlayTableViewCellKeyMatchName];
        
        if ([tmpTeam[kMatchTeamKeyMatchID] isEqual:teamDic[kMatchTeamKeyMatchID]] &&
            [tmpOdds[kMatchOddsKeyOddsID] isEqual:oddsDic[kMatchOddsKeyOddsID]] &&
            [tmpMatchName isEqual:matchName]) {
            return NO;
        }
    }
    
    NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithObjectsAndKeys:teamDic, kLGMatchParlayTableViewCellKeyTeamDic, oddsDic, kLGMatchParlayTableViewCellKeyOddsDic, matchName, kLGMatchParlayTableViewCellKeyMatchName, nil];
    [[self mutableArrayValueForKey:@"itemArray"] addObject:dicM];
    
    if (self.itemArray.count == 1) {
        [self.tableView reloadData];
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.itemArray.count - 1) inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self p_updateTableViewHeight];
    
    return YES;
}

- (BOOL)removeTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic matchName:(NSString *)matchName {
    if (!teamDic || !oddsDic) {
        return NO;
    }
    
    for (int i = 0; i < self.itemArray.count; i++) {
        NSMutableDictionary *dicM = self.itemArray[i];
        NSDictionary *tmpTeam = dicM[kLGMatchParlayTableViewCellKeyTeamDic];
        NSDictionary *tmpOdds = dicM[kLGMatchParlayTableViewCellKeyOddsDic];
        NSString *tmpMatchName = dicM[kLGMatchParlayTableViewCellKeyMatchName];
        
        if ([tmpTeam[kMatchTeamKeyMatchID] isEqual:teamDic[kMatchTeamKeyMatchID]] &&
            [tmpOdds[kMatchOddsKeyOddsID] isEqual:oddsDic[kMatchOddsKeyOddsID]] &&
            [tmpMatchName isEqual:matchName]) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self p_removeItemWithIndexPath:indexPath];
            
            return YES;
        }
    }
    
    return NO;
}

- (void)clearAll {
    NSMutableArray *oddsArrayM = [NSMutableArray array];
    [self.itemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [oddsArrayM addObject:[obj objectForKey:kLGMatchParlayTableViewCellKeyOddsDic]];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMatchParlayTableViewRemoveAllItemsNotif object:oddsArrayM];
    
    [[self mutableArrayValueForKey:@"itemArray"] removeAllObjects];
    _keyboardIndexPath = nil;
    if ([self.delegate respondsToSelector:@selector(matchParlayTableViewDidClear:)]) {
        [self.delegate matchParlayTableViewDidClear:self];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.itemArray[indexPath.row];
    if ([dic[kLGMatchParlayTableViewCellKeyFieldFocused] boolValue] == YES) {
        return kLGMatchParlayTableViewCellHeight + kLGMatchParlayKeyboardHeight;
    }
    
    return kLGMatchParlayTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGMatchParlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMatchParlayCellReuseID];
    cell.delegate = self;
    [cell setDataDic:self.itemArray[indexPath.row]];
    return cell;
}

#pragma mark - LGMatchParlayTableViewCellDelegate

- (void)matchParlayTableCellDidDeleted:(LGMatchParlayTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self p_removeItemWithIndexPath:indexPath];
}

- (void)matchParlayTableCellKeyboardWillShow:(LGMatchParlayTableViewCell *)cell {
    NSIndexPath *preIndexPath = _keyboardIndexPath;
    if (_keyboardIndexPath) {
        if (_keyboardIndexPath && _keyboardIndexPath.row < self.itemArray.count) {
            NSMutableDictionary *dicM = self.itemArray[_keyboardIndexPath.row];
            [dicM setObject:@(NO) forKey:kLGMatchParlayTableViewCellKeyFieldFocused];
            _keyboardIndexPath = nil;
        }
    }
    
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath && indexPath.row < self.itemArray.count) {
        NSMutableDictionary *dicM = self.itemArray[indexPath.row];
        [dicM setObject:@(YES) forKey:kLGMatchParlayTableViewCellKeyFieldFocused];
        
        if (preIndexPath) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath, preIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        _keyboardIndexPath = indexPath;
        [self p_updateTableViewHeight];
    }
}

- (void)matchParlayTableCellKeyboardWillHide:(LGMatchParlayTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath && indexPath.row < self.itemArray.count) {
        NSMutableDictionary *dicM = self.itemArray[indexPath.row];
        [dicM setObject:@(NO) forKey:kLGMatchParlayTableViewCellKeyFieldFocused];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        _keyboardIndexPath = nil;
        [self p_updateTableViewHeight];
    }
}

- (void)matchParlayTableCellOnTapped:(LGMatchParlayTableViewCell *)cell {
    LGMatchParlayTableViewCell *keyboardCell = [self.tableView cellForRowAtIndexPath:_keyboardIndexPath];
    [self matchParlayTableCellKeyboardWillHide:keyboardCell];
}

- (void)matchParlayTableCellDidBetting:(LGMatchParlayTableViewCell *)cell {
    __block CGFloat totalBet = 0;
    __block CGFloat totalGain = 0;
    
    
    for (NSDictionary *dic in self.itemArray) {
        CGFloat ante = [dic[kLGMatchParlayTableViewCellKeyAnte] floatValue];
        if (ante <= 0) {
            continue;
        }
        
        CGFloat gain = ante * [dic[kLGMatchParlayTableViewCellKeyOddsDic][kMatchOddsKeyOdds] floatValue];
        
        totalBet += ante;
        totalGain += gain;
    }
    
    if (totalGain > 0 && [self.delegate respondsToSelector:@selector(matchParlayTableViewDidBetting:totalBet:totalGain:)]) {
        [self.delegate matchParlayTableViewDidBetting:self totalBet:totalBet totalGain:totalGain];
    }
}

#pragma mark - Private

- (void)p_removeItemWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.itemArray.count) {
        if ([indexPath compare:_keyboardIndexPath] == NSOrderedSame) {
            _keyboardIndexPath = nil;
        }
        
        NSMutableDictionary *dicM = self.itemArray[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMatchParlayTableViewRemoveItemNotif object:dicM[kLGMatchParlayTableViewCellKeyOddsDic]];
        
        [[self mutableArrayValueForKey:@"itemArray"] removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        if (self.itemArray.count > 0) {
            [self p_updateTableViewHeight];
        } else {
            [self clearAll];
        }
    }
}

- (void)p_updateTableViewHeight {
    CGFloat height = kLGMatchParlayTableViewCellHeight * self.itemArray.count;
    if (_keyboardIndexPath) {
        height += kLGMatchParlayKeyboardHeight;
    }
    
    if (height > kScreenHeight - kNavBarHeight - kLGMatchParlayViewTopHeight - kLGMatchParlayViewBottomHeight) {
        height = kScreenHeight - kNavBarHeight - kLGMatchParlayViewTopHeight - kLGMatchParlayViewBottomHeight;
    }
    
    if ([self.delegate respondsToSelector:@selector(matchParlayTableViewHeightDidChanged:newHeight:)]) {
        [self.delegate matchParlayTableViewHeightDidChanged:self newHeight:height];
    }
}

#pragma mark - Getter

- (NSUInteger)itemCount {
    return self.itemArray.count;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = kMarqueeBgColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[LGMatchParlayTableViewCell class] forCellReuseIdentifier:kMatchParlayCellReuseID];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    return _tableView;
}

@end
