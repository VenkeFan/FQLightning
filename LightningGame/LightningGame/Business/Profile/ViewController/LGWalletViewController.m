//
//  LGWalletViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/12.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGWalletViewController.h"
#import <Masonry/Masonry.h>
#import "LGAddCardViewController.h"
#import "LGWithdrawViewController.h"
#import "LGUserManager.h"

@interface LGWalletViewController ()

@end

@implementation LGWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"profile_wallet");
    
    [self initializeUI];
}

- (void)initializeUI {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(kCellMarginX, kNavBarHeight, kScreenWidth - kCellMarginX * 2, kSizeScale(148))];
    headerView.backgroundColor = kMarqueeBgColor;
    headerView.layer.cornerRadius = kCornerRadius;
    headerView.layer.masksToBounds = YES;
    [self.view addSubview:headerView];
    
    UIView *titleView = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(kCellMarginX, kCellMarginY, headerView.width - kCellMarginX * 2, kSizeScale(24.0));
        view.backgroundColor = kCellBgColor;
        view.layer.cornerRadius = kCornerRadius;
        view.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewOnTapped)];
        [view addGestureRecognizer:tap];
        
        UIImageView *iconView = [UIImageView new];
        iconView.image = [UIImage imageNamed:@"cz_jyjl"];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        [iconView sizeToFit];
        iconView.center = CGPointMake(kCellMarginX + iconView.width * 0.5, view.height * 0.5);
        [view addSubview:iconView];
        
        UILabel *lab = [UILabel new];
        lab.text = kLocalizedString(@"profile_deal_history");
        lab.textColor = kNameFontColor;
        lab.font = kRegularFont(kFieldFontSize);
        [lab sizeToFit];
        lab.center = CGPointMake(kCellMarginX + CGRectGetMaxX(iconView.frame) + lab.width * 0.5, view.height * 0.5);
        [view addSubview:lab];
        
        UIImageView *accessoryImgView = [UIImageView new];
        accessoryImgView.contentMode = UIViewContentModeScaleAspectFit;
        accessoryImgView.image = [UIImage imageNamed:@"nav_back"];
        accessoryImgView.transform = CGAffineTransformMakeRotation(M_PI);
        [accessoryImgView sizeToFit];
        accessoryImgView.center = CGPointMake(view.width - kCellMarginX - accessoryImgView.width * 0.5, view.height * 0.5);
        [view addSubview:accessoryImgView];
        
        view;
    });
    [headerView addSubview:titleView];
    
    UIView *tmpView = ({
        UIView *view = [UIView new];
        
        CGFloat paddingY = kSizeScale(6.0);
        
        UILabel *lab = [UILabel new];
        lab.text = [NSString stringWithFormat:@"%@%@", kLocalizedString(@"profile_wallet"), kLocalizedString(@"profile_balance")];
        lab.textColor = kMainOnTintColor;
        lab.font = kRegularFont(kFieldFontSize);
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view);
            make.centerX.mas_equalTo(view);
        }];
        
        UILabel *balanceLab = [UILabel new];
        balanceLab.text = [NSString stringWithFormat:@"¥ %@", [[LGAccountManager instance] account][kAccountKeyAccountMoney]];
        balanceLab.textColor = kScoreFontColor;
        balanceLab.font = kRegularFont(kScoreFontSize);
        [view addSubview:balanceLab];
        [balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lab.mas_bottom).offset(paddingY);
            make.centerX.mas_equalTo(lab);
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = kCellBgColor;
        [btn setTitle:kLocalizedString(@"wallet_withdraw") forState:UIControlStateNormal];
        [btn setTitleColor:kMainOnTintColor forState:UIControlStateNormal];
        btn.titleLabel.font = kRegularFont(kNoteFontSize);
        btn.layer.cornerRadius = kSizeScale(3.0);
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = kMainOnTintColor.CGColor;
        btn.layer.borderWidth = 1.0;
        [btn addTarget:self action:@selector(withdrawBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(balanceLab.mas_bottom).offset(paddingY);
            make.centerX.mas_equalTo(balanceLab);
            make.size.mas_equalTo(CGSizeMake(kSizeScale(80.0), kSizeScale(24.0)));
            make.bottom.mas_equalTo(view.mas_bottom);
        }];
        
        view;
    });
    [headerView addSubview:tmpView];
    [tmpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeScale(200.0));
        make.centerX.mas_equalTo(headerView);
        make.centerY.mas_equalTo(headerView).offset(CGRectGetMaxY(titleView.frame) * 0.5);
    }];
}

#pragma mark - Events

- (void)titleViewOnTapped {
    
}

- (void)withdrawBtnClicked {
    [[LGUserManager manager] fetchUserBankListWithCompleted:^(BOOL result) {
        if (result) {
            LGWithdrawViewController *ctr = [LGWithdrawViewController new];
            [self.navigationController pushViewController:ctr animated:YES];
        } else {
            LGAddCardViewController *ctr = [LGAddCardViewController new];
            [self.navigationController pushViewController:ctr animated:YES];
        }
        
    }];
}

@end
