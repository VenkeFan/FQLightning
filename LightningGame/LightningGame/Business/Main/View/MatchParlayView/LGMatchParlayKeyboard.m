//
//  LGMatchParlayKeyboard.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/4.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchParlayKeyboard.h"

#define kParlayKeyboardKeyColor                 kUIColorFromRGB(0x3F475A)
#define kParlayKeyboardKeyFontSize              kSizeScale(18.0)

NSInteger const kMatchParlayMaxBet              = 5000;

@implementation LGMatchParlayKeyboard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kLGMatchParlayKeyboardHeight)]) {
        self.backgroundColor = kMarqueeBgColor;
        
        [self initializeUI];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - UI

- (void)initializeUI {
    CGFloat padding = 2.0;
    CGFloat x = padding, y = padding;
    CGFloat height = (self.height - (2 + 1) * (padding)) / 2.0;
    int numbers = 10;
    CGFloat numberWidth = (self.width - (numbers + 1) * padding) / (float)numbers;
    CGFloat bigWidth = (self.width - (3 + 1) * padding) / 3.0;
    
    UIButton* (^createButton)(NSString *) = ^(NSString *title) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:kParlayKeyboardKeyColor];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = kCornerRadius;
        btn.titleLabel.font = kRegularFont(kParlayKeyboardKeyFontSize);
        
        return btn;
    };
    
    for (int i = 0; i < numbers; i++) {
        UIButton *numberBtn = createButton([NSString stringWithFormat:@"%d", i + 1]);
        numberBtn.tag = i + 1;
        if (i == numbers - 1) {
            [numberBtn setTitle:@"0" forState:UIControlStateNormal];
            numberBtn.tag = 0;
        }
        numberBtn.frame = CGRectMake(x + i * (numberWidth + padding), y, numberWidth, height);
        [numberBtn addTarget:self action:@selector(numberBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:numberBtn];
    }
    y += (height + padding);
    
    UIButton *maxBetBtn = createButton([NSString stringWithFormat:@"最大投注\n%ld", (long)kMatchParlayMaxBet]);
    maxBetBtn.frame = CGRectMake(x, y, bigWidth, height);
    maxBetBtn.titleLabel.font = kRegularFont(kSizeScale(14.0));
    maxBetBtn.titleLabel.numberOfLines = 0;
    maxBetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [maxBetBtn addTarget:self action:@selector(maxBetBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:maxBetBtn];
    x += (maxBetBtn.width + padding);
    
    UIButton *delBtn = createButton(@"Delete");
    delBtn.frame = CGRectMake(x, y, bigWidth, height);
    delBtn.titleLabel.font = kRegularFont(kSizeScale(14.0));
    [delBtn addTarget:self action:@selector(delBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delBtn];
    x += (delBtn.width + padding);
    
    UIButton *confirmBtn = createButton(@"确定");
    confirmBtn.frame = CGRectMake(x, y, bigWidth, height);
    confirmBtn.titleLabel.font = kRegularFont(kSizeScale(14.0));
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
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
