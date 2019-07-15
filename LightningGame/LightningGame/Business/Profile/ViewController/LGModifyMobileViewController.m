//
//  LGModifyMobileViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGModifyMobileViewController.h"
#import "LGUserManager.h"
#import "LGSignFieldView.h"

@interface LGModifyMobileViewController ()

@property (nonatomic, strong) LGUserManager *manager;
@property (nonatomic, weak) UITextField *mobileField;
@property (nonatomic, weak) UITextField *verifyField;
@property (nonatomic, weak) UITextField *pwdConfirmField;

@end

@implementation LGModifyMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"setup_modify_mobile");
    
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
        
        LGSignFieldView *pwd2View = [[LGSignFieldView alloc] initWithTitle:kLocalizedString(@"sign_pwd")
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
        [modifyBtn setTitle:kLocalizedString(@"parlay_confirm") forState:UIControlStateNormal];
        [modifyBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
        modifyBtn.titleLabel.font = kRegularFont(btnFontSize);
        [modifyBtn addTarget:self action:@selector(modifyBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:modifyBtn];
        
        view;
    });
    [scrollView addSubview:contentView];
}

#pragma mark - Events

- (void)verifyBtnClicked {
    
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
        _manager = [LGUserManager manager];
    }
    return _manager;
}

@end
