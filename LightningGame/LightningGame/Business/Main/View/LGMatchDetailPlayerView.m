//
//  LGMatchDetailPlayerView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchDetailPlayerView.h"
#import "FQAVPlayerView.h"
#import "LGMatchListKeys.h"
#import "FQComponentFactory.h"
#import "FQImageButton.h"

#define kDetailPlayerViewLeft           kSizeScale(6.0)
#define kDetailPlayerViewTop            kSizeScale(6.0)

@interface LGMatchDetailPlayerView ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *tourNameLabel;

@property (nonatomic, strong) FQAVPlayerView *player;

@property (nonatomic, strong) UIImageView *leftLogoView;
@property (nonatomic, strong) UIImageView *rightLogoView;
@property (nonatomic, strong) FQImageButton *statusBtn;
@property (nonatomic, strong) UILabel *leftTeamLab;
@property (nonatomic, strong) UILabel *rightTeamLab;

@end

@implementation LGMatchDetailPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    CGFloat x = kSizeScale(6.0), y = kSizeScale(6.0);
//
//    _titleView.frame = CGRectMake(x, y, CGRectGetWidth(self.frame) - x * 2, kSizeScale(24.0));
//    _tourNameLabel.frame = CGRectMake(x, 0, CGRectGetWidth(_titleView.frame) - x * 2, CGRectGetHeight(_titleView.frame));
//
//    _player.frame = CGRectMake(0, CGRectGetMaxY(_titleView.frame) + y, self.width, kSizeScale(196.0));
//
//    _statusBtn.center = CGPointMake(self.width * 0.5, self.height - (self.height - CGRectGetMaxY(_player.frame)) * 0.5);
//
//    _leftLogoView.center = CGPointMake(x + _leftLogoView.width * 0.5, _statusBtn.centerY);
//    _rightLogoView.center = CGPointMake(self.width - x - _rightLogoView.width * 0.5, _statusBtn.centerY);
//
//    CGFloat labMaxWidth = (self.width - x * 2 - _leftLogoView.width - _rightLogoView.width - x * 2 - _statusBtn.width - x * 2) * 0.5;
//    _leftTeamLab.width = labMaxWidth;
//    _rightTeamLab.width = labMaxWidth;
//    _leftTeamLab.center = CGPointMake(CGRectGetMaxX(_leftLogoView.frame) + x + _leftTeamLab.width * 0.5, _statusBtn.centerY);
//    _rightTeamLab.center = CGPointMake(CGRectGetMinX(_rightLogoView.frame) - x - _rightTeamLab.width * 0.5, _statusBtn.centerY);
}

- (void)dealloc {
    [self p_stop];
}

- (void)initializeUI {
    CGFloat x = kDetailPlayerViewLeft, y = kDetailPlayerViewTop;
    
    _titleView = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(x, y, CGRectGetWidth(self.frame) - x * 2, kSizeScale(24.0));
        view.backgroundColor = kMarqueeBgColor;
        view.layer.cornerRadius = kCornerRadius;
        view.layer.shouldRasterize = YES;
        view.layer.rasterizationScale = kScreenScale;
        
        _tourNameLabel = [UILabel new];
        _tourNameLabel.frame = CGRectMake(x, 0, CGRectGetWidth(view.frame) - x * 2, CGRectGetHeight(view.frame));
        _tourNameLabel.textAlignment = NSTextAlignmentLeft;
        [view addSubview:_tourNameLabel];
        
        view;
    });
    [self addSubview:_titleView];
    
    {
        _player = [[FQAVPlayerView alloc] init];
        _player.frame = CGRectMake(0, CGRectGetMaxY(_titleView.frame) + y, self.width, kSizeScale(196.0));
        [self addSubview:_player];
    }
    
    {
        _statusBtn = [FQImageButton buttonWithType:UIButtonTypeCustom];
        _statusBtn.imageOrientation = FQImageButtonOrientation_Left;
        _statusBtn.backgroundColor = kRedColor;
        [_statusBtn setImage:[UIImage imageNamed:@"main_notStarted"] forState:UIControlStateNormal];
        [_statusBtn setTitle:kLocalizedString(@"main_match_stop") forState:UIControlStateNormal];
        _statusBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kSizeScale(2.0), 0, kSizeScale(2.0));
        [_statusBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
        _statusBtn.titleLabel.font = kRegularFont(kTinyFontSize);
        [_statusBtn sizeToFit];
        _statusBtn.width += 6.0;
        _statusBtn.height += 4.0;
        _statusBtn.center = CGPointMake(self.width * 0.5, self.height - (self.height - CGRectGetMaxY(_player.frame)) * 0.5);
        _statusBtn.layer.cornerRadius = _statusBtn.height * 0.5;
        _statusBtn.layer.masksToBounds = YES;
        [_statusBtn addTarget:self action:@selector(statusBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_statusBtn];
    }
    
    {
        CGFloat logoWidth = kSizeScale(40.0);
        _leftLogoView = [UIImageView new];
        _leftLogoView.frame = CGRectMake(0, 0, logoWidth, logoWidth);
        _leftLogoView.center = CGPointMake(x + _leftLogoView.width * 0.5, _statusBtn.centerY);
        _leftLogoView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_leftLogoView];
        
        _rightLogoView = [UIImageView new];
        _rightLogoView.frame = CGRectMake(0, 0, logoWidth, logoWidth);
        _rightLogoView.center = CGPointMake(self.width - x - _rightLogoView.width * 0.5, _statusBtn.centerY);
        _rightLogoView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_rightLogoView];
    }
    
    {
        _leftTeamLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
        _leftTeamLab.textColor = kNameFontColor;
        _leftTeamLab.textAlignment = NSTextAlignmentLeft;
        _leftTeamLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:_leftTeamLab];
        
        _rightTeamLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
        _rightTeamLab.textColor = kNameFontColor;
        _rightTeamLab.textAlignment = NSTextAlignmentRight;
        _rightTeamLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
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
    }
    
    {
        NSString *liveUrl = dataDic[kMatchKeyLiveUrl];
        {
            TODO("test data");
            if (liveUrl.length == 0) {
                liveUrl = @"https://www.apple.com/105/media/cn/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-cn-20170912_1280x720h.mp4";
            }
        }
        if (liveUrl.length > 0) {
            [_player setUrlString:liveUrl];
            [_player play];
        }
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
        
        CGFloat x = kDetailPlayerViewLeft;
        CGFloat labMaxWidth = (self.width - x * 2 - _leftLogoView.width - _rightLogoView.width - x * 2 - _statusBtn.width - x * 2) * 0.5;
        _leftTeamLab.width = labMaxWidth;
        _rightTeamLab.width = labMaxWidth;
        _leftTeamLab.center = CGPointMake(CGRectGetMaxX(_leftLogoView.frame) + x + _leftTeamLab.width * 0.5, _statusBtn.centerY);
        _rightTeamLab.center = CGPointMake(CGRectGetMinX(_rightLogoView.frame) - x - _rightTeamLab.width * 0.5, _statusBtn.centerY);
    }
}

#pragma mark - Events

- (void)statusBtnOnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(matchDetailPlayerViewDidStop:)]) {
        [self.delegate matchDetailPlayerViewDidStop:self];
    }
}

#pragma mark - Private

- (void)p_stop {
    [_player stop];
    _player = nil;
}

@end
