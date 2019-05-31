//
//  LGSignInViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/31.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGSignInViewController.h"

@interface LGSignInViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *pwdField;

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

- (void)initializeUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(0, scrollView.height + 1);
    [self.view addSubview:scrollView];
    
    CGFloat x = kSizeScale(28), y = 0;
    CGFloat width = CGRectGetWidth(self.view.frame) - x * 2, height = kSizeScale(36.0);
    CGFloat btnPaddingY = kSizeScale(14.0);
    CGFloat btnFontSize = kSizeScale(16.0);
    CGFloat corner = 7.0;
    UIColor *placeholderColor = kUIColorFromRGB(0x4E4533);
    UIFont *fieldFont = kRegularFont(kSizeScale(13.0));
    
    UIView* (^fieldViewCreator)(NSString *, NSString *, UITextField **, BOOL) = ^(NSString *title,
                                                                                  NSString *placeholder,
                                                                                  UITextField **field,
                                                                                  BOOL isPwd) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        view.backgroundColor = [UIColor clearColor];
        
        CGFloat marginX = kSizeScale(8.0);
        CGFloat x = 0;
        CGFloat centerY = view.height * 0.5;
        
        UILabel *lab = [[UILabel alloc] init];
        lab.text = title;
        lab.textColor = kScoreFontColor;
        lab.font = fieldFont;
        [lab sizeToFit];
        lab.center = CGPointMake(lab.width * 0.5, centerY);
        [view addSubview:lab];
        x += (CGRectGetMaxX(lab.frame) + marginX);
        
        UIView *vLine = [[UIView alloc] init];
        vLine.backgroundColor = placeholderColor;
        vLine.frame = CGRectMake(0, 0, 1, lab.height + 4);
        vLine.center = CGPointMake(x, centerY);
        [view addSubview:vLine];
        x += (vLine.width + marginX);
        
        UITextField *txtField = [[UITextField alloc] init];
        txtField.delegate = self;
        txtField.backgroundColor = [UIColor clearColor];
        txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                         attributes:@{NSForegroundColorAttributeName: placeholderColor}];
        txtField.tintColor = kScoreFontColor;
        txtField.font = fieldFont;
        txtField.textColor = kScoreFontColor;
        txtField.frame = CGRectMake(x, 0, view.width - x, view.height);
        txtField.returnKeyType = UIReturnKeyDone;
        if (isPwd) {
            txtField.secureTextEntry = YES;
            txtField.rightViewMode = UITextFieldViewModeWhileEditing;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.selected = NO;
            [btn setImage:[UIImage imageNamed:@"sign_pwd_show"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"sign_pwd_hide"] forState:UIControlStateSelected];
            btn.frame = CGRectMake(0, 0, txtField.height, txtField.height);
            [btn addTarget:self action:@selector(pwdFieldRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            txtField.rightView = btn;
        }
        [view addSubview:txtField];
        *field = txtField;
        
        UIView *hLine = [[UIView alloc] init];
        hLine.backgroundColor = placeholderColor;
        hLine.frame = CGRectMake(0, view.height - 1, view.width, 1);
        [view addSubview:hLine];
        
        return view;
    };
    
    __block UITextField *nameField = nil;
    __block UITextField *pwdField = nil;
    
    UIView *nameView = fieldViewCreator(kLocalizedString(@"sign_name"), kLocalizedString(@"sign_name_placeholder"), &nameField, NO);
    UIView *pwdView = fieldViewCreator(kLocalizedString(@"sign_pwd"), kLocalizedString(@"sign_pwd_placeholder"), &pwdField, YES);
    
    if (nameField) {
        _nameField = nameField;
    }
    if (pwdField) {
        _pwdField = pwdField;
    }
    nameView.frame = CGRectMake(x, 0, width, height);
    nameView.centerY = self.view.height * 0.5 - btnPaddingY * 2;
    [scrollView addSubview:nameView];
    
    pwdView.frame = nameView.bounds;
    pwdView.center = CGPointMake(nameView.centerX, CGRectGetMaxY(nameView.frame) + btnPaddingY + pwdView.height * 0.5);
    [scrollView addSubview:pwdView];
    y += (CGRectGetMaxY(pwdView.frame) + btnPaddingY * 0.5);
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.backgroundColor = [UIColor clearColor];
    [forgetBtn setTitle:kLocalizedString(@"sign_forget_pwd") forState:UIControlStateNormal];
    [forgetBtn setTitleColor:placeholderColor forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = fieldFont;
    [forgetBtn sizeToFit];
    forgetBtn.center = CGPointMake(x + width - forgetBtn.width * 0.5, y + forgetBtn.height * 0.5);
    [forgetBtn addTarget:self action:@selector(forgetBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:forgetBtn];
    y += (forgetBtn.height + kSizeScale(34));
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = kMainOnTintColor;
    loginBtn.frame = CGRectMake(x, y, width, height);
    loginBtn.layer.cornerRadius = corner;
    [loginBtn setTitle:kLocalizedString(@"sign_in") forState:UIControlStateNormal];
    [loginBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = kRegularFont(btnFontSize);
    [loginBtn addTarget:self action:@selector(loginBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:loginBtn];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.backgroundColor = kMarqueeBgColor;
    registerBtn.frame = loginBtn.bounds;
    registerBtn.center = CGPointMake(loginBtn.centerX, CGRectGetMaxY(loginBtn.frame) + CGRectGetHeight(registerBtn.frame) * 0.5 + btnPaddingY);
    registerBtn.layer.cornerRadius = loginBtn.layer.cornerRadius;
    [registerBtn setTitle:kLocalizedString(@"sign_up") forState:UIControlStateNormal];
    [registerBtn setTitleColor:kMainOnTintColor forState:UIControlStateNormal];
    registerBtn.titleLabel.font = loginBtn.titleLabel.font;
    [registerBtn addTarget:self action:@selector(registerBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:registerBtn];
    y = (CGRectGetMaxY(registerBtn.frame) + kSizeScale(34));
    
    UIButton *visitorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString *strAttr = [[NSAttributedString alloc] initWithString:kLocalizedString(@"sign_visitor")
                                                                  attributes:@{NSForegroundColorAttributeName: placeholderColor,
                                                                               NSFontAttributeName: fieldFont,
                                                                               NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlineStylePatternSolid),
                                                                               NSUnderlineColorAttributeName: placeholderColor}];
    
    visitorBtn.backgroundColor = [UIColor clearColor];
    [visitorBtn setAttributedTitle:strAttr forState:UIControlStateNormal];
    [visitorBtn sizeToFit];
    visitorBtn.center = CGPointMake(loginBtn.centerX, y + visitorBtn.height * 0.5);
    [visitorBtn addTarget:self action:@selector(visitorBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:visitorBtn];
}

#pragma mark - Events

- (void)pwdFieldRightBtnClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    self.pwdField.secureTextEntry = !sender.isSelected;
}

- (void)forgetBtnOnClicked {
    [self.view endEditing:YES];
}

- (void)loginBtnOnClicked {
    [self.view endEditing:YES];
}

- (void)registerBtnOnClicked {
    [self.view endEditing:YES];
}

- (void)visitorBtnOnClicked {
    [self.view endEditing:YES];
}

- (void)selfOnTapped {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}


@end
