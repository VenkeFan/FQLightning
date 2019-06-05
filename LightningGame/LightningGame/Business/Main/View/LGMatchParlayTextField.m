//
//  LGMatchParlayTextField.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/4.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchParlayTextField.h"

@interface LGMatchParlayTextField ()

@property (nonatomic, strong) UIView *cursorView;
@property (nonatomic, strong) UILabel *txtLabel;

@end

@implementation LGMatchParlayTextField

@synthesize text = _text;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isResponder = NO;
        [self initializeUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 4.0;
    _txtLabel.center = CGPointMake(padding + _txtLabel.width * 0.5, self.height * 0.5);
    _cursorView.frame = CGRectMake(0, 0, 2.0, _txtLabel.font.pointSize + padding);
    _cursorView.center = CGPointMake(CGRectGetMaxX(_txtLabel.frame) + _cursorView.width, self.height * 0.5);
}

- (void)dealloc {
    [self.txtLabel removeObserver:self forKeyPath:@"text"];
}

- (void)initializeUI {
    [self addSubview:self.cursorView];
    [self addSubview:self.txtLabel];
    
    [self.txtLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:self.txtLabel] && [keyPath isEqualToString:@"text"]) {
        NSString *newText = change[NSKeyValueChangeNewKey];
        _text = [newText copy];
        
        if ([self.delegate respondsToSelector:@selector(matchParlayTextField:didEditing:)]) {
            [self.delegate matchParlayTextField:self didEditing:_text];
        }
    }
}

#pragma mark - Override

- (BOOL)becomeFirstResponder {
    if (self.isResponder) {
        return YES;
    }
    self.isResponder = YES;
    
    if ([self.delegate respondsToSelector:@selector(matchParlayTextFieldShouldBeginEditing:)]) {
        [self.delegate matchParlayTextFieldShouldBeginEditing:self];
    }
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    if (!self.isResponder) {
        return YES;
    }
    
    self.isResponder = NO;
    
    if ([self.delegate respondsToSelector:@selector(matchParlayTextFieldShouldEndEditing:)]) {
        [self.delegate matchParlayTextFieldShouldEndEditing:self];
    }
    
    return [super resignFirstResponder];
}

- (void)setIsResponder:(BOOL)isResponder {
    _isResponder = isResponder;
    
    if (isResponder) {
        _cursorView.hidden = NO;
        _inputView.hidden = NO;
    } else {
        _cursorView.hidden = YES;
        _inputView.hidden = YES;
    }
}

#pragma mark - LGMatchParlayKeyboardDelegate

- (void)matchParlayKeyboard:(LGMatchParlayKeyboard *)keyboard number:(NSInteger)number {
    NSString *text = self.txtLabel.text.length > 0 ? self.txtLabel.text : @"";
    
    NSMutableString *strM = [[NSMutableString alloc] initWithString:text];
    [strM appendString:[NSString stringWithFormat:@"%ld", (long)number]];
    
    @try {
        NSInteger ante = [strM integerValue];
        if (ante > kMatchParlayMaxBet) {
            [LGToastView showWithText:@"超过最大投注额"];
        } else {
            self.txtLabel.text = [NSString stringWithFormat:@"%ld", (long)ante];
            [self.txtLabel sizeToFit];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)matchParlayKeyboard:(LGMatchParlayKeyboard *)keyboard maxBet:(NSInteger)maxBet {
    self.txtLabel.text = [NSString stringWithFormat:@"%ld", (long)maxBet];
    [self.txtLabel sizeToFit];
}

- (void)matchParlayKeyboardDeleted:(LGMatchParlayKeyboard *)keyboard {
    NSString *text = self.txtLabel.text.length > 0 ? self.txtLabel.text : @"";
    
    NSMutableString *strM = [[NSMutableString alloc] initWithString:text];
    if (strM.length > 0) {
        [strM deleteCharactersInRange:NSMakeRange(strM.length - 1, 1)];
    }
    
    @try {
        if (strM.length == 0) {
            self.txtLabel.text = @"";
        } else {
            NSInteger ante = [strM integerValue];
            self.txtLabel.text = [NSString stringWithFormat:@"%ld", (long)ante];
        }
        [self.txtLabel sizeToFit];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)matchParlayKeyboardConfirmed:(LGMatchParlayKeyboard *)keyboard {
    if ([self.delegate respondsToSelector:@selector(matchParlayTextFieldShouldReturn:)]) {
        [self.delegate matchParlayTextFieldShouldReturn:self];
    }
}

#pragma mark - Events

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self becomeFirstResponder];
}

#pragma mark - Setter

- (void)setText:(NSString *)text {
    _text = [text copy];
    
    self.txtLabel.text = text;
    [self.txtLabel sizeToFit];
}

#pragma mark - Getter

- (NSString *)text {
    return self.txtLabel.text;
}

- (UIView *)cursorView {
    if (!_cursorView) {
        _cursorView = [UIView new];
        _cursorView.backgroundColor = kMainOnTintColor;
        _cursorView.hidden = YES;
        
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.keyPath = @"opacity";
        animation.duration = 0.5;
        animation.fromValue = @(0);
        animation.toValue = @(1);
        animation.autoreverses = YES;
        animation.repeatCount = INFINITY;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [_cursorView.layer addAnimation:animation forKey:nil];
    }
    return _cursorView;
}

- (UILabel *)txtLabel {
    if (!_txtLabel) {
        _txtLabel = [UILabel new];
        _txtLabel.backgroundColor = [UIColor clearColor];
        _txtLabel.textColor = kMainOnTintColor;
        _txtLabel.font = kRegularFont(kNameFontSize);
        _txtLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _txtLabel;
}

@end
