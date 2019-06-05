//
//  LGMatchParlayTableView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchParlayTableView.h"
#import "LGMatchParlayKeyboard.h"
#import "LGMatchParlayTopView.h"
#import "LGMatchParlayBottomView.h"

static NSString * const kMatchParlayCellReuseID = @"LGMatchParlayTableViewCell";

@interface LGMatchParlayTableView () <UITableViewDelegate, UITableViewDataSource, LGMatchParlayTableViewCellDelegate> {
    NSIndexPath *_keyboardIndexPath;
}

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) UITableView *tableView;

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

#pragma mark - Public

- (void)addTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic matchName:(NSString *)matchName {
    if (!teamDic || !oddsDic) {
        return;
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
}

- (void)clearAll {
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

- (void)matchParlayTableViewCellDidDeleted:(LGMatchParlayTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row < self.itemArray.count) {
        if ([indexPath compare:_keyboardIndexPath] == NSOrderedSame) {
            _keyboardIndexPath = nil;
        }
        
        [[self mutableArrayValueForKey:@"itemArray"] removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        if (self.itemArray.count > 0) {
            [self p_updateTableViewHeight];
        } else {
            _keyboardIndexPath = nil;
            if ([self.delegate respondsToSelector:@selector(matchParlayTableViewDidClear:)]) {
                [self.delegate matchParlayTableViewDidClear:self];
            }
        }
    }
}

- (void)matchParlayTableViewCellKeyboardWillShow:(LGMatchParlayTableViewCell *)cell {
    if (_keyboardIndexPath) {
        LGMatchParlayTableViewCell *keyboardCell = [self.tableView cellForRowAtIndexPath:_keyboardIndexPath];
        [self matchParlayTableViewCellKeyboardWillHide:keyboardCell];
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath && indexPath.row < self.itemArray.count) {
        _keyboardIndexPath = indexPath;
        
        NSMutableDictionary *dicM = self.itemArray[indexPath.row];
        [dicM setObject:@(YES) forKey:kLGMatchParlayTableViewCellKeyFieldFocused];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [self p_updateTableViewHeight];
    }
}

- (void)matchParlayTableViewCellKeyboardWillHide:(LGMatchParlayTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if (indexPath && indexPath.row < self.itemArray.count) {
        NSMutableDictionary *dicM = self.itemArray[indexPath.row];
        [dicM setObject:@(NO) forKey:kLGMatchParlayTableViewCellKeyFieldFocused];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        _keyboardIndexPath = nil;
        [self p_updateTableViewHeight];
    }
}

- (void)matchParlayTableViewCellOnTapped:(LGMatchParlayTableViewCell *)cell {
    LGMatchParlayTableViewCell *keyboardCell = [self.tableView cellForRowAtIndexPath:_keyboardIndexPath];
    [self matchParlayTableViewCellKeyboardWillHide:keyboardCell];
}

#pragma mark - Private

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
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[LGMatchParlayTableViewCell class] forCellReuseIdentifier:kMatchParlayCellReuseID];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    return _tableView;
}

@end
