//
//  LGMatchListViewCell.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchListViewCell.h"
#import <CoreText/CoreText.h>
#import "LGMatchListKeys.h"
#import "LGMatchListOddsView.h"
#import "FQComponentFactory.h"
#import "FQImageButton.h"

@interface LGMatchListViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *tourNameLabel;
@property (nonatomic, strong) UILabel *countLab;

@property (nonatomic, strong) FQImageButton *topStatusBtn;
@property (nonatomic, strong) FQImageButton *btmStatusBtn;

@property (nonatomic, strong) UIImageView *leftLogoView;
@property (nonatomic, strong) UIImageView *rightLogoView;

@property (nonatomic, strong) CALayer *scoreLine;
@property (nonatomic, strong) CATextLayer *leftScore;
@property (nonatomic, strong) CATextLayer *rightScore;

@property (nonatomic, strong) LGMatchBasicOddsView *leftOddsView;
@property (nonatomic, strong) LGMatchBasicOddsView *rightOddsView;

@end

@implementation LGMatchListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self initializeUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _containerView.frame = CGRectMake(kCellMarginX, 0, CGRectGetWidth(self.frame) - kCellMarginX * 2, kLGMatchListViewCellContainerHeight);

    CGFloat x = kSizeScale(6.0), y = kSizeScale(6.0);
    CGFloat paddingX = kSizeScale(8.0);
    
    _titleView.frame = CGRectMake(x, y, CGRectGetWidth(_containerView.frame) - x * 2, kSizeScale(24.0));
    _tourNameLabel.frame = CGRectMake(x, 0, CGRectGetWidth(_titleView.frame) - x * 2, CGRectGetHeight(_titleView.frame));
    _countLab.center = CGPointMake(CGRectGetWidth(_titleView.frame) - x - CGRectGetWidth(_countLab.frame) * 0.5, CGRectGetHeight(_titleView.frame) * 0.5);
    
    _topStatusBtn.center = CGPointMake(CGRectGetWidth(_containerView.frame) * 0.5, CGRectGetMaxY(_titleView.frame) + y + _topStatusBtn.height * 0.5);
    _topStatusBtn.layer.cornerRadius = _topStatusBtn.height * 0.5;
    
    _scoreLine.position = CGPointMake(CGRectGetWidth(_containerView.frame) * 0.5, CGRectGetHeight(_containerView.frame) * 0.5);
    _leftScore.position = CGPointMake(CGRectGetMinX(_scoreLine.frame) - paddingX - CGRectGetWidth(_leftScore.frame) * 0.5,
                                      _scoreLine.positionY);
    _rightScore.position = CGPointMake(CGRectGetMaxX(_scoreLine.frame) + paddingX + CGRectGetWidth(_rightScore.frame) * 0.5,
                                       _scoreLine.positionY);
    
    _leftOddsView.center = CGPointMake(x + _leftOddsView.width * 0.5, CGRectGetHeight(_containerView.frame) - y - CGRectGetHeight(_leftOddsView.frame) * 0.5);
    _rightOddsView.center = CGPointMake(_containerView.width - x - _rightOddsView.width * 0.5, _leftOddsView.centerY);

    _leftLogoView.center = CGPointMake(_leftOddsView.centerX, _scoreLine.positionY);
    _rightLogoView.center = CGPointMake(_rightOddsView.centerX, _scoreLine.positionY);
    
    _btmStatusBtn.center = CGPointMake(CGRectGetWidth(_containerView.frame) * 0.5, _leftOddsView.centerY);
}

- (void)initializeUI {
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
        _topStatusBtn = [FQImageButton buttonWithType:UIButtonTypeCustom];
        _topStatusBtn.enabled = NO;
        _topStatusBtn.imageOrientation = FQImageButtonOrientation_Left;
        _topStatusBtn.backgroundColor = kMainOnTintColor;
//        _topStatusBtn.frame = CGRectMake(0, 0, kSizeScale(54.0), kSizeScale(14.0));
        _topStatusBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kSizeScale(2.0), 0, kSizeScale(2.0));
        _topStatusBtn.layer.cornerRadius = _topStatusBtn.height * 0.5;
        _topStatusBtn.layer.masksToBounds = YES;
        [_topStatusBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateDisabled];
        _topStatusBtn.titleLabel.font = kRegularFont(kTinyFontSize);
        [_containerView addSubview:_topStatusBtn];
        
        
        _btmStatusBtn = [FQImageButton buttonWithType:UIButtonTypeCustom];
        _btmStatusBtn.enabled = NO;
        _btmStatusBtn.imageOrientation = FQImageButtonOrientation_Top;
        _btmStatusBtn.backgroundColor = [UIColor clearColor];
        _btmStatusBtn.frame = CGRectMake(0, 0, kSizeScale(50.0), kSizeScale(40.0));
        [_btmStatusBtn setTitleColor:kMainOnTintColor forState:UIControlStateDisabled];
        _btmStatusBtn.titleLabel.font = kRegularFont(kNoteFontSize);
        _btmStatusBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_containerView addSubview:_btmStatusBtn];
    }
    
    {
        _scoreLine = [CALayer layer];
        _scoreLine.backgroundColor = kMarqueeBgColor.CGColor;
        _scoreLine.height = 2.0;
        _scoreLine.width = kSizeScale(14.0);
        [_containerView.layer addSublayer:_scoreLine];
        
        _leftScore = [FQComponentFactory textLayerWithFont:nil];
        [_containerView.layer addSublayer:_leftScore];
        
        _rightScore = [FQComponentFactory textLayerWithFont:nil];
        [_containerView.layer addSublayer:_rightScore];
    }
    
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

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = [dataDic copy];
    
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
    
    NSArray *teamArray = dataDic[kMatchKeyTeam];
    NSArray *oddsArray = dataDic[kMatchKeyOdds];
    
    NSDictionary *leftTeam, *rightTeam;
    NSDictionary *leftOdds, *rightOdds;
    
//    if (teamArray.count >= 2) {
//        leftTeam = teamArray[0];
//        rightTeam = teamArray[1];
//    }
    
    for (NSDictionary *tmp in teamArray) {
        if ([tmp[kMatchTeamKeyPos] integerValue] == 1) {
            leftTeam = tmp;
        } else if ([tmp[kMatchTeamKeyPos] integerValue] == 2) {
            rightTeam = tmp;
        }
    }
    
    if (oddsArray.count >= 2) {
        if ([leftTeam[kMatchTeamKeyTeamID] isEqual:oddsArray[0][kMatchOddsKeyTeamID]]) {
            leftOdds = oddsArray[0];
            rightOdds = oddsArray[1];
        } else {
            leftOdds = oddsArray[1];
            rightOdds = oddsArray[0];
        }
    }
    
    {
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
        
        NSAttributedString *leftScoreAttr = scoreStr(leftTeam);
        NSAttributedString *rightScoreAttr = scoreStr(rightTeam);
        
        CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)leftScoreAttr);
        CGSize bounds = CTFramesetterSuggestFrameSizeWithConstraints(ctFramesetter, CFRangeMake(0, leftScoreAttr.length), nil, _containerView.bounds.size, nil);
        _leftScore.width = bounds.width;
        _leftScore.height = bounds.height;
        CFRelease(ctFramesetter);
        
        ctFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)rightScoreAttr);
        bounds = CTFramesetterSuggestFrameSizeWithConstraints(ctFramesetter, CFRangeMake(0, rightScoreAttr.length), nil, _containerView.bounds.size, nil);
        _rightScore.width = bounds.width;
        _rightScore.height = bounds.height;
        CFRelease(ctFramesetter);
        
        _leftScore.string = leftScoreAttr;
        _rightScore.string = rightScoreAttr;
    }
    if (leftTeam[kMatchTeamKeyLogo]) {
        [_leftLogoView fq_setImageWithURLString:leftTeam[kMatchTeamKeyLogo]];
    }
    if (rightTeam[kMatchTeamKeyLogo]) {
        [_rightLogoView fq_setImageWithURLString:rightTeam[kMatchTeamKeyLogo]];
    }
    
    [_leftOddsView setTeamDic:leftTeam oddsDic:leftOdds matchName:dataDic[kMatchKeyMatchName]];
    [_rightOddsView setTeamDic:rightTeam oddsDic:rightOdds matchName:dataDic[kMatchKeyMatchName]];
    
    {
        LGMatchStatus status = (LGMatchStatus)[dataDic[kMatchKeyStatus] integerValue];
        switch (status) {
            case LGMatchStatus_Prepare: {
                self.topStatusBtn.hidden = NO;
                self.btmStatusBtn.hidden = NO;
                
                [self.topStatusBtn setImage:[UIImage imageNamed:@"main_notStarted"] forState:UIControlStateDisabled];
                [self.topStatusBtn setTitle:kLocalizedString(@"main_match_prepare") forState:UIControlStateNormal];
                [self.topStatusBtn sizeToFit];
                self.topStatusBtn.width += 6.0;
                self.topStatusBtn.height += 4.0;
                
                [self.btmStatusBtn setImage:[UIImage imageNamed:@"main_notStarted2"] forState:UIControlStateDisabled];
                [self.btmStatusBtn setTitle:kLocalizedString(@"main_match_prepare") forState:UIControlStateNormal];
            }
                break;
            case LGMatchStatus_Rolling: {
                self.topStatusBtn.hidden = NO;
                self.btmStatusBtn.hidden = NO;
                
                [self.topStatusBtn setImage:[UIImage imageNamed:@"main_started"] forState:UIControlStateDisabled];
                [self.topStatusBtn setTitle:kLocalizedString(@"main_match_live") forState:UIControlStateNormal];
                [self.topStatusBtn sizeToFit];
                self.topStatusBtn.width += 6.0;
                self.topStatusBtn.height += 4.0;
                
                [self.btmStatusBtn setImage:[UIImage imageNamed:@"main_rolling"] forState:UIControlStateDisabled];
                [self.btmStatusBtn setTitle:kLocalizedString(@"main_match_rolling") forState:UIControlStateNormal];
            }
                break;
            case LGMatchStatus_Finished: {
                self.topStatusBtn.hidden = YES;
                self.btmStatusBtn.hidden = YES;
            }
                break;
            case LGMatchStatus_Canceled: {
                self.topStatusBtn.hidden = YES;
                self.btmStatusBtn.hidden = YES;
            }
                break;
        }
    }
}

@end
