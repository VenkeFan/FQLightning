//
//  LGMatchParlayKeyboard.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/4.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchParlayKeyboard.h"

#define kParlayKeyboardKeyColor                 kUIColorFromRGB(0x3B3635)
#define kParlayKeyboardKeyFontSize              kSizeScale(9.0)

NSInteger const kMatchParlayMaxBet              = 5000;

@implementation LGMatchParlayKeyboard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kLGMatchParlayKeyboardHeight)]) {
        self.backgroundColor = kCellBgColor;
        
        [self initializeUI];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - UI

- (void)initializeUI {
    CGFloat padding = kSizeScale(3.0);
    CGFloat x = kSizeScale(6.0), y = padding;
    int countInRow = 7;
    int numbers = 10;
    CGFloat numberWidth = (self.width - x * 2 - (countInRow - 1) * padding) / countInRow; // (self.width - (numbers + 1) * padding) / (float)numbers;
    CGFloat height = (self.height - (2 + 1) * (padding)) / 2.0;
    CGFloat bigWidth = numberWidth * 2 + padding;
    
    UIButton* (^createButton)(NSString *) = ^(NSString *title) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:kParlayKeyboardKeyColor];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:kMainOnTintColor forState:UIControlStateNormal];
        btn.layer.cornerRadius = kSizeScale(3.0);
        btn.titleLabel.font = kRegularFont(kParlayKeyboardKeyFontSize);
        
        return btn;
    };
    
    CGFloat left = x, top = y;
    for (int i = 0; i < numbers; i++) {
        left = x + (i % (numbers / 2)) * (numberWidth + padding);
        top = y + (i / (numbers / 2)) * (height + padding);
        
        UIButton *numberBtn = createButton([NSString stringWithFormat:@"%d", i + 1]);
        numberBtn.tag = i + 1;
        if (i == numbers - 1) {
            [numberBtn setTitle:@"0" forState:UIControlStateNormal];
            numberBtn.tag = 0;
        }
        numberBtn.frame = CGRectMake(left, top, numberWidth, height);
        [numberBtn addTarget:self action:@selector(numberBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:numberBtn];
    }
    
    left += (padding + numberWidth);
    UIButton *confirmBtn = createButton(kLocalizedString(@"parlay_confirm"));
    confirmBtn.frame = CGRectMake(left, top, bigWidth, height);
    confirmBtn.titleLabel.font = kRegularFont(kParlayKeyboardKeyFontSize);
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
    top = y;
    UIButton *maxBetBtn = createButton([NSString stringWithFormat:@"%@\n%ld", kLocalizedString(@"parlay_max"), (long)kMatchParlayMaxBet]);
    maxBetBtn.frame = CGRectMake(left, top, numberWidth, height);
    maxBetBtn.titleLabel.font = kRegularFont(kSizeScale(7.0));
    maxBetBtn.titleLabel.numberOfLines = 0;
    maxBetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [maxBetBtn addTarget:self action:@selector(maxBetBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:maxBetBtn];
    
    left += (padding + numberWidth);
    UIButton *delBtn = createButton(nil);
    delBtn.frame = CGRectMake(left, top, numberWidth, height);
    [delBtn setImage:[UIImage imageNamed:@"main_delete_keyboard"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delBtn];
}

#pragma mark - Events

- (void)numberBtnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(matchParlayKeyboard:number:)]) {
        [self.delegate matchParlayKeyboard:self number:sender.tag];
    }
}

- (void)maxBetBtnClicked {
    if ([self.delegate respondsToSelector:@selector(matchParlayKeyboard:maxBet:)]) {
        [self.delegate matchParlayKeyboard:self maxBet:kMatchParlayMaxBet];
    }
}

- (void)delBtnClicked {
    if ([self.delegate respondsToSelector:@selector(matchParlayKeyboardDeleted:)]) {
        [self.delegate matchParlayKeyboardDeleted:self];
    }
}

- (void)confirmBtnClicked {
    if ([self.delegate respondsToSelector:@selector(matchParlayKeyboardConfirmed:)]) {
        [self.delegate matchParlayKeyboardConfirmed:self];
    }
}

@end
