//
//  LGBankListView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGBankListView.h"
#import "LGCardKeys.h"

@interface LGBankListCell : UITableViewCell

@property (nonatomic, copy) NSDictionary *itemDic;

@end

@implementation LGBankListCell {
    UIImageView *_logoView;
    UILabel *_nameLab;
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
    
    _nameLab.center = CGPointMake(CGRectGetMaxX(_logoView.frame) + 6.0 + _nameLab.width * 0.5, self.contentView.height * 0.5);
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
}

- (void)setItemDic:(NSDictionary *)itemDic {
    _itemDic = [itemDic copy];
    
    _logoView.image = [UIImage imageNamed:itemDic[kCardKeyLogo]];
    
    _nameLab.text = itemDic[kCardKeyName];
    [_nameLab sizeToFit];
}

@end

static NSString * const kBankListCellReuseID = @"kBankListCellReuseID";

@interface LGBankListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *itemArray;

@end

@implementation LGBankListView

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
        lab.text = @"选择提款银行";
        lab.textColor = kUIColorFromRGB(0x000000);
        lab.font = kRegularFont(kFieldFontSize);
        [lab sizeToFit];
        
        lab;
    });
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.containerView.width, self.containerView.height - CGRectGetMaxY(self.topView.frame))];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[LGBankListCell class] forCellReuseIdentifier:kBankListCellReuseID];
    _tableView.rowHeight = kSizeScale(45.0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.containerView addSubview:_tableView];
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGBankListCell *cell = [tableView dequeueReusableCellWithIdentifier:kBankListCellReuseID];
    [cell setItemDic:self.itemArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(bankListViewDidSelected:)]) {
        [self.delegate bankListViewDidSelected:self.itemArray[indexPath.row]];
    }
}

#pragma mark - Getter

- (NSArray *)itemArray {
    if (!_itemArray) {
        _itemArray = @[
                       @{kCardKeyName: @"工商银行", kCardKeyLogo: @"tjtkk_gsyh"},
                       @{kCardKeyName: @"建设银行", kCardKeyLogo: @"tjtkk_jsyh"},
                       @{kCardKeyName: @"农业银行", kCardKeyLogo: @"tjtkk_nyyh"},
                       @{kCardKeyName: @"招商银行", kCardKeyLogo: @"tjtkk_zsyh"},
                       @{kCardKeyName: @"民生银行", kCardKeyLogo: @"tjtkk_msyh"},
                       @{kCardKeyName: @"交通银行", kCardKeyLogo: @"tjtkk_jtyh"},
                       @{kCardKeyName: @"邮政储蓄银行", kCardKeyLogo: @"tjtkk_yzcxyh"},
                       @{kCardKeyName: @"中国银行", kCardKeyLogo: @"tjtkk_zgyh"},
                       @{kCardKeyName: @"兴业银行", kCardKeyLogo: @"tjtkk_xyyh"},
                       @{kCardKeyName: @"光大银行", kCardKeyLogo: @""},
                       @{kCardKeyName: @"平安银行", kCardKeyLogo: @""},
                       @{kCardKeyName: @"中信银行", kCardKeyLogo: @"tjtkk_zxyh"},
                       @{kCardKeyName: @"广东发展银行", kCardKeyLogo: @""},
                       @{kCardKeyName: @"上海浦东发展银行", kCardKeyLogo: @"tjtkk_pfyh"},
                       ];
    }
    return _itemArray;
}

@end
