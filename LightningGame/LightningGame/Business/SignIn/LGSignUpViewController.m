//
//  LGSignUpViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/31.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGSignUpViewController.h"
#import "FQComponentFactory.h"
#import "LGServiceButton.h"
#import "LGSignFieldView.h"

#define kLGSignUpHeaderHeight               kSizeScale(166.0)

@interface LGSignUpViewController () <UITextFieldDelegate>

@property (nonatomic, weak) UITextField *accountField;
@property (nonatomic, weak) UITextField *pwdField;
@property (nonatomic, weak) UITextField *pwdConfirmField;
@property (nonatomic, weak) UITextField *nameField;
@property (nonatomic, weak) UITextField *mobileField;
@property (nonatomic, weak) UITextField *verifyField;
@property (nonatomic, weak) UITextField *recommendField;
@property (nonatomic, strong) UIButton *getVerifyBtn;

@end

@implementation LGSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfOnTapped)];
    [self.view addGestureRecognizer:tap];
    
    [self layoutNavigationBar];
    [self initializeUI];
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
        view.frame = CGRectMake(0, 0, self.view.width, kLGSignUpHeaderHeight);
        
        UILabel *lab = [FQComponentFactory labelWithFont:kRegularFont(kHeaderFontSize)];
        lab.text = kLocalizedString(@"sign_up");
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
        
        LGSignFieldView *accountView = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_account")
                                                                  placeholder:kLocalizedString(@"sign_account_placeholder")
                                                                        field:&_accountField
                                                                   titleWidth:titleLabWidth];
        accountView.center = CGPointMake(centerX, accountView.height * 0.5 + paddingY);
        [view addSubview:accountView];
        centerY = (CGRectGetMaxY(accountView.frame) + accountView.height * 0.5 + paddingY);
        
        LGSignFieldView *pwdView = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_pwd")
                                                              placeholder:kLocalizedString(@"sign_pwd_placeholder")
                                                                    field:&_pwdField
                                                               titleWidth:titleLabWidth
                                                                    isPwd:YES];
        pwdView.txtField.delegate = self;
        pwdView.center = CGPointMake(centerX, centerY);
        [view addSubview:pwdView];
        centerY += (pwdView.height + paddingY);
        
        LGSignFieldView *pwd2View = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_pwd_confirm")
                                                               placeholder:kLocalizedString(@"sign_pwd_placeholder")
                                                                     field:&_pwdConfirmField
                                                                titleWidth:titleLabWidth
                                                                     isPwd:YES];
        pwd2View.txtField.delegate = self;
        pwd2View.center = CGPointMake(centerX, centerY);
        [view addSubview:pwd2View];
        centerY += (pwd2View.height + paddingY);
        
        LGSignFieldView *nameView = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_name")
                                                               placeholder:kLocalizedString(@"sign_name_placeholder")
                                                                     field:&_nameField
                                                                titleWidth:titleLabWidth];
        nameView.txtField.delegate = self;
        nameView.center = CGPointMake(centerX, centerY);
        [view addSubview:nameView];
        centerY += (nameView.height + paddingY);
        
        LGSignFieldView *mobileView = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_mobile")
                                                                 placeholder:kLocalizedString(@"sign_mobile_place")
                                                                       field:&_mobileField
                                                                  titleWidth:titleLabWidth];
        mobileView.txtField.delegate = self;
        mobileView.txtField.keyboardType = UIKeyboardTypePhonePad;
        mobileView.center = CGPointMake(centerX, centerY);
        [view addSubview:mobileView];
        centerY += (mobileView.height + paddingY);
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
            [mobileView addSubview:btn];
        }
        
        LGSignFieldView *verifyView = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_verify")
                                                                 placeholder:kLocalizedString(@"sign_verify_place")
                                                                       field:&_verifyField
                                                                  titleWidth:titleLabWidth];
        verifyView.txtField.delegate = self;
        verifyView.center = CGPointMake(centerX, centerY);
        [view addSubview:verifyView];
        centerY += (verifyView.height + paddingY);
        
        LGSignFieldView *recommendView = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_recommend")
                                                                    placeholder:kLocalizedString(@"sign_recommend_place")
                                                                          field:&_recommendField
                                                                     titleWidth:titleLabWidth];
        recommendView.txtField.delegate = self;
        recommendView.center = CGPointMake(centerX, centerY);
        [view addSubview:recommendView];
        centerY += (recommendView.height + paddingY * 2);
        
        UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registerBtn.backgroundColor = kMainOnTintColor;
        registerBtn.frame = CGRectMake(0, 0, accountView.width, btnHeight);
        registerBtn.center = CGPointMake(centerX, centerY);
        registerBtn.layer.cornerRadius = kCornerRadius;
        [registerBtn setTitle:kLocalizedString(@"sign_up_confirm") forState:UIControlStateNormal];
        [registerBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
        registerBtn.titleLabel.font = kRegularFont(btnFontSize);
        [registerBtn addTarget:self action:@selector(registerBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:registerBtn];
        
        view;
    });
    [scrollView addSubview:contentView];
}

#pragma mark - Events

- (void)registerBtnOnClicked {
    [self.view endEditing:YES];
}

- (void)selfOnTapped {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

@end
