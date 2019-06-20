//
//  LGSignFieldView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGSignFieldView.h"

@interface LGSignFieldView () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *vLine;

@end

@implementation LGSignFieldView

- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
                        field:(__weak UITextField *_Nonnull*_Nonnull)field
                   titleWidth:(CGFloat)titleWidth {
    if (self = [self initWithTitle:title placeholder:placeholder field:field titleWidth:titleWidth isPwd:NO]) {
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
                        field:(__weak UITextField *_Nonnull*_Nonnull)field
                   titleWidth:(CGFloat)titleWidth
                        isPwd:(BOOL)isPwd {
    CGFloat width = kScreenWidth - kSizeScale(28) * 2, height = kSizeScale(40.0);
    
    if (self = [super initWithFrame:CGRectMake(0, 0, width, height)]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIColor *placeholderColor = kPlaceholderColor;
        UIFont *fieldFont = kRegularFont(kFieldFontSize);
        
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor clearColor];
        
        CGFloat marginX = kSizeScale(8.0);
        CGFloat x = 0;
        CGFloat centerY = view.height * 0.5;
        
        UILabel *lab = [[UILabel alloc] init];
        lab.text = title;
        lab.textColor = kScoreFontColor;
        lab.font = fieldFont;
        [lab sizeToFit];
        lab.width = titleWidth > lab.width ? titleWidth : lab.width;
        lab.center = CGPointMake(lab.width * 0.5, centerY);
        [view addSubview:lab];
        _titleLab = lab;
        x += (CGRectGetMaxX(lab.frame) + marginX);
        
        UIView *vLine = [[UIView alloc] init];
        vLine.backgroundColor = placeholderColor;
        vLine.frame = CGRectMake(0, 0, 1, lab.height + 4);
        vLine.center = CGPointMake(x, centerY);
        [view addSubview:vLine];
        _vLine = vLine;
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
        _txtField = txtField;
        if (field) {
            *field = txtField;
        }
        
        UIView *hLine = [[UIView alloc] init];
        hLine.backgroundColor = placeholderColor;
        hLine.frame = CGRectMake(0, view.height - 1, view.width, 1);
        [view addSubview:hLine];
        
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Events

- (void)pwdFieldRightBtnClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    self.txtField.secureTextEntry = !sender.isSelected;
}

@end
