//
//  LGForgetPwdViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGForgetPwdViewController.h"
#import "LGSignFlowManager.h"
#import "FQComponentFactory.h"
#import "LGServiceButton.h"
#import "LGSignFieldView.h"

#define kLGForgetHeaderHeight               kSizeScale(166.0)

@interface LGForgetPwdViewController () <LGSignFlowManagerDelegate>

@property (nonatomic, weak) UITextField *mobileField;
@property (nonatomic, weak) UITextField *verifyField;
@property (nonatomic, weak) UITextField *pwdConfirmField;

@end

@implementation LGForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfOnTapped)];
    [self.view addGestureRecognizer:tap];
    
    [self layoutNavigationBar];
    [self initializeUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[LGSignFlowManager instance] addListener:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[LGSignFlowManager instance] removeListener:self];
}

#pragma mark - UI

- (void)layoutNavigationBar {
    self.navBar.alpha = 0.0;
    
    LGServiceButton *rightBtn = [LGServiceButton new];
    rightBtn.centerX = CGRectGetWidth(self.navBar.contentView.frame) - CGRectGetWidth(rightBtn.frame) * 0.5 - kNavBarPaddingX;
    self.navBar.rightBtn = rightBtn;
}

- (void)initializeUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(0, scrollView.height + 1);
    [self.view addSubview:scrollView];
    
    UIView *header = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(0, 0, self.view.width, kLGForgetHeaderHeight);
        
        NSString *str = kLocalizedString(@"sign_forget_pwd");
        str = [str substringToIndex:str.length - 1];
        
        UILabel *lab = [FQComponentFactory labelWithFont:kRegularFont(kHeaderFontSize)];
        lab.text = str;
        lab.textColor = kMainOnTintColor;
        [lab sizeToFit];
        lab.center = CGPointMake(view.width * 0.5, view.height - kSizeScale(12.0) - lab.height * 0.5);
        [view addSubview:lab];
        
        view;
    });
    [scrollView addSubview:header];
    
    UIView *contentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = kCellBgColor;
        view.frame = CGRectMake(0, CGRectGetMaxY(header.frame), self.view.width, self.view.height - CGRectGetMaxY(header.frame));
        
        CGFloat titleLabWidth = kSizeScale(54.0);
        CGFloat paddingY = kSizeScale(14.0);
        CGFloat centerX = view.width * 0.5, centerY = 0;
        CGFloat btnFontSize = kSizeScale(16.0);
        CGFloat btnHeight = kSizeScale(36.0);
        
        LGSignFieldView *mobileView = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_mobile")
                                                                 placeholder:kLocalizedString(@"sign_mobile_place")
                                                                       field:&_mobileField
                                                                  titleWidth:titleLabWidth];
        mobileView.txtField.keyboardType = UIKeyboardTypePhonePad;
        mobileView.center = CGPointMake(centerX, mobileView.height * 0.5 + paddingY);
        [view addSubview:mobileView];
        centerY = (CGRectGetMaxY(mobileView.frame) + mobileView.height * 0.5 + paddingY);
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, kSizeScale(80), kSizeScale(24));
            btn.center = CGPointMake(mobileView.width - btn.width * 0.5, mobileView.height * 0.5);
            btn.backgroundColor = kMarqueeBgColor;
            btn.layer.borderWidth = 1.0;
            btn.layer.borderColor = kMainOnTintColor.CGColor;
            [btn setTitle:kLocalizedString(@"sign_get_verify") forState:UIControlStateNormal];
            [btn setTitleColor:kMainOnTintColor forState:UIControlStateNormal];
            btn.titleLabel.font = kRegularFont(kNoteFontSize);
            [btn addTarget:self action:@selector(verifyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [mobileView addSubview:btn];
        }
        
        LGSignFieldView *verifyView = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_verify")
                                                                 placeholder:kLocalizedString(@"sign_verify_place")
                                                                       field:&_verifyField
                                                                  titleWidth:titleLabWidth];
        verifyView.center = CGPointMake(centerX, centerY);
        [view addSubview:verifyView];
        centerY += (verifyView.height + paddingY);
        
        LGSignFieldView *pwd2View = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_pwd_new")
                                                               placeholder:kLocalizedString(@"sign_pwd_placeholder")
                                                                     field:&_pwdConfirmField
                                                                titleWidth:titleLabWidth
                                                                     isPwd:YES];
        pwd2View.center = CGPointMake(centerX, centerY);
        [view addSubview:pwd2View];
        centerY += (pwd2View.height + paddingY);
        
        UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        modifyBtn.backgroundColor = kMainOnTintColor;
        modifyBtn.frame = CGRectMake(0, 0, mobileView.width, btnHeight);
        modifyBtn.center = CGPointMake(centerX, centerY);
        modifyBtn.layer.cornerRadius = kCornerRadius;
        [modifyBtn setTitle:kLocalizedString(@"sign_pwd_update") forState:UIControlStateNormal];
        [modifyBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
        modifyBtn.titleLabel.font = kRegularFont(btnFontSize);
        [modifyBtn addTarget:self action:@selector(modifyBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:modifyBtn];
        
        view;
    });
    [scrollView addSubview:contentView];
}

#pragma mark - LGSignFlowManagerDelegate

- (void)signFlowManagerStepping:(LGSignFlowStep)step {
    switch (step) {
        case LGSignFlowStep_SignIn_Manual: {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)signFlowManagerFailed:(NSError *)error {
    
}

#pragma mark - Events

- (void)verifyBtnClicked {
    [[LGSignFlowManager instance] fetchVerifyCode:self.mobileField.text];
}

- (void)modifyBtnOnClicked {
    [self.view endEditing:YES];
    
    if (![LGSignFlowManager proofreadPassword:self.pwdConfirmField.text]) {
        return;
    }
    if (![LGSignFlowManager proofreadMobile:self.mobileField.text]) {
        return;
    }
    if (![LGSignFlowManager proofreadVerifyCode:self.verifyField.text]) {
        return;
    }
    [[LGSignFlowManager instance] modifyPassword:self.pwdConfirmField.text
                                          mobile:self.mobileField.text
                                      verifyCode:self.verifyField.text];
}

- (void)selfOnTapped {
    [self.view endEditing:YES];
}

@end
