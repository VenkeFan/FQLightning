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
@property (nonatomic, strong) UIView *earningView;
@property (nonatomic, strong) UIView *countView;
@property (nonatomic, strong) UILabel *countLab;

@property (nonatomic, strong) UIButton *rightBetBtn;

@end

@implementation LGMatchParlayBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        
        [self initializeUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _contentView.frame = CGRectMake(0, 0, self.width, kLGMatchParlayViewBottomContentHeight);
    _lineLayer.frame = CGRectMake(0, -2, self.width, 2);
    _leftInfoCtr.frame = CGRectMake(0, 0, _contentView.width * (3 / 5.0), _contentView.height);
    _expandTxtlayer.position = CGPointMake(_leftInfoCtr.width - _expandTxtlayer.width * 0.5, _leftInfoCtr.height * 0.5);
    _rightBetBtn.frame = CGRectMake(CGRectGetMaxX(_leftInfoCtr.frame), 0, self.width - CGRectGetMaxX(_leftInfoCtr.frame), _contentView.height);
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
        txtLayer.string = @"查看";
        CGSize size = [txtLayer.string sizeWithAttributes:@{NSFontAttributeName: kRegularFont(kNoteFontSize)}];
        txtLayer.frame = (CGRect){.origin = CGPointZero, .size = CGSizeMake(50, size.height)};
        txtLayer.foregroundColor = [UIColor lightGrayColor].CGColor;
        txtLayer.alignmentMode = kCAAlignmentCenter;
        [ctr.layer addSublayer:txtLayer];
        _expandTxtlayer = txtLayer;
        
        ctr;
    });
    [_contentView addSubview:_leftInfoCtr];
    
    _rightBetBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = kMainOnTintColor;
        [btn setTitle:@"确认投注" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = kRegularFont(kNameFontSize);
        [btn addTarget:self action:@selector(betBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    [_contentView addSubview:_rightBetBtn];
}

#pragma mark - Setter

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    
    if (expanded) {
        _lineLayer.hidden = YES;
        _expandTxtlayer.string = @"收起";
        
        [_rightBetBtn.titleLabel.layer addAnimation:transition forKey:nil];
        [_rightBetBtn setTitle:@"确认投注" forState:UIControlStateNormal];
    } else {
        _lineLayer.hidden = NO;
        _expandTxtlayer.string = @"查看";
        
        [_rightBetBtn.titleLabel.layer addAnimation:transition forKey:nil];
        [_rightBetBtn setTitle:@"投注单" forState:UIControlStateNormal];
    }
}
- (void)setItemCount:(NSUInteger)itemCount {
    _itemCount = itemCount;
    
    NSString *text = [NSString stringWithFormat:@"%ld", (long)itemCount];
    CGSize size = [text boundingRectWithSize:self.bounds.size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: self.countLab.font}
                                     context:nil].size;
    self.countLab.text = text;
    self.countLab.width = size.width + 10.0;
    self.countLab.height = size.height + 2.0;
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

@end
