//
//  LGSignInViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/31.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGSignInViewController.h"
#import "LGSignUpViewController.h"
#import "LGForgetPwdViewController.h"
#import "LGSignFieldView.h"
#import "LGSignFlowManager.h"
#import "CTMediator+LGMainActions.h"

@interface LGSignInViewController () <LGSignFlowManagerDelegate>

@property (nonatomic, weak) UITextField *accountField;
@property (nonatomic, weak) UITextField *pwdField;

@end

@implementation LGSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navBar.hidden = YES;
    
    self.view.layer.contentsScale = kScreenScale;
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"sign_bg"].CGImage;
    self.view.layer.contentsGravity = kCAGravityResizeAspectFill;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfOnTapped)];
    [self.view addGestureRecognizer:tap];
    
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

- (void)initializeUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(0, scrollView.height + 1);
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:scrollView];
    
    UIColor *placeholderColor = kPlaceholderColor;
    UIFont *fieldFont = kRegularFont(kFieldFontSize);
    
    CGFloat titleLabWidth = kSizeScale(27.0);
    CGFloat paddingY = kSizeScale(14.0);
    CGFloat centerX = self.view.width * 0.5, centerY = 0;
    CGFloat btnFontSize = kSizeScale(16.0);
    CGFloat btnHeight = kSizeScale(36.0);
    
    LGSignFieldView *accountView = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_account")
                                                              placeholder:kLocalizedString(@"sign_account_placeholder")
                                                                    field:&_accountField
                                                               titleWidth:titleLabWidth];
    accountView.center = CGPointMake(centerX, self.view.height * 0.5 - paddingY * 2);
    [scrollView addSubview:accountView];
    centerY = (CGRectGetMaxY(accountView.frame) + accountView.height * 0.5 + paddingY);
    
    LGSignFieldView *pwdView = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_pwd")
                                                          placeholder:kLocalizedString(@"sign_pwd_placeholder")
                                                                field:&_pwdField
                                                           titleWidth:titleLabWidth
                                                                isPwd:YES];
    pwdView.center = CGPointMake(accountView.centerX, centerY);
    [scrollView addSubview:pwdView];
    centerY += (pwdView.height);
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.backgroundColor = [UIColor clearColor];
    [forgetBtn setTitle:kLocalizedString(@"sign_forget_pwd") forState:UIControlStateNormal];
    [forgetBtn setTitleColor:placeholderColor forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = fieldFont;
    [forgetBtn sizeToFit];
    forgetBtn.center = CGPointMake(CGRectGetMaxX(pwdView.frame) - forgetBtn.width * 0.5, centerY);
    [forgetBtn addTarget:self action:@selector(forgetBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:forgetBtn];
    centerY += (forgetBtn.height + kSizeScale(34));
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = kMainOnTintColor;
    loginBtn.frame = CGRectMake(0, 0, pwdView.width, btnHeight);
    loginBtn.center = CGPointMake(centerX, centerY);
    loginBtn.layer.cornerRadius = kCornerRadius;
    [loginBtn setTitle:kLocalizedString(@"sign_in") forState:UIControlStateNormal];
    [loginBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = kRegularFont(btnFontSize);
    [loginBtn addTarget:self action:@selector(loginBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:loginBtn];
    centerY += (loginBtn.height + paddingY);
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.backgroundColor = kMarqueeBgColor;
    registerBtn.frame = loginBtn.bounds;
    registerBtn.center = CGPointMake(loginBtn.centerX, centerY);
    registerBtn.layer.cornerRadius = loginBtn.layer.cornerRadius;
    [registerBtn setTitle:kLocalizedString(@"sign_up") forState:UIControlStateNormal];
    [registerBtn setTitleColor:kMainOnTintColor forState:UIControlStateNormal];
    registerBtn.titleLabel.font = loginBtn.titleLabel.font;
    [registerBtn addTarget:self action:@selector(registerBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:registerBtn];
    centerY = (CGRectGetMaxY(registerBtn.frame) + kSizeScale(34));
    
    UIButton *visitorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString *strAttr = [[NSAttributedString alloc] initWithString:kLocalizedString(@"sign_visitor")
                                                                  attributes:@{NSForegroundColorAttributeName: placeholderColor,
                                                                               NSFontAttributeName: fieldFont,
                                                                               NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlineStylePatternSolid),
                                                                               NSUnderlineColorAttributeName: placeholderColor}];
    
    visitorBtn.backgroundColor = [UIColor clearColor];
    [visitorBtn setAttributedTitle:strAttr forState:UIControlStateNormal];
    [visitorBtn sizeToFit];
    visitorBtn.center = CGPointMake(loginBtn.centerX, centerY);
    [visitorBtn addTarget:self action:@selector(visitorBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:visitorBtn];
}

#pragma mark - LGSignFlowManagerDelegate

- (void)signFlowManagerStepping:(LGSignFlowStep)step {
    switch (step) {
        case LGSignFlowStep_Home: {
            UIViewController *mainCtr = [[CTMediator sharedInstance] mediator_generateMainController];
            [self.navigationController setViewControllers:@[mainCtr] animated:NO];
        }
            break;
        default:
            break;
    }
}

- (void)signFlowManagerFailed:(NSError *)error {
    
}

#pragma mark - Events

- (void)pwdFieldRightBtnClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    self.pwdField.secureTextEntry = !sender.isSelected;
}

- (void)forgetBtnOnClicked {
    [self.view endEditing:YES];
    
    LGForgetPwdViewController *ctr = [LGForgetPwdViewController new];
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)loginBtnOnClicked {
    [self.view endEditing:YES];
    
    if (![LGSignFlowManager proofreadAccountName:self.accountField.text]) {
        return;
    }
    if (![LGSignFlowManager proofreadPassword:self.pwdField.text]) {
        return;
    }
    [[LGSignFlowManager instance] signInWithAccountName:self.accountField.text pwd:self.pwdField.text];
}

- (void)registerBtnOnClicked {
    [self.view endEditing:YES];
    
    LGSignUpViewController *ctr = [LGSignUpViewController new];
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)visitorBtnOnClicked {
    [self.view endEditing:YES];
    
    [[LGSignFlowManager instance] visit];
}

- (void)selfOnTapped {
    [self.view endEditing:YES];
}

@end
