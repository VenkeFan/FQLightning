//
//  LGUserBankListView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGUserBankListView.h"
#import "LGUserManager.h"
#import "LGAddCardViewController.h"

@protocol LGUserBankListCellDelegate <NSObject>

- (void)userBankListCellDidDeleted:(NSDictionary *)itemDic;

@end

@interface LGUserBankListCell : UITableViewCell

@property (nonatomic, copy) NSDictionary *itemDic;
@property (nonatomic, weak) id<LGUserBankListCellDelegate> delegate;

@end

@implementation LGUserBankListCell {
    UIImageView *_logoView;
    UILabel *_nameLab;
    UIButton *_deleteBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self initializeUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _logoView.center = CGPointMake(kCellMarginX + _logoView.width * 0.5, self.contentView.height * 0.5);
    
    _nameLab.center = CGPointMake(CGRectGetMaxX(_logoView.frame) + 4.0 + _nameLab.width * 0.5, self.contentView.height * 0.5);
    
    _deleteBtn.center = CGPointMake(self.contentView.width - kCellMarginX - _deleteBtn.width * 0.5, self.contentView.height * 0.5);
}

- (void)initializeUI {
    _logoView = [UIImageView new];
    _logoView.frame = CGRectMake(0, 0, kSizeScale(20.0), kSizeScale(20.0));
    _logoView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_logoView];
    
    _nameLab = [UILabel new];
    _nameLab.textColor = kScoreFontColor;
    _nameLab.font = kRegularFont(kFieldFontSize);
    [self.contentView addSubview:_nameLab];
    
//    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_deleteBtn setImage:[UIImage imageNamed:@"tjtkk_ljt"] forState:UIControlStateNormal];
//    [_deleteBtn sizeToFit];
//    [_deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_deleteBtn];
}

- (void)setItemDic:(NSDictionary *)itemDic {
    _itemDic = [itemDic copy];
    
    [_logoView fq_setImageWithURLString:itemDic[kCardKeyLogo]];
    
    _nameLab.text = [NSString stringWithFormat:@"%@ (%@)", itemDic[kCardKeyName], [itemDic[kCardKeyNumber] substringWithRange:NSMakeRange(0, 4)]];
    [_nameLab sizeToFit];
}

- (void)deleteBtnClicked {
    if ([self.delegate respondsToSelector:@selector(userBankListCellDidDeleted:)]) {
        [self.delegate userBankListCellDidDeleted:self.itemDic];
    }
}

@end


static NSString * const kUserBankListCellReuseID = @"kUserBankListCellReuseID";

@interface LGUserBankListView () <UITableViewDelegate, UITableViewDataSource, LGUserBankListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LGUserBankListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.position = FQAlertViewPopPositionBottom;
        
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI {
    self.containerView.backgroundColor = kCellBgColor;
    self.containerView.height = kSizeScale(300.0);
    
    self.titleView = ({
        UILabel *lab = [UILabel new];
        lab.text = kLocalizedString(@"card_selection");
        lab.textColor = kUIColorFromRGB(0x000000);
        lab.font = kRegularFont(kFieldFontSize);
        [lab sizeToFit];
        
        lab;
    });
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.containerView.width, self.containerView.height - CGRectGetMaxY(self.topView.frame))];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[LGUserBankListCell class] forCellReuseIdentifier:kUserBankListCellReuseID];
    _tableView.rowHeight = kSizeScale(45.0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.containerView addSubview:_tableView];
    
    [[LGUserManager manager] fetchUserBankListWithCompleted:^(BOOL result) {
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"使用新卡提现" forState:UIControlStateNormal];
    [btn setTitleColor:kNameFontColor forState:UIControlStateNormal];
    btn.titleLabel.font = kRegularFont(kTinyFontSize);
    btn.frame = CGRectMake(kCellMarginX, 0, 0, 0);
    [btn sizeToFit];
    [btn addTarget:self action:@selector(addNewCardBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LGUserManager manager].cardArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGUserBankListCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserBankListCellReuseID];
    cell.delegate = self;
    [cell setItemDic:[LGUserManager manager].cardArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(userBankListViewDidSelected:)]) {
        [self.delegate userBankListViewDidSelected:[LGUserManager manager].cardArray[indexPath.row]];
    }
}

#pragma mark - LGUserBankListCellDelegate

- (void)userBankListCellDidDeleted:(NSDictionary *)itemDic {
    
}

#pragma mark - Events

- (void)addNewCardBtnClicked {
    [super dismiss];
    
    [[FQWindowUtility currentViewController].navigationController pushViewController:[LGAddCardViewController new] animated:YES];
}

@end
