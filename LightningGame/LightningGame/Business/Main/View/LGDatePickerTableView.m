//
//  LGDatePickerTableView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/10.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGDatePickerTableView.h"
#import "LGDatePickerViewModel.h"

NSString * const kDatePickerCellReuseID = @"kDatePickerCellReuseID";

@interface LGDatePickerTableView () <UITableViewDelegate, UITableViewDataSource> {
    BOOL _isDisplay;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LGDatePickerTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kSizeScale(350) + kSafeAreaBottomY)]) {
        self.backgroundColor = kCellBgColor;
        
        _isDisplay = NO;
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kSizeScale(30.0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDatePickerCellReuseID];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.backgroundColor = [UIColor redColor];
        closeBtn.frame = CGRectMake(0, 0, kSizeScale(50), kSizeScale(50));
        closeBtn.center = CGPointMake(self.width * 0.5, self.height - closeBtn.height - kSafeAreaBottomY);
        [closeBtn addTarget:self action:@selector(closeBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    return self;
}

- (void)displayInParentView:(UIView *)parentView {
    if (_isDisplay) {
        return;
    }
    _isDisplay = YES;
    
    self.top = parentView.height;
    [parentView addSubview:self];
    [self.tableView reloadData];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.transform = CGAffineTransformMakeTranslation(0, -self.height);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)dismiss {
    if (!_isDisplay) {
        return;
    }
    _isDisplay = NO;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDatePickerCellReuseID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.viewModel.itemArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = kNameFontColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(datePickerTableView:didSelectIndex:)]) {
        [self.delegate datePickerTableView:self didSelectIndex:indexPath.row];
    }
    
    [self dismiss];
}

#pragma mark - Events

- (void)closeBtnOnClicked {
    [self dismiss];
}

@end
