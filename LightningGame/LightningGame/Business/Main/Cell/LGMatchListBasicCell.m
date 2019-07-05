//
//  LGMatchListBasicCell.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchListBasicCell.h"
#import <CoreText/CoreText.h>

@interface LGMatchListBasicCell ()

@property (nonatomic, strong, readwrite) UIView *containerView;
@property (nonatomic, strong, readwrite) UIView *titleView;
@property (nonatomic, strong) UILabel *tourNameLabel;
@property (nonatomic, strong) UILabel *countLab;

@property (nonatomic, strong) UIImageView *leftLogoView;
@property (nonatomic, strong) UIImageView *rightLogoView;

@property (nonatomic, strong, readwrite) LGMatchBasicOddsView *leftOddsView;
@property (nonatomic, strong, readwrite) LGMatchBasicOddsView *rightOddsView;

@end

@implementation LGMatchListBasicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    NSAssert(![self isMemberOfClass:[LGMatchListBasicCell class]], @"LGMatchListBasicCell is an abstract class, you should not instantiate it directly.");
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self initializeGroundUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _containerView.frame = CGRectMake(kCellMarginX, 0, CGRectGetWidth(self.frame) - kCellMarginX * 2, kLGMatchListBasicCellContainerHeight);

    CGFloat x = kLGMatchListCellMarginX, y = kLGMatchListCellMarginY;
    
    {
        _titleView.frame = CGRectMake(x, y, CGRectGetWidth(_containerView.frame) - x * 2, kSizeScale(24.0));
        _tourNameLabel.frame = CGRectMake(x, 0, CGRectGetWidth(_titleView.frame) - x * 2, CGRectGetHeight(_titleView.frame));
        _countLab.center = CGPointMake(CGRectGetWidth(_titleView.frame) - x - CGRectGetWidth(_countLab.frame) * 0.5, CGRectGetHeight(_titleView.frame) * 0.5);
    }
    
    {
        _leftOddsView.center = CGPointMake(x + _leftOddsView.width * 0.5, CGRectGetHeight(_containerView.frame) - y - CGRectGetHeight(_leftOddsView.frame) * 0.5);
        _rightOddsView.center = CGPointMake(_containerView.width - x - _rightOddsView.width * 0.5, _leftOddsView.centerY);
    }
    
    {
        _leftLogoView.center = CGPointMake(_leftOddsView.centerX, _containerView.height * 0.5);
        _rightLogoView.center = CGPointMake(_rightOddsView.centerX, _containerView.height * 0.5);
    }
}

- (void)initializeGroundUI {
    _containerView = [UIView new];
    _containerView.backgroundColor = kCellBgColor;
    _containerView.layer.cornerRadius = kCornerRadius;
    _containerView.layer.shouldRasterize = YES;
    _containerView.layer.rasterizationScale = kScreenScale;
    [self.contentView addSubview:_containerView];
    
    _titleView = ({
        UIView *view = [UIView new];
        view.backgroundColor = kMarqueeBgColor;
        view.layer.cornerRadius = kCornerRadius;
        view.layer.shouldRasterize = YES;
        view.layer.rasterizationScale = kScreenScale;
        
        _tourNameLabel = [UILabel new];
        _tourNameLabel.textAlignment = NSTextAlignmentLeft;
        [view addSubview:_tourNameLabel];
        
        _countLab = [UILabel new];
        _countLab.backgroundColor = kMainBgColor;
        _countLab.text = @"1";
        _countLab.textColor = kUIColorFromRGB(0xFFFFFF);
        _countLab.font = kRegularFont(kNoteFontSize);
        _countLab.textAlignment = NSTextAlignmentCenter;
        [_countLab sizeToFit];
        _countLab.layer.cornerRadius = _countLab.height * 0.5;
        _countLab.layer.masksToBounds = YES;
        [view addSubview:_countLab];
        
        view;
    });
    [_containerView addSubview:_titleView];
    
    {
        CGFloat logoWidth = kSizeScale(60.0);
        _leftLogoView = [UIImageView new];
        _leftLogoView.frame = CGRectMake(0, 0, logoWidth, logoWidth);
        _leftLogoView.contentMode = UIViewContentModeScaleAspectFit;
        [_containerView addSubview:_leftLogoView];
        
        _rightLogoView = [UIImageView new];
        _rightLogoView.frame = CGRectMake(0, 0, logoWidth, logoWidth);
        _rightLogoView.contentMode = UIViewContentModeScaleAspectFit;
        [_containerView addSubview:_rightLogoView];
    }
    
    {
        _leftOddsView = [LGMatchListOddsView new];
        [_containerView addSubview:_leftOddsView];
        
        _rightOddsView = [LGMatchListOddsView new];
        [_containerView addSubview:_rightOddsView];
    }
}

#pragma mark - Abstract

- (void)addSubviews {
    FQAbstractMethodNotImplemented();
}

#pragma mark - Public

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = [dataDic copy];
    
    [self separateTeamsAndOdds];
    
    {
        NSString *tourName = dataDic[kMatchKeyTournamentName];
        NSString *round = [dataDic[kMatchKeyRound] uppercaseString];
        NSMutableString *strM = [NSMutableString stringWithFormat:@"%@/%@", tourName, round];
        NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:strM];
        [strAttr addAttributes:@{NSFontAttributeName: kRegularFont(kNameFontSize)} range:NSMakeRange(0, strM.length)];
        [strAttr addAttributes:@{NSForegroundColorAttributeName: kNameFontColor} range:NSMakeRange(0, tourName.length)];
        [strAttr addAttributes:@{NSForegroundColorAttributeName: kMainOnTintColor} range:NSMakeRange(tourName.length, strM.length - tourName.length)];
        
        _tourNameLabel.attributedText = strAttr;
        
        _countLab.text = [NSString stringWithFormat:@"+%@", [dataDic[kMatchKeyPlayCount] stringValue]];
        [_countLab sizeToFit];
        _countLab.width += 12.0;
        _countLab.height += 2.0;
    }
    
    {
        if (_leftTeam[kMatchTeamKeyLogo]) {
            [_leftLogoView fq_setImageWithURLString:_leftTeam[kMatchTeamKeyLogo]];
        }
        if (_rightTeam[kMatchTeamKeyLogo]) {
            [_rightLogoView fq_setImageWithURLString:_rightTeam[kMatchTeamKeyLogo]];
        }
    }
    
    {
        [_leftOddsView setTeamDic:_leftTeam oddsDic:_leftOdds matchName:dataDic[kMatchKeyMatchName]];
        [_rightOddsView setTeamDic:_rightTeam oddsDic:_rightOdds matchName:dataDic[kMatchKeyMatchName]];
    }
}

- (void)separateTeamsAndOdds {
    NSArray *teamArray = self.dataDic[kMatchKeyTeamArray];
    NSArray *oddsArray = self.dataDic[kMatchKeyOddsArray];
    
    for (NSDictionary *tmp in teamArray) {
        if ([tmp[kMatchTeamKeyPos] integerValue] == 1) {
            _leftTeam = tmp;
        } else if ([tmp[kMatchTeamKeyPos] integerValue] == 2) {
            _rightTeam = tmp;
        }
    }
    
    if (oddsArray.count >= 2) {
        if ([_leftTeam[kMatchTeamKeyTeamID] isEqual:oddsArray[0][kMatchOddsKeyTeamID]]) {
            _leftOdds = oddsArray[0];
            _rightOdds = oddsArray[1];
        } else {
            _leftOdds = oddsArray[1];
            _rightOdds = oddsArray[0];
        }
    }
}

- (void)setLeftScoreLayer:(CATextLayer *)leftLayer rightLayer:(CATextLayer *)rightLayer {
    NSAttributedString* (^scoreStr)(NSDictionary *) = ^(NSDictionary *team) {
        NSString *score = @"0";
        id obj = team[kMatchTeamKeyScore][kMatchScoreKeyTotal];
        if (obj && [obj respondsToSelector:@selector(stringValue)]) {
            score = [obj stringValue];
        }
        
        NSAttributedString *strAttr = [[NSAttributedString alloc] initWithString:score
                                                                      attributes:@{NSForegroundColorAttributeName: kScoreFontColor,
                                                                                   NSFontAttributeName: kBoldFont(kScoreFontSize)}];
        return strAttr;
    };
    
    NSAttributedString *leftScoreAttr = scoreStr(_leftTeam);
    NSAttributedString *rightScoreAttr = scoreStr(_rightTeam);
    
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)leftScoreAttr);
    CGSize bounds = CTFramesetterSuggestFrameSizeWithConstraints(ctFramesetter, CFRangeMake(0, leftScoreAttr.length), nil, _containerView.bounds.size, nil);
    leftLayer.width = bounds.width;
    leftLayer.height = bounds.height;
    CFRelease(ctFramesetter);
    
    ctFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)rightScoreAttr);
    bounds = CTFramesetterSuggestFrameSizeWithConstraints(ctFramesetter, CFRangeMake(0, rightScoreAttr.length), nil, _containerView.bounds.size, nil);
    rightLayer.width = bounds.width;
    rightLayer.height = bounds.height;
    CFRelease(ctFramesetter);
    
    leftLayer.string = leftScoreAttr;
    rightLayer.string = rightScoreAttr;
}

- (void)setTopBtn:(FQImageButton *)topBtn btmBtn:(FQImageButton *)btmBtn {
    
    LGMatchStatus status = (LGMatchStatus)[self.dataDic[kMatchKeyStatus] integerValue];
    switch (status) {
        case LGMatchStatus_Prepare: {
            topBtn.hidden = NO;
            btmBtn.hidden = NO;
            
            [topBtn setImage:[UIImage imageNamed:@"main_notStarted"] forState:UIControlStateDisabled];
            [topBtn setTitle:kLocalizedString(@"main_match_prepare") forState:UIControlStateNormal];
            [topBtn sizeToFit];
            topBtn.width += 6.0;
            topBtn.height += 4.0;
            
            [btmBtn setImage:[UIImage imageNamed:@"main_notStarted2"] forState:UIControlStateDisabled];
            [btmBtn setTitle:kLocalizedString(@"main_match_prepare") forState:UIControlStateNormal];
        }
            break;
        case LGMatchStatus_Rolling: {
            topBtn.hidden = NO;
            btmBtn.hidden = NO;
            
            [topBtn setImage:[UIImage imageNamed:@"main_started"] forState:UIControlStateDisabled];
            [topBtn setTitle:kLocalizedString(@"main_match_play") forState:UIControlStateNormal];
            [topBtn sizeToFit];
            topBtn.width += 6.0;
            topBtn.height += 4.0;
            
            [btmBtn setImage:[UIImage imageNamed:@"main_rolling"] forState:UIControlStateDisabled];
            [btmBtn setTitle:kLocalizedString(@"main_match_rolling") forState:UIControlStateNormal];
        }
            break;
        case LGMatchStatus_Finished: {
            topBtn.hidden = YES;
            btmBtn.hidden = YES;
        }
            break;
        case LGMatchStatus_Canceled: {
            topBtn.hidden = YES;
            btmBtn.hidden = YES;
        }
            break;
    }
}

@end

#pragma mark - Factory Category

@implementation LGMatchListBasicCell (Factory)

- (void)generateScoreView:(__strong UIView *_Nullable*_Nullable)scoreView
                     line:(__weak CALayer *_Nullable*_Nullable)line
                     left:(__weak CATextLayer *_Nullable*_Nullable)left
                    right:(__weak CATextLayer *_Nullable*_Nullable)right {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    view.clipsToBounds = NO;
    view.backgroundColor = [UIColor clearColor];
    if (scoreView) {
        *scoreView = view;
    }
    
    CALayer *scoreLine = [CALayer layer];
    scoreLine.backgroundColor = kMarqueeBgColor.CGColor;
    scoreLine.height = 2.0;
    scoreLine.width = kSizeScale(14.0);
    [view.layer addSublayer:scoreLine];
    if (line) {
        *line = scoreLine;
    }
    
    CATextLayer *leftScore = [FQComponentFactory textLayerWithFont:nil];
    [view.layer addSublayer:leftScore];
    if (left) {
        *left = leftScore;
    }
    
    CATextLayer *rightScore = [FQComponentFactory textLayerWithFont:nil];
    [view.layer addSublayer:rightScore];
    if (right) {
        *right = rightScore;
    }
}

- (void)generateTimeLabel:(UILabel *__strong  _Nullable *)timeLabel {
    UILabel *lab = [[UILabel alloc] init];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = kScoreFontColor;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.lineBreakMode = NSLineBreakByCharWrapping;
    lab.font = kRegularFont(kNameFontSize);
    if (timeLabel) {
        *timeLabel = lab;
    }
}

- (void)generateTopStatusBtn:(FQImageButton *__strong  _Nonnull *)topStatusBtn {
    FQImageButton *btn = [FQImageButton buttonWithType:UIButtonTypeCustom];
    btn.enabled = NO;
    btn.imageOrientation = FQImageButtonOrientation_Left;
    btn.backgroundColor = kMainOnTintColor;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, kSizeScale(2.0), 0, kSizeScale(2.0));
    btn.layer.cornerRadius = btn.height * 0.5;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateDisabled];
    btn.titleLabel.font = kRegularFont(kTinyFontSize);
    if (topStatusBtn) {
        *topStatusBtn = btn;
    }
}

- (void)generateBtmStatusBtn:(FQImageButton *__strong  _Nonnull *)btmStatusBtn {
    FQImageButton *btn = [FQImageButton buttonWithType:UIButtonTypeCustom];
    btn.enabled = NO;
    btn.imageOrientation = FQImageButtonOrientation_Top;
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(0, 0, kSizeScale(50.0), kSizeScale(40.0));
    [btn setTitleColor:kMainOnTintColor forState:UIControlStateDisabled];
    btn.titleLabel.font = kRegularFont(kNoteFontSize);
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (btmStatusBtn) {
        *btmStatusBtn = btn;
    }
}

- (NSString *)shortStartTime:(NSString *)startTime {
    return [startTime substringWithRange:NSMakeRange([startTime rangeOfString:@" "].location + 1, 5)];
}

@end
