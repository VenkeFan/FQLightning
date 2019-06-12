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
@property (nonatomic, strong) UILabel *groupNameLab;
@property (nonatomic, strong) UILabel *matchNameLab;
@property (nonatomic, strong) UILabel *gainLab;
@property (nonatomic, strong) LGMatchParlayTextField *field;
@property (nonatomic, weak) LGMatchParlayKeyboard *keyboard;

@end

@implementation LGMatchParlayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kCellBgColor;
        self.clipsToBounds = YES;
        self.contentView.clipsToBounds = YES;
        
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI {
    _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _delBtn.backgroundColor = [UIColor clearColor];
    [_delBtn setImage:[UIImage imageNamed:@"main_delete"] forState:UIControlStateNormal];
    [_delBtn addTarget:self action:@selector(delBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_delBtn];
    
    _teamNameLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
    _teamNameLab.textColor = kScoreFontColor;
    _teamNameLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_teamNameLab];
    
    _groupNameLab = [FQComponentFactory labelWithFont:kRegularFont(kTinyFontSize)];
    _groupNameLab.textColor = kUIColorFromRGB(0xA09584);
    _groupNameLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_groupNameLab];
    
    _matchNameLab = [FQComponentFactory labelWithFont:kRegularFont(kTinyFontSize)];
    _matchNameLab.textColor = kUIColorFromRGB(0xA09584);
    _matchNameLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_matchNameLab];
    
    LGMatchParlayKeyboard *keyboard = [LGMatchParlayKeyboard new];
    keyboard.hidden = YES;
    [self.contentView addSubview:keyboard];
    _keyboard = keyboard;
    
    _field = [LGMatchParlayTextField new];
    _field.delegate = self;
    _field.inputView = keyboard;
    _keyboard.delegate = _field;
    [self.contentView addSubview:_field];
    
    _gainLab = [FQComponentFactory labelWithFont:kRegularFont(kTinyFontSize)];
    _gainLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_gainLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = 0, y = kSizeScale(10.0);
    
    _delBtn.frame = CGRectMake(x, 0, kSizeScale(50.0), kSizeScale(50.0));
    
    _field.left = self.width - kSizeScale(13.0) - _field.width;
    _field.top = y;
    
    _gainLab.right = _field.right;
    _gainLab.top = CGRectGetMaxY(_field.frame) + y;
    
    _teamNameLab.left = CGRectGetMaxX(_delBtn.frame);
    _teamNameLab.top = y;
    _teamNameLab.width = CGRectGetMinX(_field.frame) - CGRectGetMaxX(_delBtn.frame);
    
    _groupNameLab.left = _teamNameLab.left;
    _groupNameLab.top = CGRectGetMaxY(_teamNameLab.frame) + kSizeScale(6.0);
    _groupNameLab.width = _teamNameLab.width;
    
    _matchNameLab.left = _teamNameLab.left;
    _matchNameLab.top = CGRectGetMaxY(_groupNameLab.frame) + kSizeScale(4.0);
    _matchNameLab.width = _teamNameLab.width;
    
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
    _groupNameLab.text = [[dataDic objectForKey:kLGMatchParlayTableViewCellKeyOddsDic] objectForKey:kTournamentOddsKeyGroupName];
    [_groupNameLab sizeToFit];
    _matchNameLab.text = [dataDic objectForKey:kLGMatchParlayTableViewCellKeyMatchName];
    [_matchNameLab sizeToFit];
    
    NSString *text = kLocalizedString(@"parlay_gain");
    NSString *gain = @"999.99";
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", text, gain]];
    [attrStrM addAttributes:@{NSFontAttributeName: kRegularFont(kTinyFontSize)} range:NSMakeRange(0, attrStrM.length)];
    [attrStrM addAttributes:@{NSForegroundColorAttributeName: kUIColorFromRGB(0xA09584)} range:NSMakeRange(0, text.length)];
    [attrStrM addAttributes:@{NSForegroundColorAttributeName: kScoreFontColor} range:NSMakeRange(text.length, attrStrM.length - text.length)];
    _gainLab.attributedText = attrStrM;
    [_gainLab sizeToFit];
}

#pragma mark - LGMatchParlayTextFieldDelegate

- (void)matchParlayTextFieldShouldBeginEditing:(LGMatchParlayTextField *)textField {
    if ([self.delegate respondsToSelector:@selector(matchParlayTableViewCellKeyboardWillShow:)]) {
        [self.delegate matchParlayTableViewCellKeyboardWillShow:self];
    }
}

- (void)matchParlayTextFieldShouldEndEditing:(LGMatchParlayTextField *)textField {
    if (textField.text) {
        [self.dataDic setObject:textField.text forKey:kLGMatchParlayTableViewCellKeyFieldText];
    }
    
    if ([self.delegate respondsToSelector:@selector(matchParlayTableViewCellKeyboardWillHide:)]) {
        [self.delegate matchParlayTableViewCellKeyboardWillHide:self];
    }
}

- (void)matchParlayTextFieldShouldReturn:(LGMatchParlayTextField *)textField {
    
}

- (void)matchParlayTextField:(LGMatchParlayTextField *)textField didEditing:(NSString *)string {
    if (textField.text) {
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
