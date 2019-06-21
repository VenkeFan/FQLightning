//
//  LGMatchParlayTableViewCell.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchParlayTableViewCell.h"
#import "LGMatchListKeys.h"
#import "FQComponentFactory.h"
#import "LGMatchParlayTextField.h"
#import "LGMatchParlayKeyboard.h"

NSString * const kLGMatchParlayTableViewCellKeyTeamDic          = @"kLGMatchParlayTableViewCellKeyTeamDic";
NSString * const kLGMatchParlayTableViewCellKeyOddsDic          = @"kLGMatchParlayTableViewCellKeyOddsDic";
NSString * const kLGMatchParlayTableViewCellKeyMatchName        = @"kLGMatchParlayTableViewCellKeyMatchName";
NSString * const kLGMatchParlayTableViewCellKeyFieldFocused     = @"kLGMatchParlayTableViewCellKeyFieldFocused";
NSString * const kLGMatchParlayTableViewCellKeyAnte             = @"kLGMatchParlayTableViewCellKeyAnte";

@interface LGMatchParlayTableViewCell () <LGMatchParlayTextFieldDelegate>

@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UILabel *teamNameLab;
@property (nonatomic, strong) UILabel *groupNameLab;
@property (nonatomic, strong) UILabel *matchNameLab;
@property (nonatomic, strong) UILabel *gainLab;
@property (nonatomic, strong) UILabel *oddsLabel;
@property (nonatomic, strong) CALayer *lockLayer;
@property (nonatomic, strong) LGMatchParlayTextField *field;
@property (nonatomic, weak) LGMatchParlayKeyboard *keyboard;
@property (nonatomic, strong) UIView *line;

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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = 0, y = kSizeScale(10.0);
    CGFloat paddingX = kSizeScale(6.0);
    
    _delBtn.frame = CGRectMake(x, 0, kSizeScale(50.0), kSizeScale(50.0));
    
    _field.left = self.width - kSizeScale(13.0) - _field.width;
    _field.top = y;
    
    _gainLab.right = _field.right;
    _gainLab.top = CGRectGetMaxY(_field.frame) + y;
    
    _oddsLabel.center = CGPointMake(CGRectGetMinX(_field.frame) - paddingX - _oddsLabel.width * 0.5, _field.centerY);
    
    _lockLayer.position = CGPointMake(CGRectGetMinX(_field.frame) - paddingX - _lockLayer.width * 0.5, _field.centerY);
    
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
    
    _line.frame = CGRectMake(kSizeScale(6.0), self.height - 1.0, self.width - kSizeScale(6.0) * 2, 1.0);
}

- (void)dealloc {
    
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
    
    _oddsLabel = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
    _oddsLabel.textColor = kScoreFontColor;
    _oddsLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_oddsLabel];
    
    _lockLayer = [CALayer layer];
    UIImage *img = [UIImage imageNamed:@"main_lock2"];
    _lockLayer.frame = (CGRect){.origin = CGPointZero, .size = img.size};
    _lockLayer.contents = (__bridge id)img.CGImage;
    _lockLayer.contentsScale = [[UIScreen mainScreen] scale];
    _lockLayer.contentsGravity = kCAGravityResizeAspect;
    [self.contentView.layer addSublayer:_lockLayer];
    
    _line = [UIView new];
    _line.backgroundColor = kMainBgColor;
    [self.contentView addSubview:_line];
}

- (void)setDataDic:(NSMutableDictionary *)dataDic {
    _dataDic = dataDic;
    
    {
        if ([dataDic[kLGMatchParlayTableViewCellKeyFieldFocused] boolValue] == YES) {
            _field.isResponder = YES;
        } else {
            _field.isResponder = NO;
        }
        _field.text = dataDic[kLGMatchParlayTableViewCellKeyAnte];
    }
    
    {
        _teamNameLab.text = [[dataDic objectForKey:kLGMatchParlayTableViewCellKeyTeamDic] objectForKey:kMatchTeamKeyName];
        [_teamNameLab sizeToFit];
        _groupNameLab.text = [[dataDic objectForKey:kLGMatchParlayTableViewCellKeyOddsDic] objectForKey:kMatchOddsKeyGroupName];
        [_groupNameLab sizeToFit];
        _matchNameLab.text = [dataDic objectForKey:kLGMatchParlayTableViewCellKeyMatchName];
        [_matchNameLab sizeToFit];
    }
    
    {   
        @try {
            _gainLab.attributedText = [self p_gainText:[dataDic[kLGMatchParlayTableViewCellKeyAnte] floatValue]
                                                  odds:[dataDic[kLGMatchParlayTableViewCellKeyOddsDic][kMatchOddsKeyOddsValue] floatValue]];
            [_gainLab sizeToFit];
            
        } @catch (NSException *exception) {
            NSLog(@"%@, %@", NSStringFromSelector(_cmd), exception);
        } @finally {
            
        }
    }
    
    {
        self.oddsLabel.hidden = YES;
        self.lockLayer.hidden = YES;
        
        NSDictionary *oddsDic = [dataDic objectForKey:kLGMatchParlayTableViewCellKeyOddsDic];
        LGMatchOddsStatus status = (LGMatchOddsStatus)[oddsDic[kMatchOddsKeyStatus] integerValue];
        
        switch (status) {
            case LGMatchOddsStatus_Normal: {
                self.oddsLabel.hidden = NO;
                self.oddsLabel.text = [NSString stringWithFormat:@"@ %@", oddsDic[kMatchOddsKeyOddsValue]];
                [self.oddsLabel sizeToFit];
            }
                break;
            case LGMatchOddsStatus_Locked: {
                self.lockLayer.hidden = NO;
            }
                break;
            default: {
                
            }
                break;
        }
    }
}

#pragma mark - LGMatchParlayTextFieldDelegate

- (void)matchParlayTextFieldShouldBeginEditing:(LGMatchParlayTextField *)textField {
    if ([self.delegate respondsToSelector:@selector(matchParlayTableCellKeyboardWillShow:)]) {
        [self.delegate matchParlayTableCellKeyboardWillShow:self];
    }
}

- (void)matchParlayTextFieldShouldEndEditing:(LGMatchParlayTextField *)textField {
    if (textField.text) {
        [self.dataDic setObject:textField.text forKey:kLGMatchParlayTableViewCellKeyAnte];
    }
    
    if ([self.delegate respondsToSelector:@selector(matchParlayTableCellKeyboardWillHide:)]) {
        [self.delegate matchParlayTableCellKeyboardWillHide:self];
    }
}

- (void)matchParlayTextFieldShouldReturn:(LGMatchParlayTextField *)textField {
    
}

- (void)matchParlayTextField:(LGMatchParlayTextField *)textField didEditing:(NSString *)string {
    if (textField.text) {
        [self.dataDic setObject:textField.text forKey:kLGMatchParlayTableViewCellKeyAnte];
        
        @try {
            CGFloat ante = [textField.text floatValue];
            CGFloat oddsValue = [self.dataDic[kLGMatchParlayTableViewCellKeyOddsDic][kMatchOddsKeyOddsValue] floatValue];
            
            _gainLab.attributedText = [self p_gainText:ante odds:oddsValue];
            [_gainLab sizeToFit];
            _gainLab.right = _field.right;
            
            if ([self.delegate respondsToSelector:@selector(matchParlayTableCellDidBetting:ante:oddsID:)]) {
                [self.delegate matchParlayTableCellDidBetting:self ante:ante
                                                       oddsID:self.dataDic[kLGMatchParlayTableViewCellKeyOddsDic][kMatchOddsKeyOddsID]];
            }
            
        } @catch (NSException *exception) {
            NSLog(@"%@, %@", NSStringFromSelector(_cmd), exception);
        } @finally {
            
        }
    }
}

#pragma mark - Events

- (void)delBtnClicked {
    if ([self.delegate respondsToSelector:@selector(matchParlayTableCellDidDeleted:)]) {
        [self.delegate matchParlayTableCellDidDeleted:self];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_field.isResponder) {
        [_field resignFirstResponder];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(matchParlayTableCellOnTapped:)]) {
        [self.delegate matchParlayTableCellOnTapped:self];
    }
}
#pragma mark - Private

- (NSAttributedString *)p_gainText:(CGFloat)ante odds:(CGFloat)odds {
    CGFloat gain = ante * odds;
    
    NSString *text = kLocalizedString(@"parlay_gain");
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %.2f", text, gain]];
    [attrStrM addAttributes:@{NSFontAttributeName: kRegularFont(kTinyFontSize)} range:NSMakeRange(0, attrStrM.length)];
    [attrStrM addAttributes:@{NSForegroundColorAttributeName: kUIColorFromRGB(0xA09584)} range:NSMakeRange(0, text.length)];
    [attrStrM addAttributes:@{NSForegroundColorAttributeName: kScoreFontColor} range:NSMakeRange(text.length, attrStrM.length - text.length)];
    
    return attrStrM;
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

@end
