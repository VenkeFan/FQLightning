//
//  LGProfileViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/10.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGProfileViewController.h"
#import "FQImageButton.h"
#import "NSDate+FQExtension.h"
#import "FQSystemUtility.h"

static NSString * const kProfileCellReuseID = @"kProfileCellReuseID";

NSString * const kProfileItemTitleKey = @"kProfileItemTitleKey";
NSString * const kProfileItemBadgeKey = @"kProfileItemBadgeKey";
NSString * const kProfileItemIconKey = @"kProfileItemIconKey";
NSString * const kProfileItemAccessoryInfoKey = @"kProfileItemAccessoryInfoKey";
NSString * const kProfileItemHasAccessoryKey = @"kProfileItemHasAccessoryKey";
NSString * const kProfileItemClassKey = @"kProfileItemClassKey";

@interface LGProfileViewCell : UITableViewCell

@property (nonatomic, copy) NSDictionary *itemDic;

@end

@implementation LGProfileViewCell {
    UIView *_containerView;
    UIImageView *_iconImgView;
    UILabel *_titleLab;
    UILabel *_badgeLab;
    UILabel *_accessoryLab;
    UIImageView *_accessoryImgView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _containerView = [UIView new];
        _containerView.backgroundColor = kMainBgColor;
        _containerView.layer.cornerRadius = kCornerRadius;
        _containerView.layer.masksToBounds = YES;
        [self.contentView addSubview:_containerView];
        
        _iconImgView = [UIImageView new];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_containerView addSubview:_iconImgView];
        
        _titleLab = [UILabel new];
        _titleLab.textColor = kNameFontColor;
        _titleLab.font = kRegularFont(kNoteFontSize);
        [_containerView addSubview:_titleLab];
        
        _badgeLab = [UILabel new];
        _badgeLab.hidden = YES;
        _badgeLab.backgroundColor = kRedColor;
        _badgeLab.textColor = [UIColor blackColor];
        _badgeLab.font = kRegularFont(kNoteFontSize);
        _badgeLab.textAlignment = NSTextAlignmentCenter;
        [_containerView addSubview:_badgeLab];
        
        _accessoryLab = [UILabel new];
        _accessoryLab.textColor = kNameFontColor;
        _accessoryLab.font = kRegularFont(kNoteFontSize);
        [_containerView addSubview:_accessoryLab];
        
        _accessoryImgView = [UIImageView new];
        _accessoryImgView.contentMode = UIViewContentModeScaleAspectFit;
        _accessoryImgView.image = [UIImage imageNamed:@"nav_back"];
        _accessoryImgView.transform = CGAffineTransformMakeRotation(M_PI);
        [_accessoryImgView sizeToFit];
        [_containerView addSubview:_accessoryImgView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _containerView.frame = CGRectMake(kCellMarginX, kCellMarginY, self.width - kCellMarginX * 2, self.height - kCellMarginY);
    
    CGFloat centerY = _containerView.height * 0.5;
    
    _iconImgView.center = CGPointMake(kCellMarginX + _iconImgView.width * 0.5, centerY);
    _titleLab.center = CGPointMake(kCellMarginX + CGRectGetMaxX(_iconImgView.frame) + _titleLab.width * 0.5, centerY);
    _badgeLab.center = CGPointMake(kCellMarginX + CGRectGetMaxX(_titleLab.frame) + _badgeLab.width * 0.5, centerY);
    
    if (!_accessoryImgView.hidden) {
        _accessoryImgView.center = CGPointMake(_containerView.width - kCellMarginX - _accessoryImgView.width * 0.5, centerY);
        _accessoryLab.center = CGPointMake(CGRectGetMinX(_accessoryImgView.frame) - kCellMarginX - _accessoryLab.width * 0.5, centerY);
    } else {
        _accessoryLab.center = CGPointMake(_containerView.width - kCellMarginX - _accessoryLab.width * 0.5, centerY);
    }
}

- (void)setItemDic:(NSDictionary *)itemDic {
    _itemDic = [itemDic copy];
    
    _iconImgView.image = [UIImage imageNamed:itemDic[kProfileItemIconKey]];
    [_iconImgView sizeToFit];
    
    _titleLab.text = itemDic[kProfileItemTitleKey];
    [_titleLab sizeToFit];
    
    NSInteger badge = [itemDic[kProfileItemBadgeKey] integerValue];
    if (badge > 0) {
        _badgeLab.hidden = NO;
        _badgeLab.text = [NSString stringWithFormat:@"%ld", badge];
        [_badgeLab sizeToFit];
        _badgeLab.width += 12;
        _badgeLab.height += 2;
        
        _badgeLab.layer.cornerRadius = _badgeLab.height * 0.5;
        _badgeLab.layer.masksToBounds = YES;
    } else {
        _badgeLab.hidden = YES;
    }
    
    BOOL hasAccessory = [itemDic[kProfileItemHasAccessoryKey] boolValue];
    _accessoryImgView.hidden = !hasAccessory;
    
    _accessoryLab.text = itemDic[kProfileItemAccessoryInfoKey];
    [_accessoryLab sizeToFit];
}

@end


@interface LGProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray<NSArray *> *itemArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) FQImageButton *setupBtn;

@end

@implementation LGProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"profile_title");
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(kCellMarginX, kNavBarHeight, kScreenWidth - kCellMarginX * 2, kScreenHeight - kNavBarHeight - kCellMarginY)];
    _tableView.backgroundColor = kCellBgColor;
    _tableView.layer.cornerRadius = kCornerRadius;
    _tableView.layer.masksToBounds = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = kSizeScale(42.0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[LGProfileViewCell class] forCellReuseIdentifier:kProfileCellReuseID];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, kSizeScale(62.0))];
        view.backgroundColor = kMarqueeBgColor;
        
        _nameLab = [UILabel new];
        _nameLab.textAlignment = NSTextAlignmentLeft;
        _nameLab.numberOfLines = 2;
        [view addSubview:_nameLab];
        
        NSString *greet = @"";
        NSDate *date = [NSDate date];
        if (date.hour >= 18) {
            greet = @"晚上好\n";
        } else if (date.hour >= 12) {
            greet = @"下午好\n";
        } else {
            greet = @"早上好\n";
        }
        
        NSString *name = [[LGAccountManager instance].account objectForKey:kAccountKeyAccountUserName];
        NSMutableString *strM = [NSMutableString stringWithFormat:@"%@%@", greet, name];
        NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:strM];
        [strAttr addAttributes:@{NSForegroundColorAttributeName: kNameFontColor} range:NSMakeRange(0, strM.length)];
        [strAttr addAttributes:@{NSFontAttributeName: kRegularFont(kTinyFontSize)} range:NSMakeRange(0, greet.length)];
        [strAttr addAttributes:@{NSFontAttributeName: kRegularFont(kNameFontSize)} range:NSMakeRange(greet.length, strM.length - greet.length)];
        
        _nameLab.attributedText = strAttr;
        [_nameLab sizeToFit];
        _nameLab.center = CGPointMake(kCellMarginX + _nameLab.width * 0.5, view.height * 0.5);
        
        _setupBtn = [FQImageButton buttonWithType:UIButtonTypeCustom];
        _setupBtn.imageOrientation = FQImageButtonOrientation_Right;
        [_setupBtn setImage:[UIImage imageNamed:@"grsz_sz"] forState:UIControlStateNormal];
        _setupBtn.imageView.contentMode = UIViewContentModeCenter;
        [_setupBtn setTitle:kLocalizedString(@"profile_setup") forState:UIControlStateNormal];
        [_setupBtn setTitleColor:kMainOnTintColor forState:UIControlStateNormal];
        _setupBtn.titleLabel.font = kRegularFont(kNoteFontSize);
        _setupBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kSizeScale(4.0), 0, 0);
        [_setupBtn addTarget:self action:@selector(setupBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_setupBtn sizeToFit];
        _setupBtn.center = CGPointMake(view.width - kCellMarginX - _setupBtn.width * 0.5, view.height * 0.5);
        [view addSubview:_setupBtn];
        
        view;
    });
    
    [_tableView addSubview:({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -kScreenHeight, _tableView.width, kScreenHeight)];
        view.backgroundColor = kMarqueeBgColor;
        
        view;
    })];
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSizeScale(28.0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileCellReuseID];
    [cell setItemDic:self.itemArray[indexPath.section][indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemDic = self.itemArray[indexPath.section][indexPath.row];
    
    if (![itemDic[kProfileItemHasAccessoryKey] boolValue]) {
        return;
    }
    
    NSString *clsName = itemDic[kProfileItemClassKey];
    if (!clsName) {
        return;
    }
    
    UIViewController *ctr = [NSClassFromString(clsName) new];
    if (![ctr isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    [self.navigationController pushViewController:ctr animated:YES];
}


#pragma mark - Events

- (void)setupBtnClicked {
    
}

#pragma mark - Getter

- (NSArray<NSArray *> *)itemArray {
    if (!_itemArray) {
        _itemArray = @[
                       @[
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_wallet"),
                             kProfileItemBadgeKey: @(0),
                             kProfileItemIconKey: @"grsz_qb",
                             kProfileItemAccessoryInfoKey: [NSString stringWithFormat:@"%@: %@", kLocalizedString(@"profile_balance"),
                                                            [[LGAccountManager instance] account][kAccountKeyAccountMoney] ?: @""],
                             kProfileItemHasAccessoryKey: @(YES),
                             kProfileItemClassKey: @"LGWalletViewController"
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_agency"),
                             kProfileItemBadgeKey: @(0),
                             kProfileItemIconKey: @"grsz_dl",
                             kProfileItemHasAccessoryKey: @(YES),
                             kProfileItemClassKey: @"LGWalletViewController"
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_share"),
                             kProfileItemBadgeKey: @(0),
                             kProfileItemIconKey: @"grsz_fx",
                             kProfileItemHasAccessoryKey: @(YES),
                             kProfileItemClassKey: @"LGWalletViewController"
                             }
                         ],
                       @[
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_bet_history"),
                             kProfileItemBadgeKey: @(10),
                             kProfileItemIconKey: @"grsz_tzjl",
                             kProfileItemHasAccessoryKey: @(YES),
                             kProfileItemClassKey: @"LGParlayHistoryViewController"
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_msg"),
                             kProfileItemBadgeKey: @(20),
                             kProfileItemIconKey: @"grsz_xx",
                             kProfileItemHasAccessoryKey: @(YES),
                             kProfileItemClassKey: @"LGWalletViewController"
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_activity"),
                             kProfileItemBadgeKey: @(3),
                             kProfileItemIconKey: @"grsz_hd",
                             kProfileItemHasAccessoryKey: @(YES),
                             kProfileItemClassKey: @"LGWalletViewController"
                             }
                         ],
                       @[
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_rule"),
                             kProfileItemBadgeKey: @(0),
                             kProfileItemIconKey: @"grsz_wfgz",
                             kProfileItemHasAccessoryKey: @(YES),
                             kProfileItemClassKey: @"LGRuleViewController"
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_about"),
                             kProfileItemBadgeKey: @(0),
                             kProfileItemIconKey: @"grsz_gy",
                             kProfileItemHasAccessoryKey: @(YES),
                             kProfileItemClassKey: @"LGWalletViewController"
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_version"),
                             kProfileItemBadgeKey: @(0),
                             kProfileItemIconKey: @"grsz_bb",
                             kProfileItemAccessoryInfoKey: [FQSystemUtility appVersion],
                             kProfileItemHasAccessoryKey: @(NO)}
                           ]
                       ];
    }
    return _itemArray;
}

@end
