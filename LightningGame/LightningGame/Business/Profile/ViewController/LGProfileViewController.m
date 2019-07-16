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
#import "LGProfileViewCell.h"

static NSString * const kProfileCellReuseID = @"kProfileCellReuseID";

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
    
    if ((LGProfileViewCellAccessoryType)[itemDic[kProfileItemAccessoryTypeKey] integerValue] == LGProfileViewCellAccessoryTypeNone) {
        return;
    }
    
    NSString *clsName = itemDic[kProfileItemClassKey];
    if (!clsName) {
        return;
    }
    
    id cls = [NSClassFromString(clsName) new];
    if ([cls isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:(UIViewController *)cls animated:YES];
    }
}

#pragma mark - Events

- (void)setupBtnClicked {
    UIViewController *ctr = [NSClassFromString(@"LGSetupViewController") new];
    if (![ctr isKindOfClass:[UIViewController class]]) {
        return;
    }
    [self.navigationController pushViewController:ctr animated:YES];
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
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeDisclosureIndicator),
                             kProfileItemClassKey: @"LGWalletViewController"
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_agency"),
                             kProfileItemBadgeKey: @(0),
                             kProfileItemIconKey: @"grsz_dl",
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeDisclosureIndicator),
                             kProfileItemClassKey: @""
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_share"),
                             kProfileItemBadgeKey: @(0),
                             kProfileItemIconKey: @"grsz_fx",
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeDisclosureIndicator),
                             kProfileItemClassKey: @""
                             }
                         ],
                       @[
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_bet_history"),
                             kProfileItemBadgeKey: @(10),
                             kProfileItemIconKey: @"grsz_tzjl",
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeDisclosureIndicator),
                             kProfileItemClassKey: @"LGParlayHistoryViewController"
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_msg"),
                             kProfileItemBadgeKey: @(20),
                             kProfileItemIconKey: @"grsz_xx",
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeDisclosureIndicator),
                             kProfileItemClassKey: @""
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_activity"),
                             kProfileItemBadgeKey: @(3),
                             kProfileItemIconKey: @"grsz_hd",
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeDisclosureIndicator),
                             kProfileItemClassKey: @""
                             }
                         ],
                       @[
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_rule"),
                             kProfileItemBadgeKey: @(0),
                             kProfileItemIconKey: @"grsz_wfgz",
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeDisclosureIndicator),
                             kProfileItemClassKey: @"LGRuleViewController"
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_about"),
                             kProfileItemBadgeKey: @(0),
                             kProfileItemIconKey: @"grsz_gy",
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeDisclosureIndicator),
                             kProfileItemClassKey: @""
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"profile_version"),
                             kProfileItemBadgeKey: @(0),
                             kProfileItemIconKey: @"grsz_bb",
                             kProfileItemAccessoryInfoKey: [FQSystemUtility appVersion],
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeNone)}
                           ]
                       ];
    }
    return _itemArray;
}

@end
