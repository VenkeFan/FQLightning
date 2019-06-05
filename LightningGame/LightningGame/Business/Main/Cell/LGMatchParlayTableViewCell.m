//
//  LGMatchParlayTableViewCell.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchParlayTableViewCell.h"
#import "LGTournamentListKeys.h"
#import "FQComponentFactory.h"
#import "LGMatchParlayTextField.h"
#import "LGMatchParlayKeyboard.h"

NSString * const kLGMatchParlayTableViewCellKeyTeamDic          = @"kLGMatchParlayTableViewCellKeyTeamDic";
NSString * const kLGMatchParlayTableViewCellKeyOddsDic          = @"kLGMatchParlayTableViewCellKeyOddsDic";
NSString * const kLGMatchParlayTableViewCellKeyMatchName        = @"kLGMatchParlayTableViewCellKeyMatchName";
NSString * const kLGMatchParlayTableViewCellKeyFieldFocused     = @"kLGMatchParlayTableViewCellKeyFieldFocused";
NSString * const kLGMatchParlayTableViewCellKeyFieldText        = @"kLGMatchParlayTableViewCellKeyFieldText";

@interface LGMatchParlayTableViewCell () <LGMatchParlayTextFieldDelegate>

@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UILabel *teamNameLab;
@property (nonatomic, strong) LGMatchParlayTextField *field;
@property (nonatomic, weak) LGMatchParlayKeyboard *keyboard;

@end

@implementation LGMatchParlayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kMarqueeBgColor;
        self.clipsToBounds = YES;
        
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI {
    _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _delBtn.backgroundColor = [UIColor redColor];
    [_delBtn addTarget:self action:@selector(delBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_delBtn];
    
    _teamNameLab = [FQComponentFactory labelWithFont:kRegularFont(kNameFontSize)];
    [self.contentView addSubview:_teamNameLab];
    
    LGMatchParlayKeyboard *keyboard = [LGMatchParlayKeyboard new];
    keyboard.hidden = YES;
    [self.contentView addSubview:keyboard];
    _keyboard = keyboard;
    
    _field = [LGMatchParlayTextField new];
    _field.delegate = self;
    _field.layer.borderWidth = 1.0;
    _field.layer.borderColor = kCellBgColor.CGColor;
    _field.inputView = keyboard;
    _keyboard.delegate = _field;
    [self.contentView addSubview:_field];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10.0;
    
    _delBtn.frame = CGRectMake(margin, margin, 30, 30);
    _teamNameLab.center = CGPointMake(CGRectGetMaxX(_delBtn.frame) + margin + _teamNameLab.width * 0.5, _delBtn.centerY);
    
    _field.frame = CGRectMake(0, 0, 100, 30);
    _field.center = CGPointMake(self.width - margin - _field.width * 0.5, _delBtn.centerY);
    _keyboard.top = kLGMatchParlayTableViewCellHeight;
}

- (void)dealloc {
    
}

- (void)setDataDic:(NSMutableDictionary *)dataDic {
    _dataDic = dataDic;
    
    if ([dataDic[kLGMatchParlayTableViewCellKeyFieldFocused] boolValue] == YES) {
        _field.isResponder = YES;
    } else {
        _field.isResponder = NO;
    }
    _field.text = dataDic[kLGMatchParlayTableViewCellKeyFieldText];
    
    _teamNameLab.text = [[dataDic objectForKey:kLGMatchParlayTableViewCellKeyTeamDic] objectForKey:kTournamentTeamKeyName];
    [_teamNameLab sizeToFit];
}

#pragma mark - LGMatchParlayTextFieldDelegate

- (void)matchParlayTextFieldShouldBeginEditing:(LGMatchParlayTextField *)textField {
    if ([self.delegate respondsToSelector:@selector(matchParlayTableViewCellKeyboardWillShow:)]) {
        [self.delegate matchParlayTableViewCellKeyboardWillShow:self];
    }
}

- (void)matchParlayTextFieldShouldEndEditing:(LGMatchParlayTextField *)textField {
    if (textField.text.length > 0) {
        [self.dataDic setObject:textField.text forKey:kLGMatchParlayTableViewCellKeyFieldText];
    }
    
    if ([self.delegate respondsToSelector:@selector(matchParlayTableViewCellKeyboardWillHide:)]) {
        [self.delegate matchParlayTableViewCellKeyboardWillHide:self];
    }
}

- (void)matchParlayTextFieldShouldReturn:(LGMatchParlayTextField *)textField {
    
}

- (void)matchParlayTextField:(LGMatchParlayTextField *)textField didEditing:(NSString *)string {
    if (textField.text.length > 0) {
        [self.dataDic setObject:textField.text forKey:kLGMatchParlayTableViewCellKeyFieldText];
    }
}

//#pragma mark - UITextFieldDelegate
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//
//    return YES;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//#pragma mark - KeyboardNotification
//
//- (void)keyboardWillShow:(NSNotification *)notification {
//    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    if (keyboardFrame.size.height != kLGMatchParlayKeyboardHeight) {
//        return;
//    }
//    UIView *keyBoardView = [FQWindowUtility visibleKeyboard];
//
//    if ([self.delegate respondsToSelector:@selector(matchParlayTableViewCell:keyboardWillShow:)]) {
//        [self.delegate matchParlayTableViewCell:self keyboardWillShow:keyBoardView];
//    }
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification {
//    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    if (keyboardFrame.size.height != kLGMatchParlayKeyboardHeight) {
//        return;
//    }
//    UIView *keyBoardView = [FQWindowUtility visibleKeyboard];
//
//    if ([self.delegate respondsToSelector:@selector(matchParlayTableViewCell:keyboardWillHide:)]) {
//        [self.delegate matchParlayTableViewCell:self keyboardWillHide:keyBoardView];
//    }
//}

#pragma mark - Events

- (void)delBtnClicked {
    if ([self.delegate respondsToSelector:@selector(matchParlayTableViewCellDidDeleted:)]) {
        [self.delegate matchParlayTableViewCellDidDeleted:self];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_field.isResponder) {
        [_field resignFirstResponder];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(matchParlayTableViewCellOnTapped:)]) {
        [self.delegate matchParlayTableViewCellOnTapped:self];
    }
}

@end
