//
//  LGAddCardViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/16.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGAddCardViewController.h"
#import "FQComponentFactory.h"
#import "LGUserManager.h"
#import "LGBankListView.h"

@interface LGAddCardViewController () <LGBankListViewDelegate>

@property (nonatomic, weak) UITextField *cardField;
@property (nonatomic, weak) UIButton *bankBtn;
@property (nonatomic, copy) NSDictionary *selectedItem;

@end

@implementation LGAddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"wallet_add_card");
    
    [self initializeUI];
}

- (void)initializeUI {
    UIView *containerView = [UIView new];
    containerView.frame = CGRectMake(kCellMarginX, kNavBarHeight, kScreenWidth - kCellMarginX * 2, kScreenHeight - kNavBarHeight - kCellMarginY);
    containerView.backgroundColor = kCellBgColor;
    containerView.layer.cornerRadius = kCornerRadius;
    containerView.layer.masksToBounds = YES;
    [self.view addSubview:containerView];
    
    CGFloat height = kSizeScale(62.0);
    CGFloat titleWidth = kSizeScale(82.0);
    CGFloat paddingX = kSizeScale(12.0);
    
    UIView *userView = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, containerView.width, height);
        view.backgroundColor = kMarqueeBgColor;
        
        UILabel *titleLab = [FQComponentFactory labelWithFont:kRegularFont(kFieldFontSize)];
        titleLab.text = kLocalizedString(@"card_retainer");
        titleLab.textColor = kNameFontColor;
        [titleLab sizeToFit];
        titleLab.center = CGPointMake(titleWidth * 0.5, view.height * 0.5);
        [view addSubview:titleLab];
        
        UIView *vLine = [self verticalLine:kCellBgColor];
        vLine.center = CGPointMake(titleWidth, view.height * 0.5);
        [view addSubview:vLine];
        
        UILabel *infoLab = [UILabel new];
        infoLab.textAlignment = NSTextAlignmentLeft;
        infoLab.numberOfLines = 2;
        [view addSubview:infoLab];
        
        NSString *name = [[LGAccountManager instance] account][kAccountKeyAccountRealName] ?: [[LGAccountManager instance] account][kAccountKeyAccountUserName];
        NSString *info = @"提款卡姓名需与注册账号姓名一致";
        NSMutableString *strM = [NSMutableString stringWithFormat:@"%@\n%@", name, info];
        NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:strM];
        [strAttr addAttributes:@{NSForegroundColorAttributeName: kScoreFontColor,
                                 NSFontAttributeName: kRegularFont(kNameFontSize)} range:NSMakeRange(0, name.length)];
        [strAttr addAttributes:@{NSForegroundColorAttributeName: kLightTintColor,
                                 NSFontAttributeName: kRegularFont(kTinyFontSize)} range:NSMakeRange(name.length + 1, info.length)];
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineSpacing = 2.0;
        [strAttr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, strAttr.length)];
        
        infoLab.attributedText = strAttr;
        [infoLab sizeToFit];
        infoLab.center = CGPointMake(CGRectGetMaxX(vLine.frame) + paddingX + infoLab.width * 0.5, view.height * 0.5);
        
        view;
    });
    [containerView addSubview:userView];
    
    UIView *numView = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, CGRectGetMaxY(userView.frame), containerView.width, height);
        view.backgroundColor = [UIColor clearColor];
        
        UIView *hLine = [self horizontalLine];
        hLine.top = view.height - hLine.height;
        [view addSubview:hLine];
        
        UILabel *titleLab = [FQComponentFactory labelWithFont:kRegularFont(kFieldFontSize)];
        titleLab.text = kLocalizedString(@"card_number");
        titleLab.textColor = kNameFontColor;
        [titleLab sizeToFit];
        titleLab.center = CGPointMake(titleWidth * 0.5, view.height - paddingX - titleLab.height * 0.5);
        [view addSubview:titleLab];
        
        UIView *vLine = [self verticalLine:kMarqueeBgColor];
        vLine.center = CGPointMake(titleWidth, titleLab.centerY);
        [view addSubview:vLine];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"cjyhk_pz"] forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.center = CGPointMake(view.width - kCellMarginX - btn.width * 0.5, titleLab.centerY);
        [btn addTarget:self action:@selector(cameraBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UITextField *txtField = [[UITextField alloc] init];
        txtField.width = CGRectGetMinX(btn.frame) - CGRectGetMaxX(vLine.frame) - paddingX - kCellMarginX;
        txtField.height = kSizeScale(35.0);
        txtField.center = CGPointMake(CGRectGetMaxX(vLine.frame) + paddingX + txtField.width * 0.5, titleLab.centerY);
        txtField.backgroundColor = [UIColor clearColor];
        txtField.font = kRegularFont(kFieldFontSize);
        txtField.textColor = kScoreFontColor;
        txtField.returnKeyType = UIReturnKeyDone;
        txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入卡号或对银行卡进行拍照"
                                                                         attributes:@{NSForegroundColorAttributeName: kLightTintColor, NSFontAttributeName: kRegularFont(kTinyFontSize)}];
        [view addSubview:txtField];
        _cardField = txtField;
        
        view;
    });
    [containerView addSubview:numView];
    
    UIView *bankView = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, CGRectGetMaxY(numView.frame), containerView.width, height);
        view.backgroundColor = [UIColor clearColor];
        
        UIView *hLine = [self horizontalLine];
        hLine.top = view.height - hLine.height;
        [view addSubview:hLine];
        
        UILabel *titleLab = [FQComponentFactory labelWithFont:kRegularFont(kFieldFontSize)];
        titleLab.text = kLocalizedString(@"card_bank");
        titleLab.textColor = kNameFontColor;
        [titleLab sizeToFit];
        titleLab.center = CGPointMake(titleWidth * 0.5, view.height - paddingX - titleLab.height * 0.5);
        [view addSubview:titleLab];
        
        UIView *vLine = [self verticalLine:kMarqueeBgColor];
        vLine.center = CGPointMake(titleWidth, titleLab.centerY);
        [view addSubview:vLine];
        
        UIImageView *accessoryImgView = [UIImageView new];
        accessoryImgView.contentMode = UIViewContentModeScaleAspectFit;
        accessoryImgView.image = [UIImage imageNamed:@"nav_back"];
        accessoryImgView.transform = CGAffineTransformMakeRotation(M_PI);
        [accessoryImgView sizeToFit];
        accessoryImgView.center = CGPointMake(view.width - kCellMarginX - accessoryImgView.width * 0.5, titleLab.centerY);
        [view addSubview:accessoryImgView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.width = CGRectGetMinX(accessoryImgView.frame) - CGRectGetMaxX(vLine.frame) - paddingX - kCellMarginX;
        btn.height = kSizeScale(35.0);
        btn.center = CGPointMake(CGRectGetMaxX(vLine.frame) + paddingX + btn.width * 0.5, titleLab.centerY);
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:@"选择提款银行" forState:UIControlStateNormal];
        [btn setTitleColor:kLightTintColor forState:UIControlStateNormal];
        btn.titleLabel.font = kRegularFont(kTinyFontSize);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn addTarget:self action:@selector(bankBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        _bankBtn = btn;
        
        view;
    });
    [containerView addSubview:bankView];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.backgroundColor = kMainOnTintColor;
    submitBtn.frame = CGRectMake(kSizeScale(22.0), CGRectGetMaxY(bankView.frame) + kSizeScale(12.0), containerView.width - kSizeScale(22.0) * 2, kSizeScale(36.0));
    submitBtn.layer.cornerRadius = kCornerRadius;
    [submitBtn setTitle:kLocalizedString(@"wallet_add_card") forState:UIControlStateNormal];
    [submitBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
    submitBtn.titleLabel.font = kRegularFont(kFieldFontSize);
    [submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:submitBtn];
}

- (UIView *)verticalLine:(UIColor *)bgColor {
    UIView *view = [UIView new];
    view.backgroundColor = bgColor;
    view.frame = CGRectMake(0, 0, kSizeScale(2.0), kSizeScale(20.0));
    
    return view;
}

- (UIView *)horizontalLine {
    UIView *view = [UIView new];
    view.backgroundColor = kMarqueeBgColor;
    view.frame = CGRectMake(kCellMarginX, 0, kScreenWidth - kCellMarginX * 4, kSizeScale(2.0));
    
    return view;
}

#pragma mark - LGBankListViewDelegate

- (void)bankListViewDidSelected:(NSDictionary *)itemDic {
    self.selectedItem = itemDic;
    
    [_bankBtn setTitle:itemDic[kCardKeyName] forState:UIControlStateNormal];
    _bankBtn.titleLabel.font = kRegularFont(kFieldFontSize);
}

#pragma mark - Events

- (void)cameraBtnClicked {
    [self.view endEditing:YES];
    
}

- (void)bankBtnClicked {
    [self.view endEditing:YES];
    
    LGBankListView *bankView = [LGBankListView new];
    bankView.delegate = self;
    [bankView displayInParentView:self.view];
}

- (void)submitBtnClicked {
    [self.view endEditing:YES];
    
    if (_cardField.text.length == 0 || [self.selectedItem[kCardKeyName] length] == 0) {
        return;
    }
    
    [LGLoadingView display];
    [[LGUserManager manager] addCardNum:_cardField.text
                               bankName:self.selectedItem[kCardKeyName]
                              completed:^(BOOL result) {
                                  [LGLoadingView dismiss];
                                  
                                  if (result) {
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }
                              }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
