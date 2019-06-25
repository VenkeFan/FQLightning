//
//  LGMatchListFinishedCell.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/19.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchListFinishedCell.h"

@interface LGMatchListFinishedCell ()

@property (nonatomic, strong) UIView *scoreView;
@property (nonatomic, weak) CALayer *scoreLine;
@property (nonatomic, weak) CATextLayer *leftScore;
@property (nonatomic, weak) CATextLayer *rightScore;

@property (nonatomic, strong) CALayer *leftFlag;
@property (nonatomic, strong) CALayer *rightFlag;

@end

@implementation LGMatchListFinishedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = kLGMatchListCellMarginX;
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
        _leftFlag.position = CGPointMake(CGRectGetMaxX(self.leftOddsView.frame) + x + _leftFlag.width * 0.5, self.leftOddsView.centerY);
        _rightFlag.position = CGPointMake(CGRectGetMinX(self.rightOddsView.frame) - x - _rightFlag.width * 0.5, self.leftOddsView.centerY);
    }
}

- (void)addSubviews {
    [self generateScoreView:&_scoreView line:&_scoreLine left:&_leftScore right:&_rightScore];
    [self.containerView addSubview:_scoreView];
    
    _leftFlag = [CALayer layer];
    _leftFlag.frame = CGRectMake(0, 0, kSizeScale(25.0), kSizeScale(35.0));
    _leftFlag.contentsScale = kScreenScale;
    _leftFlag.contentsGravity = kCAGravityResizeAspect;
    [self.containerView.layer addSublayer:_leftFlag];
    
    _rightFlag = [CALayer layer];
    _rightFlag.frame = (CGRect){.origin = CGPointZero, .size = _leftFlag.size};
    _rightFlag.contentsScale = kScreenScale;
    _rightFlag.contentsGravity = kCAGravityResizeAspect;
    [self.containerView.layer addSublayer:_rightFlag];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    [super setDataDic:dataDic];
    
    [self setLeftScoreLayer:_leftScore rightLayer:_rightScore];
    
    id(^flagImage)(NSDictionary *) = ^(NSDictionary *oddsDic) {
        if (!oddsDic) {
            return (__bridge id)nil;
        }
        return [oddsDic[kMatchOddsKeyWin] integerValue] == 1 ?
        (__bridge id)[UIImage imageNamed:@"main_win"].CGImage :
        (__bridge id)[UIImage imageNamed:@"main_lose"].CGImage;
    };
    
    kDisableTransaction(^(){
        self.leftFlag.contents = flagImage(self.leftOdds);
        self.rightFlag.contents = flagImage(self.rightOdds);
    });
}

@end
