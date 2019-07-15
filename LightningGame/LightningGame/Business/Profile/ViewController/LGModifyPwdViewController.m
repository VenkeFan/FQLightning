//
//  LGModifyPwdViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGModifyPwdViewController.h"
#import "LGUserManager.h"
#import "LGSignFieldView.h"

@interface LGModifyPwdViewController ()

@property (nonatomic, strong) LGUserManager *manager;
@property (nonatomic, weak) UITextField *pwdOldField;
@property (nonatomic, weak) UITextField *pwdNewField;
@property (nonatomic, weak) UITextField *pwdConfirmField;

@end

@implementation LGModifyPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"setup_modify_pwd");
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfOnTapped)];
    [self.view addGestureRecognizer:tap];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(0, scrollView.height + 1);
    [self.view addSubview:scrollView];
    
    UIView *contentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = kCellBgColor;
        view.frame = scrollView.bounds;
        
        CGFloat titleLabWidth = kSizeScale(54.0);
        CGFloat paddingY = kSizeScale(14.0);
        CGFloat centerX = view.width * 0.5, centerY = 0;
        CGFloat btnFontSize = kSizeScale(16.0);
        CGFloat btnHeight = kSizeScale(36.0);
        
        LGSignFieldView *oldPwdView = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"setup_pwd_old")
                                                              placeholder:kLocalizedString(@"sign_pwd_placeholder")
                                                                    field:&_pwdOldField
                                                               titleWidth:titleLabWidth
                                                                    isPwd:YES];
        oldPwdView.center = CGPointMake(centerX, oldPwdView.height * 0.5 + paddingY);
        [view addSubview:oldPwdView];
        centerY = (CGRectGetMaxY(oldPwdView.frame) + oldPwdView.height * 0.5 + paddingY);
        
        LGSignFieldView *newPwdView = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_pwd_new")
                                                                 placeholder:kLocalizedString(@"sign_pwd_placeholder")
                                                                       field:&_pwdNewField
                                                                  titleWidth:titleLabWidth
                                                                       isPwd:YES];
        newPwdView.center = CGPointMake(centerX, centerY);
        [view addSubview:newPwdView];
        centerY = (CGRectGetMaxY(newPwdView.frame) + newPwdView.height * 0.5 + paddingY);
        
        LGSignFieldView *pwd2View = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_pwd_confirm")
                                                               placeholder:kLocalizedString(@"sign_pwd_placeholder")
                                                                     field:&_pwdConfirmField
                                                                titleWidth:titleLabWidth
                                                                     isPwd:YES];
        pwd2View.center = CGPointMake(centerX, centerY);
        [view addSubview:pwd2View];
        centerY += (pwd2View.height + paddingY);
        
        UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        modifyBtn.backgroundColor = kMainOnTintColor;
        modifyBtn.frame = CGRectMake(0, 0, oldPwdView.width, btnHeight);
        modifyBtn.center = CGPointMake(centerX, centerY);
        modifyBtn.layer.cornerRadius = kCornerRadius;
        [modifyBtn setTitle:kLocalizedString(@"setup_modify_pwd") forState:UIControlStateNormal];
        [modifyBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
        modifyBtn.titleLabel.font = kRegularFont(btnFontSize);
        [modifyBtn addTarget:self action:@selector(modifyBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:modifyBtn];
        
        view;
    });
    [scrollView addSubview:contentView];
}

- (void)modifyBtnOnClicked {
    [self.view endEditing:YES];
    
}

- (void)selfOnTapped {
    [self.view endEditing:YES];
}

#pragma mark - Getter

- (LGUserManager *)manager {
    if (_manager) {
        _manager = [LGUserManager new];
    }
    return _manager;
}

@end
