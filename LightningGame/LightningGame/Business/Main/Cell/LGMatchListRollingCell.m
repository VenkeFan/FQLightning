//
//  LGMatchListRollingCell.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/19.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchListRollingCell.h"

@interface LGMatchListRollingCell ()

@property (nonatomic, strong) UIView *scoreView;
@property (nonatomic, weak) CALayer *scoreLine;
@property (nonatomic, weak) CATextLayer *leftScore;
@property (nonatomic, weak) CATextLayer *rightScore;

@property (nonatomic, strong) UIView *immediateView;
@property (nonatomic, strong) UILabel *immediateLabel;
@property (nonatomic, strong) UILabel *countDownLabel;

@property (nonatomic, strong) FQImageButton *topStatusBtn;
@property (nonatomic, strong) FQImageButton *btmStatusBtn;

@end

@implementation LGMatchListRollingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat y = kLGMatchListCellMarginY;
    CGFloat paddingX = kLGMatchListCellPaddingX;
    
    {
        _scoreView.center = CGPointMake(self.containerView.width * 0.5, self.containerView.height * 0.5);
        _scoreLine.position = CGPointMake(_scoreView.width * 0.5, _scoreView.height * 0.5);
        _leftScore.position = CGPointMake(CGRectGetMinX(_scoreLine.frame) - paddingX - CGRectGetWidth(_leftScore.frame) * 0.5,
                                          _scoreLine.positionY);
        _rightScore.position = CGPointMake(CGRectGetMaxX(_scoreLine.frame) + paddingX + CGRectGetWidth(_rightScore.frame) * 0.5,
                                           _scoreLine.positionY);
    }
    
    {
        _immediateView.center = CGPointMake(self.containerView.width * 0.5, self.containerView.height * 0.5);
        _immediateLabel.center = CGPointMake(_immediateView.width * 0.5, _immediateView.height * 0.5 - _immediateLabel.height * 0.5);
        _countDownLabel.center = CGPointMake(_immediateView.width * 0.5, _immediateView.height * 0.5 + _countDownLabel.height * 0.5);
    }
    
    {
        _topStatusBtn.center = CGPointMake(CGRectGetWidth(self.containerView.frame) * 0.5, CGRectGetMaxY(self.titleView.frame) + y + _topStatusBtn.height * 0.5);
        _topStatusBtn.layer.cornerRadius = _topStatusBtn.height * 0.5;
        
        _btmStatusBtn.center = CGPointMake(CGRectGetWidth(self.containerView.frame) * 0.5, self.leftOddsView.centerY);
    }
}

- (void)addSubviews {
    [self generateScoreView:&_scoreView line:&_scoreLine left:&_leftScore right:&_rightScore];
    [self.containerView addSubview:_scoreView];
    
    [self generateTopStatusBtn:&_topStatusBtn];
    [self.containerView addSubview:_topStatusBtn];
    
    [self generateBtmStatusBtn:&_btmStatusBtn];
    [self.containerView addSubview:_btmStatusBtn];
    
    _immediateView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.clipsToBounds = NO;
        view.backgroundColor = [UIColor clearColor];
        
        _immediateLabel = [UILabel new];
        _immediateLabel.text = kLocalizedString(@"main_match_immediately");
        _immediateLabel.textColor = kNameFontColor;
        _immediateLabel.font = kRegularFont(kNoteFontSize);
        _immediateLabel.textAlignment = NSTextAlignmentCenter;
        [_immediateLabel sizeToFit];
        [view addSubview:_immediateLabel];
        
        _countDownLabel = [UILabel new];
        _countDownLabel.textColor = kScoreFontColor;
        _countDownLabel.textAlignment = NSTextAlignmentCenter;
        _countDownLabel.font = kRegularFont(kNameFontSize);
        [view addSubview:_countDownLabel];
        
        view;
    });
    [self.containerView addSubview:_immediateView];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    [super setDataDic:dataDic];
    
    [self setLeftScoreLayer:_leftScore rightLayer:_rightScore];
    
    [self setTopBtn:_topStatusBtn btmBtn:_btmStatusBtn];
    
    LGMatchStatus status = (LGMatchStatus)[self.dataDic[kMatchKeyStatus] integerValue];
    switch (status) {
        case LGMatchStatus_Prepare: {
            self.scoreView.hidden = YES;
            
            self.immediateView.hidden = NO;
            
            self.topStatusBtn.hidden = NO;
            self.btmStatusBtn.hidden = NO;
        }
            break;
        case LGMatchStatus_Rolling: {
            self.scoreView.hidden = NO;
            
            self.immediateView.hidden = YES;
            
            self.topStatusBtn.hidden = NO;
            self.btmStatusBtn.hidden = NO;
        }
            break;
        default: {
            self.scoreView.hidden = NO;
            
            self.immediateView.hidden = YES;
            
            self.topStatusBtn.hidden = YES;
            self.btmStatusBtn.hidden = YES;
        }
            break;
    }
    
    {
        self.countDownLabel.text = dataDic[kMatchKeyStartTime];
        [self.countDownLabel sizeToFit];
    }
}

@end
