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
#import "LGMatchTeamOddsView.h"
#import "FQComponentFactory.h"
#import "LGAPIURLConfig.h"

#define kScoreLayerPaddingX         kSizeScale(8.0)

@interface LGMatchListViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *tourNameLabel;

@property (nonatomic, strong) UIImageView *leftLogoView;
@property (nonatomic, strong) UIImageView *rightLogoView;

@property (nonatomic, strong) CALayer *scoreLine;
@property (nonatomic, strong) CATextLayer *leftScore;
@property (nonatomic, strong) CATextLayer *rightScore;

@property (nonatomic, strong) LGMatchTeamOddsView *leftOddsView;
@property (nonatomic, strong) LGMatchTeamOddsView *rightOddsView;

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

    CGFloat x = 8.0, y = 8.0;
    
    _titleView.frame = CGRectMake(x, y, CGRectGetWidth(_containerView.frame) - x * 2, kSizeScale(24.0));
    _tourNameLabel.frame = CGRectMake(x, 0, CGRectGetWidth(_titleView.frame) - x * 2, CGRectGetHeight(_titleView.frame));
    
    _scoreLine.position = CGPointMake(CGRectGetWidth(_containerView.frame) * 0.5, CGRectGetHeight(_containerView.frame) * 0.5 - kCellMarginY);
    _leftScore.position = CGPointMake(CGRectGetMinX(_scoreLine.frame) - kScoreLayerPaddingX - CGRectGetWidth(_leftScore.frame) * 0.5,
                                      _scoreLine.positionY);
    _rightScore.position = CGPointMake(CGRectGetMaxX(_scoreLine.frame) + kScoreLayerPaddingX + CGRectGetWidth(_rightScore.frame) * 0.5,
                                       _scoreLine.positionY);

    _leftLogoView.center = CGPointMake(CGRectGetWidth(_containerView.frame) * 0.25 - kCellMarginX, _scoreLine.positionY);
    _rightLogoView.center = CGPointMake(CGRectGetWidth(_containerView.frame) * 0.75 + kCellMarginX, _scoreLine.positionY);
    
    _leftOddsView.center = CGPointMake(_leftLogoView.centerX, CGRectGetHeight(_containerView.frame) - y - CGRectGetHeight(_leftOddsView.frame) * 0.5);
    _rightOddsView.center = CGPointMake(_rightLogoView.centerX, _leftOddsView.centerY);
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
        
        view;
    });
    [_containerView addSubview:_titleView];
    
    {
        _scoreLine = [CALayer layer];
        _scoreLine.backgroundColor = kMarqueeBgColor.CGColor;
        _scoreLine.height = 2.0;
        _scoreLine.width = kSizeScale(20.0);
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
        _leftOddsView = [LGMatchTeamOddsView new];
        _leftOddsView.direction = LGMatchTeamOddsViewDirection_Vertical;
        [_containerView addSubview:_leftOddsView];
        
        _rightOddsView = [LGMatchTeamOddsView new];
        _rightOddsView.direction = LGMatchTeamOddsViewDirection_Vertical;
        [_containerView addSubview:_rightOddsView];
    }
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = [dataDic copy];
    
    {
        NSString *tourName = dataDic[kMatchListKeyTournamentName];
        NSString *round = [dataDic[kMatchListKeyRound] uppercaseString];
        NSMutableString *strM = [NSMutableString stringWithFormat:@"%@/%@", tourName, round];
        NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:strM];
        [strAttr addAttributes:@{NSFontAttributeName: kRegularFont(kNameFontSize)} range:NSMakeRange(0, strM.length)];
        [strAttr addAttributes:@{NSForegroundColorAttributeName: kNameFontColor} range:NSMakeRange(0, tourName.length)];
        [strAttr addAttributes:@{NSForegroundColorAttributeName: kMainOnTintColor} range:NSMakeRange(tourName.length, strM.length - tourName.length)];
        
        _tourNameLabel.attributedText = strAttr;
    }
    
    NSArray *teamArray = dataDic[kMatchListKeyTeam];
    NSArray *oddsArray = dataDic[kMatchListKeyOdds];
    
    NSDictionary *leftTeam, *rightTeam;
    NSDictionary *leftOdds, *rightOdds;
    
    if (teamArray.count >= 2) {
        leftTeam = teamArray[0];
        rightTeam = teamArray[1];
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
    [_leftLogoView fq_setImageWithURLString:[NSString stringWithFormat:@"%@%@", kLGImageHost, leftTeam[kMatchTeamKeyLogo]]];
    [_rightLogoView fq_setImageWithURLString:[NSString stringWithFormat:@"%@%@", kLGImageHost, rightTeam[kMatchTeamKeyLogo]]];
    
    [_leftOddsView setTeamDic:leftTeam oddsDic:leftOdds matchName:dataDic[kMatchListKeyMatchName]];
    [_rightOddsView setTeamDic:rightTeam oddsDic:rightOdds matchName:dataDic[kMatchListKeyMatchName]];
}

@end
