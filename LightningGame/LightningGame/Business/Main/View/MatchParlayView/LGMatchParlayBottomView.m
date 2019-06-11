//
//  LGMatchParlayBottomView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/5.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchParlayBottomView.h"
#import "FQComponentFactory.h"

@interface LGMatchParlayBottomView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) CALayer *lineLayer;

@property (nonatomic, strong) UIControl *leftInfoCtr;
@property (nonatomic, strong) CATextLayer *expandTxtlayer;

@property (nonatomic, strong) UILabel *totalBetLab;
@property (nonatomic, strong) UILabel *totalGainLab;
@property (nonatomic, strong) UILabel *countLab;

@property (nonatomic, strong) UIButton *rightBetBtn;

@property (nonatomic, strong) CATransition *transition;

@end

@implementation LGMatchParlayBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kMarqueeBgColor;
        
        [self initializeUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = kSizeScale(14.0);
    
    _contentView.frame = CGRectMake(0, 0, self.width, kLGMatchParlayViewBottomContentHeight);
    
    _lineLayer.frame = CGRectMake(0, -2, self.width, 2);
    
    _rightBetBtn.frame = CGRectMake(0, 0, kSizeScale(104.0), kSizeScale(36.0));
    _rightBetBtn.center = CGPointMake(self.width - x - _rightBetBtn.width * 0.5, _contentView.height * 0.5);
    
    _leftInfoCtr.frame = CGRectMake(0, 0, CGRectGetMinX(_rightBetBtn.frame), _contentView.height);
    
    _expandTxtlayer.position = CGPointMake(_leftInfoCtr.width - _expandTxtlayer.width * 0.5, _leftInfoCtr.height * 0.5);
    
    _countLab.center = CGPointMake(x + _countLab.width * 0.5, _leftInfoCtr.height * 0.5);
    
    _totalBetLab.left = x;
    _totalBetLab.centerY = _leftInfoCtr.height * 0.5 - _totalBetLab.height * 0.5 - 2.0;
    
    _totalGainLab.left = x;
    _totalGainLab.centerY = _leftInfoCtr.height * 0.5 + _totalGainLab.height * 0.5 + 2.0;
}

- (void)dealloc {
    
}

#pragma mark - UI

- (void)initializeUI {
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    
    _lineLayer = ({
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = kMainOnTintColor.CGColor;
        layer.hidden = YES;
        layer;
    });
    [_contentView.layer addSublayer:_lineLayer];
    
    _leftInfoCtr = ({
        UIControl *ctr = [UIControl new];
        ctr.backgroundColor = [UIColor clearColor];
        [ctr addTarget:self action:@selector(leftInfoCtrClicked) forControlEvents:UIControlEventTouchUpInside];
        
        CATextLayer *txtLayer = [FQComponentFactory textLayerWithFont:kRegularFont(kNoteFontSize)];
        txtLayer.string = kLocalizedString(@"parlay_expand");
        CGSize size = [txtLayer.string sizeWithAttributes:@{NSFontAttributeName: kRegularFont(kNoteFontSize)}];
        txtLayer.frame = (CGRect){.origin = CGPointZero, .size = CGSizeMake(50, size.height)};
        txtLayer.foregroundColor = kUIColorFromRGB(0xA09584).CGColor;
        txtLayer.alignmentMode = kCAAlignmentCenter;
        [ctr.layer addSublayer:txtLayer];
        _expandTxtlayer = txtLayer;
        
        _countLab = [UILabel new];
        _countLab.backgroundColor = kMainBgColor;
        _countLab.text = @"1";
        _countLab.textColor = kMainOnTintColor;
        _countLab.font = kRegularFont(kNoteFontSize);
        _countLab.textAlignment = NSTextAlignmentCenter;
        [_countLab sizeToFit];
        _countLab.width += 12.0;
        _countLab.height += 2.0;
        _countLab.layer.cornerRadius = _countLab.height * 0.5;
        _countLab.layer.masksToBounds = YES;
        [ctr addSubview:_countLab];
        
        _totalBetLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
        _totalBetLab.textColor = kNameFontColor;
        _totalBetLab.textAlignment = NSTextAlignmentLeft;
        _totalBetLab.text = kLocalizedString(@"parlay_total_bet");
        [_totalBetLab sizeToFit];
        [ctr addSubview:_totalBetLab];
        
        _totalGainLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
        _totalGainLab.textColor = kNameFontColor;
        _totalGainLab.textAlignment = NSTextAlignmentLeft;
        _totalGainLab.text = kLocalizedString(@"parlay_total_gain");
        [_totalGainLab sizeToFit];
        [ctr addSubview:_totalGainLab];
        
        ctr;
    });
    [_contentView addSubview:_leftInfoCtr];
    
    _rightBetBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = kMainOnTintColor;
        [btn setTitle:kLocalizedString(@"parlay_confirm_all") forState:UIControlStateNormal];
        [btn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
        btn.titleLabel.font = kRegularFont(kNameFontSize);
        btn.layer.cornerRadius = kCornerRadius;
        [btn addTarget:self action:@selector(betBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    [_contentView addSubview:_rightBetBtn];
}

#pragma mark - Events

- (void)leftInfoCtrClicked {
    if ([self.delegate respondsToSelector:@selector(matchParlayBottomViewDidChangeExpand:)]) {
        [self.delegate matchParlayBottomViewDidChangeExpand:self];
    }
}

- (void)betBtnClicked {
    if (self.isExpanded) {
        TODO("下注");
    } else {
        [self leftInfoCtrClicked];
    }
}

#pragma mark - Setter

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    
    if (expanded) {
        _lineLayer.hidden = YES;
        _expandTxtlayer.string = kLocalizedString(@"parlay_fold");
        
        [_rightBetBtn.titleLabel.layer addAnimation:transition forKey:nil];
        [_rightBetBtn setTitle:kLocalizedString(@"parlay_confirm_all") forState:UIControlStateNormal];
        
        [_countLab.layer addAnimation:self.transition forKey:nil];
        _countLab.hidden = YES;
        [_totalBetLab.layer addAnimation:self.transition forKey:nil];
        [_totalGainLab.layer addAnimation:self.transition forKey:nil];
        _totalBetLab.hidden = _totalGainLab.hidden = NO;
    } else {
        _lineLayer.hidden = NO;
        _expandTxtlayer.string = kLocalizedString(@"parlay_expand");
        
        [_rightBetBtn.titleLabel.layer addAnimation:transition forKey:nil];
        [_rightBetBtn setTitle:kLocalizedString(@"parlay_form") forState:UIControlStateNormal];
        
        [_countLab.layer addAnimation:self.transition forKey:nil];
        _countLab.hidden = NO;
        [_totalBetLab.layer addAnimation:self.transition forKey:nil];
        [_totalGainLab.layer addAnimation:self.transition forKey:nil];
        _totalBetLab.hidden = _totalGainLab.hidden = YES;
    }
}
- (void)setItemCount:(NSUInteger)itemCount {
    _itemCount = itemCount;
    
    NSString *text = [NSString stringWithFormat:@"%ld", (long)itemCount];
    CGSize size = [text boundingRectWithSize:self.bounds.size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: kRegularFont(kNoteFontSize)}
                                     context:nil].size;
    self.countLab.text = text;
    self.countLab.width = size.width + 12.0;
    self.countLab.height = size.height + 2.0;
}

#pragma mark - Getter

- (CATransition *)transition {
    if (!_transition) {
        _transition = [CATransition animation];
        _transition.type = kCATransitionFade;
        _transition.duration = 0.35;
    }
    return _transition;
}

@end
