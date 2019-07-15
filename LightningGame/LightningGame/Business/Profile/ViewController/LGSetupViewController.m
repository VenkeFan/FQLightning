//
//  LGSetupViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGSetupViewController.h"
#import "LGProfileViewCell.h"

static NSString * const kSetupCellReuseID = @"kSetupCellReuseID";

@interface LGSetupViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray<NSArray *> *itemArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LGSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"profile_setup");
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(kCellMarginX, kNavBarHeight, kScreenWidth - kCellMarginX * 2, kScreenHeight - kNavBarHeight - kCellMarginY)];
    _tableView.backgroundColor = kCellBgColor;
    _tableView.layer.cornerRadius = kCornerRadius;
    _tableView.layer.masksToBounds = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = kSizeScale(42.0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[LGProfileViewCell class] forCellReuseIdentifier:kSetupCellReuseID];
    [self.view addSubview:_tableView];
    
    
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
    LGProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSetupCellReuseID];
    [cell setItemDic:self.itemArray[indexPath.section][indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemDic = self.itemArray[indexPath.section][indexPath.row];
    
    if (![itemDic[kProfileItemAccessoryTypeKey] boolValue]) {
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

#pragma mark - Getter

- (NSArray<NSArray *> *)itemArray {
    if (!_itemArray) {
        _itemArray = @[
                       @[
                           @{kProfileItemTitleKey: kLocalizedString(@"setup_real_name"),
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeNone),
                             kProfileItemAccessoryInfoKey: [[LGAccountManager instance] account][kAccountKeyAccountRealName] ?: [[LGAccountManager instance] account][kAccountKeyAccountUserName],
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"setup_real_identify"),
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeNone),
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"setup_birthday"),
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeDatePicker),
                             kProfileItemAccessoryInfoKey: [[LGAccountManager instance] account][kAccountKeyAccountBirthday],
                             kProfileItemClassKey: @""
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"setup_modify_mobile"),
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeDisclosureIndicator),
                             kProfileItemAccessoryInfoKey: [[LGAccountManager instance] account][kAccountKeyAccountMobile],
                             kProfileItemClassKey: @""
                             },
                           @{kProfileItemTitleKey: kLocalizedString(@"setup_modify_pwd"),
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeDisclosureIndicator),
                             kProfileItemClassKey: @""
                             },
                           ],
                       @[
                           @{kProfileItemTitleKey: kLocalizedString(@"setup_unlocked"),
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeSwitchButton),
                             }
                           ],
                       @[
                           @{kProfileItemTitleKey: kLocalizedString(@"setup_signout"),
                             kProfileItemAccessoryTypeKey: @(LGProfileViewCellAccessoryTypeNone),
                             }
                           ]
                       ];
    }
    return _itemArray;
}

@end
