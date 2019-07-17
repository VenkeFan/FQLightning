//
//  LGWithdrawViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/16.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGWithdrawViewController.h"
#import "FQComponentFactory.h"
#import "LGUserBankListView.h"
#import "LGUserManager.h"

@interface LGWithdrawViewController () <LGUserBankListViewDelegate>

@property (nonatomic, weak) UILabel *infoLab;
@property (nonatomic, weak) UITextField *moneyField;
@property (nonatomic, copy) NSDictionary *selectedItem;

@end

@implementation LGWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"wallet_withdraw");
    _selectedItem = [LGUserManager manager].cardArray.firstObject;
    
    [self initializeUI];
}

- (void)initializeUI {
    UIView *containerView = [UIView new];
    containerView.frame = CGRectMake(kCellMarginX, kNavBarHeight, kScreenWidth - kCellMarginX * 2, kScreenHeight - kNavBarHeight - kCellMarginY);
    containerView.backgroundColor = kCellBgColor;
    containerView.layer.cornerRadius = kCornerRadius;
    containerView.layer.masksToBounds = YES;
    [self.view addSubview:containerView];
    
    CGFloat titleWidth = kSizeScale(82.0);
    CGFloat paddingX = kSizeScale(12.0);
    CGFloat left = 0;
    
    UIView *userView = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, containerView.width, kSizeScale(62.0));
        view.backgroundColor = kMarqueeBgColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardViewTapped:)];
        [view addGestureRecognizer:tap];
        
        UILabel *titleLab = [FQComponentFactory labelWithFont:kRegularFont(kFieldFontSize)];
        titleLab.text = kLocalizedString(@"card_bank_card");
        titleLab.textColor = kNameFontColor;
        [titleLab sizeToFit];
        titleLab.center = CGPointMake(titleWidth * 0.5, view.height * 0.5);
        left = CGRectGetMinX(titleLab.frame);
        [view addSubview:titleLab];
        
        UIView *vLine = [self verticalLine:kCellBgColor];
        vLine.center = CGPointMake(titleWidth, view.height * 0.5);
        [view addSubview:vLine];
        
        UILabel *infoLab = [UILabel new];
        infoLab.textAlignment = NSTextAlignmentLeft;
        infoLab.numberOfLines = 2;
        [view addSubview:infoLab];
        _infoLab = infoLab;
        
        CGSize size;
        infoLab.attributedText = [self infoAttributedString:&size];
        infoLab.size = size;
        infoLab.center = CGPointMake(CGRectGetMaxX(vLine.frame) + paddingX + infoLab.width * 0.5, view.height * 0.5);
        
        UIImageView *accessoryImgView = [UIImageView new];
        accessoryImgView.contentMode = UIViewContentModeScaleAspectFit;
        accessoryImgView.image = [UIImage imageNamed:@"nav_back"];
        accessoryImgView.transform = CGAffineTransformMakeRotation(M_PI);
        [accessoryImgView sizeToFit];
        accessoryImgView.center = CGPointMake(view.width - kCellMarginX - accessoryImgView.width * 0.5, view.height * 0.5);
        [view addSubview:accessoryImgView];
        
        view;
    });
    [containerView addSubview:userView];
    
    UIView *numView = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, CGRectGetMaxY(userView.frame), containerView.width, kSizeScale(72.0));
        view.backgroundColor = [UIColor clearColor];
        
        UIView *hLine = [self horizontalLine];
        hLine.top = view.height - hLine.height;
        [view addSubview:hLine];
        
        UILabel *titleLab = [FQComponentFactory labelWithFont:kRegularFont(kFieldFontSize)];
        titleLab.text = kLocalizedString(@"card_withdraw_money");
        titleLab.textColor = kNameFontColor;
        [titleLab sizeToFit];
        titleLab.center = CGPointMake(left + titleLab.width * 0.5, paddingX + titleLab.height * 0.5);
        [view addSubview:titleLab];
        
        UITextField *txtField = [[UITextField alloc] init];
        txtField.frame = CGRectMake(left, CGRectGetMaxY(titleLab.frame) + paddingX * 0.5, view.width - left * 2, kSizeScale(35.0));
        txtField.leftView = ({
            UILabel *lab = [FQComponentFactory labelWithFont:kRegularFont(kScoreFontSize)];
            lab.text = @"¥";
            lab.textColor = kNameFontColor;
            lab.textAlignment = NSTextAlignmentLeft;
            [lab sizeToFit];
            lab.width += kSizeScale(10.0);
            lab;
        });
        txtField.leftViewMode = UITextFieldViewModeAlways;
        txtField.backgroundColor = [UIColor clearColor];
        txtField.font = kRegularFont(kFieldFontSize);
        txtField.textColor = kScoreFontColor;
        txtField.keyboardType = UIKeyboardTypeNumberPad;
        txtField.returnKeyType = UIReturnKeyDone;
        txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"最低提现额度要求在100元以上"
                                                                         attributes:@{NSForegroundColorAttributeName: kLightTintColor, NSFontAttributeName: kRegularFont(kTinyFontSize)}];
        [view addSubview:txtField];
        _moneyField = txtField;
        
        view;
    });
    [containerView addSubview:numView];
    
    UIView *validView = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, CGRectGetMaxY(numView.frame) + kCellMarginY, containerView.width, kSizeScale(24.0));
        view.backgroundColor = [UIColor clearColor];
        
        NSString *validStr = kLocalizedString(@"card_valid_balance");
        NSString *balance = [NSString stringWithFormat:@" ¥ %@", [[LGAccountManager instance] account][kAccountKeyAccountMoney]];
        NSMutableString *strM = [NSMutableString stringWithFormat:@"%@%@", validStr, balance];
        NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:strM];
        [strAttr addAttribute:NSFontAttributeName value:kRegularFont(kTinyFontSize) range:NSMakeRange(0, strAttr.length)];
        [strAttr addAttributes:@{NSForegroundColorAttributeName: kNameFontColor} range:NSMakeRange(0, validStr.length)];
        [strAttr addAttributes:@{NSForegroundColorAttributeName: kLightTintColor} range:NSMakeRange(validStr.length, balance.length)];
        
        UILabel *lab = [UILabel new];
        [view addSubview:lab];
        lab.attributedText = strAttr;
        [lab sizeToFit];
        lab.center = CGPointMake(left + lab.width * 0.5, view.height * 0.5);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, kSizeScale(80.0), view.height);
        btn.center = CGPointMake(CGRectGetMaxX(lab.frame) + paddingX + btn.width * 0.5, view.height * 0.5);
        btn.backgroundColor = kCellBgColor;
        [btn setTitle:kLocalizedString(@"card_withdraw_all") forState:UIControlStateNormal];
        [btn setTitleColor:kMainOnTintColor forState:UIControlStateNormal];
        btn.titleLabel.font = kRegularFont(kNoteFontSize);
        btn.layer.cornerRadius = kSizeScale(3.0);
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = kMainOnTintColor.CGColor;
        btn.layer.borderWidth = 1.0;
        [btn addTarget:self action:@selector(withdrawAllBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        view;
    });
    [containerView addSubview:validView];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.backgroundColor = kMainOnTintColor;
    submitBtn.frame = CGRectMake(kSizeScale(22.0), CGRectGetMaxY(validView.frame) + kSizeScale(24.0), containerView.width - kSizeScale(22.0) * 2, kSizeScale(36.0));
    submitBtn.layer.cornerRadius = kCornerRadius;
    [submitBtn setTitle:kLocalizedString(@"wallet_withdraw") forState:UIControlStateNormal];
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

- (NSAttributedString *)infoAttributedString:(CGSize *)strSize {
    NSString *name = [[LGAccountManager instance] account][kAccountKeyAccountRealName] ?: [[LGAccountManager instance] account][kAccountKeyAccountUserName];
    NSString *bankName = [NSString stringWithFormat:@"  %@ (%@)", self.selectedItem[kCardKeyName], [self.selectedItem[kCardKeyNumber] substringWithRange:NSMakeRange(0, 4)]];
    NSString *info = @"\n十分钟内到账";
    NSMutableString *strM = [NSMutableString stringWithFormat:@"%@%@%@", name, bankName, info];
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:strM];
    NSInteger location = 0;
    [strAttr addAttributes:@{NSForegroundColorAttributeName: kScoreFontColor,
                             NSFontAttributeName: kRegularFont(kNameFontSize)}
                     range:NSMakeRange(location, name.length)];
    location += name.length;
    [strAttr addAttributes:@{NSForegroundColorAttributeName: kNameFontColor,
                             NSFontAttributeName: kRegularFont(kTinyFontSize)}
                     range:NSMakeRange(location, bankName.length)];
    location += bankName.length;
    [strAttr addAttributes:@{NSForegroundColorAttributeName: kLightTintColor,
                             NSFontAttributeName: kRegularFont(kTinyFontSize)}
                     range:NSMakeRange(location, info.length)];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 2.0;
    [strAttr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, strAttr.length)];
    
    CGSize size = [strAttr boundingRectWithSize:CGSizeMake(kScreenWidth, kScreenHeight)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                        context:nil].size;
    if (strSize) {
        *strSize = size;
    }
    
    return strAttr;
}

#pragma mark - LGUserBankListViewDelegate

- (void)userBankListViewDidSelected:(NSDictionary *)itemDic {
    self.selectedItem = itemDic;
    
    CGFloat x = self.infoLab.frame.origin.x;
    
    CGSize size;
    self.infoLab.attributedText = [self infoAttributedString:&size];
    self.infoLab.size = size;
    self.infoLab.centerX = x + self.infoLab.width * 0.5;
}

#pragma mark - Events

- (void)cardViewTapped:(UIGestureRecognizer *)gesture {
    [self.view endEditing:YES];
    
    LGUserBankListView *bankView = [LGUserBankListView new];
    bankView.delegate = self;
    [bankView displayInParentView:self.view];
}

- (void)withdrawAllBtnClicked {
    [self.view endEditing:YES];
    
    NSInteger moneyInt = [[LGAccountManager instance].account[kAccountKeyAccountMoney] integerValue];
    _moneyField.text = [NSString stringWithFormat:@"%ld", (long)moneyInt];
}

- (void)submitBtnClicked {
    [self.view endEditing:YES];
    
    NSInteger money = [_moneyField.text integerValue];
    if (money <= 0) {
        return;
    }
    
    [LGLoadingView display];
    [[LGUserManager manager] withDrawWithCardID:self.selectedItem[kCardKeyBindID]
                                          money:money
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
