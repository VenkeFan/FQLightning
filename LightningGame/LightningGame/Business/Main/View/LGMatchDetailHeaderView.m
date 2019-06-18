//
//  LGMatchDetailHeaderView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchDetailHeaderView.h"
#import "LGMatchListKeys.h"
#import "FQComponentFactory.h"
#import "FQImageButton.h"

@interface LGMatchDetailHeaderView ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *tourNameLabel;
//@property (nonatomic, strong) UILabel *countLab;

@property (nonatomic, strong) UIImageView *leftLogoView;
@property (nonatomic, strong) UIImageView *rightLogoView;

@property (nonatomic, strong) CALayer *scoreLine;
@property (nonatomic, strong) UILabel *leftScore;
@property (nonatomic, strong) UILabel *rightScore;

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) FQImageButton *statusBtn;

@property (nonatomic, strong) UILabel *leftTeamLab;
@property (nonatomic, strong) UILabel *rightTeamLab;

@end

@implementation LGMatchDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = kSizeScale(6.0), y = kSizeScale(6.0);
    CGFloat padding = kSizeScale(8.0);
    CGFloat logoX = kSizeScale(45.0);
    
    _titleView.frame = CGRectMake(x, y, CGRectGetWidth(self.frame) - x * 2, kSizeScale(24.0));
    _tourNameLabel.frame = CGRectMake(x, 0, CGRectGetWidth(_titleView.frame) - x * 2, CGRectGetHeight(_titleView.frame));
//    _countLab.center = CGPointMake(CGRectGetWidth(_titleView.frame) - x - CGRectGetWidth(_countLab.frame) * 0.5, CGRectGetHeight(_titleView.frame) * 0.5);
    
    _leftLogoView.center = CGPointMake(logoX + _leftLogoView.width * 0.5, self.height * 0.5);
    _rightLogoView.center = CGPointMake(self.width - logoX - _rightLogoView.width * 0.5, self.height * 0.5);
    
    _scoreLine.position = CGPointMake(self.width * 0.5, self.height * 0.5 - padding);
    _leftScore.center = CGPointMake(CGRectGetMinX(_scoreLine.frame) - padding - CGRectGetWidth(_leftScore.frame) * 0.5,
                                      _scoreLine.positionY);
    _rightScore.center = CGPointMake(CGRectGetMaxX(_scoreLine.frame) + padding + CGRectGetWidth(_rightScore.frame) * 0.5,
                                       _scoreLine.positionY);
    
    _statusLabel.center = CGPointMake(_scoreLine.positionX, CGRectGetMaxY(_leftScore.frame) + y + _statusLabel.height * 0.5);
    
    _leftTeamLab.center = CGPointMake(_leftLogoView.centerX, self.height - kSizeScale(20.0) - _leftTeamLab.height * 0.5);
    _rightTeamLab.center = CGPointMake(_rightLogoView.centerX, _leftTeamLab.centerY);
    
    _statusBtn.center = CGPointMake(_scoreLine.positionX, _leftTeamLab.centerY);
    _statusBtn.layer.cornerRadius = _statusBtn.height * 0.5;
}

- (void)initializeUI {
    _titleView = ({
        UIView *view = [UIView new];
        view.backgroundColor = kMarqueeBgColor;
        view.layer.cornerRadius = kCornerRadius;
        view.layer.shouldRasterize = YES;
        view.layer.rasterizationScale = kScreenScale;
        
        _tourNameLabel = [UILabel new];
        _tourNameLabel.textAlignment = NSTextAlignmentLeft;
        [view addSubview:_tourNameLabel];
        
//        _countLab = [UILabel new];
//        _countLab.backgroundColor = kMainBgColor;
//        _countLab.text = @"1";
//        _countLab.textColor = kUIColorFromRGB(0xFFFFFF);
//        _countLab.font = kRegularFont(kNoteFontSize);
//        _countLab.textAlignment = NSTextAlignmentCenter;
//        [_countLab sizeToFit];
//        _countLab.layer.cornerRadius = _countLab.height * 0.5;
//        _countLab.layer.masksToBounds = YES;
//        [view addSubview:_countLab];
        
        view;
    });
    [self addSubview:_titleView];
    
    {
        _statusLabel = [FQComponentFactory labelWithFont:kRegularFont(kNameFontSize)];
        _statusLabel.textColor = kMainOnTintColor;
        [self addSubview:_statusLabel];
        
        _statusBtn = [FQImageButton buttonWithType:UIButtonTypeCustom];
        _statusBtn.imageOrientation = FQImageButtonOrientation_Left;
        _statusBtn.backgroundColor = kMainOnTintColor;
        _statusBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kSizeScale(2.0), 0, kSizeScale(2.0));
        _statusBtn.layer.masksToBounds = YES;
        [_statusBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
        _statusBtn.titleLabel.font = kRegularFont(kTinyFontSize);
        [_statusBtn addTarget:self action:@selector(statusBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_statusBtn];
    }
    
    {
        _scoreLine = [CALayer layer];
        _scoreLine.backgroundColor = kMarqueeBgColor.CGColor;
        _scoreLine.height = 2.0;
        _scoreLine.width = kSizeScale(14.0);
        [self.layer addSublayer:_scoreLine];
        
        _leftScore = [FQComponentFactory labelWithFont:kBoldFont(kScoreFontSize)];
        _leftScore.textColor = kScoreFontColor;
        [self addSubview:_leftScore];
        
        _rightScore = [FQComponentFactory labelWithFont:kBoldFont(kScoreFontSize)];
        _rightScore.textColor = kScoreFontColor;
        [self addSubview:_rightScore];
    }
    
    {
        CGFloat logoWidth = kSizeScale(60.0);
        _leftLogoView = [UIImageView new];
        _leftLogoView.frame = CGRectMake(0, 0, logoWidth, logoWidth);
        _leftLogoView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_leftLogoView];
        
        _rightLogoView = [UIImageView new];
        _rightLogoView.frame = CGRectMake(0, 0, logoWidth, logoWidth);
        _rightLogoView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_rightLogoView];
    }
    
    {
        _leftTeamLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
        _leftTeamLab.textColor = kNameFontColor;
        [self addSubview:_leftTeamLab];
        
        _rightTeamLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
        _rightTeamLab.textColor = kNameFontColor;
        [self addSubview:_rightTeamLab];
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
        
//        _countLab.text = [NSString stringWithFormat:@"+%@", [dataDic[kMatchKeyPlayCount] stringValue]];
//        [_countLab sizeToFit];
//        _countLab.width += 12.0;
//        _countLab.height += 2.0;
    }
    
    NSArray *teamArray = dataDic[kMatchKeyTeam];
    NSDictionary *leftTeam, *rightTeam;
    
    for (NSDictionary *tmp in teamArray) {
        if ([tmp[kMatchTeamKeyPos] integerValue] == 1) {
            leftTeam = tmp;
        } else if ([tmp[kMatchTeamKeyPos] integerValue] == 2) {
            rightTeam = tmp;
        }
    }
    
    {
        NSString* (^scoreStr)(NSDictionary *) = ^(NSDictionary *team) {
            NSString *score = @"0";
            id obj = team[kMatchTeamKeyScore][kMatchScoreKeyTotal];
            if (obj && [obj respondsToSelector:@selector(stringValue)]) {
                score = [obj stringValue];
            }
            return score;
        };
        
        _leftScore.text = scoreStr(leftTeam);
        [_leftScore sizeToFit];
        
        _rightScore.text = scoreStr(leftTeam);
        [_rightScore sizeToFit];
    }
    
    if (leftTeam[kMatchTeamKeyLogo]) {
        [_leftLogoView fq_setImageWithURLString:leftTeam[kMatchTeamKeyLogo]];
    }
    if (rightTeam[kMatchTeamKeyLogo]) {
        [_rightLogoView fq_setImageWithURLString:rightTeam[kMatchTeamKeyLogo]];
    }
    
    {
        _leftTeamLab.text = leftTeam[kMatchTeamKeyName];
        [_leftTeamLab sizeToFit];
        
        _rightTeamLab.text = rightTeam[kMatchTeamKeyName];
        [_rightTeamLab sizeToFit];
    }
    
    {
        LGMatchStatus status = (LGMatchStatus)[dataDic[kMatchKeyStatus] integerValue];
        switch (status) {
            case LGMatchStatus_Prepare: {
                self.statusBtn.hidden = YES;
                
//                [self.statusBtn setImage:[UIImage imageNamed:@"main_notStarted"] forState:UIControlStateNormal];
//                [self.statusBtn setTitle:kLocalizedString(@"main_match_prepare") forState:UIControlStateNormal];
//                [self.statusBtn sizeToFit];
//                self.statusBtn.width += 6.0;
//                self.statusBtn.height += 4.0;
                
                self.statusLabel.text = kLocalizedString(@"main_match_prepare");
                [self.statusLabel sizeToFit];
            }
                break;
            case LGMatchStatus_Rolling: {
                self.statusBtn.hidden = NO;
                
                [self.statusBtn setImage:[UIImage imageNamed:@"main_started"] forState:UIControlStateNormal];
                [self.statusBtn setTitle:kLocalizedString(@"main_match_play") forState:UIControlStateNormal];
                [self.statusBtn sizeToFit];
                self.statusBtn.width += 6.0;
                self.statusBtn.height += 4.0;
                
                self.statusLabel.text = kLocalizedString(@"main_match_process");
                [self.statusLabel sizeToFit];
            }
                break;
            case LGMatchStatus_Finished: {
                self.statusBtn.hidden = YES;
                
                self.statusLabel.text = kLocalizedString(@"main_finished");
                [self.statusLabel sizeToFit];
            }
                break;
            case LGMatchStatus_Canceled: {
                self.statusBtn.hidden = YES;
                
                self.statusLabel.text = kLocalizedString(@"main_match_cancel");
                [self.statusLabel sizeToFit];
            }
                break;
        }
    }
}

#pragma mark - Events

- (void)statusBtnOnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(matchDetailHeaderViewDidPlay:)]) {
        [self.delegate matchDetailHeaderViewDidPlay:self];
    }
}

@end
