//
//  LGMatchTeamOddsView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/30.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchTeamOddsView.h"
#import "LGTournamentListKeys.h"
#import "LGMatchParlayView.h"

#define kViewPaddingY                       kSizeScale(4.0)

#define kMatchTeamOddsVViewWidth            kSizeScale(130.0)
#define kMatchTeamOddsVViewHeight           kSizeScale(40.0)

#define kMatchTeamOddsHViewWidth            kSizeScale(150.0)
#define kMatchTeamOddsHViewHeight           kSizeScale(32.0)

@interface LGMatchTeamOddsView ()

@property (nonatomic, copy) NSDictionary *teamDic;
@property (nonatomic, copy) NSDictionary *oddsDic;

@property (nonatomic, strong) UILabel *oddsLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation LGMatchTeamOddsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kMarqueeBgColor;
        self.layer.cornerRadius = kCornerRadius;
        
        _oddsLabel = [UILabel new];
        _oddsLabel.textAlignment = NSTextAlignmentCenter;
        _oddsLabel.textColor = kNameFontColor;
        _oddsLabel.font = kRegularFont(kNameFontSize);
        [self addSubview:_oddsLabel];
        
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = kNameFontColor;
        _nameLabel.font = kRegularFont(kNoteFontSize);
        [self addSubview:_nameLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfOnTapped)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - Public

- (void)setTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic {
    self.teamDic = teamDic;
    self.oddsDic = oddsDic;
    
    _oddsLabel.text = oddsDic[kTournamentOddsKeyOdds];
    _nameLabel.text = teamDic[kTournamentTeamKeyName];
    
    if (kIsNull(oddsDic[kTournamentOddsKeyOdds])) {
        _nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
    } else {
        _oddsLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, kViewPaddingY + CGRectGetHeight(_oddsLabel.frame) * 0.5);
        _nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) - kViewPaddingY - CGRectGetHeight(_nameLabel.frame) * 0.5);
    }
}

#pragma mark - Event

- (void)selfOnTapped {
    [[LGMatchParlayView instance] display];
}

#pragma mark - Setter

- (void)setDirection:(LGMatchTeamOddsViewDirection)direction {
    _direction = direction;
    
    if (self.direction == LGMatchTeamOddsViewDirection_Vertical) {
        self.width = kMatchTeamOddsVViewWidth;
        self.height = kMatchTeamOddsVViewHeight;
        
        _oddsLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * 0.5 - kViewPaddingY);
        _oddsLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, kViewPaddingY + CGRectGetHeight(_oddsLabel.frame) * 0.5);
        
        _nameLabel.frame = _oddsLabel.bounds;
        _nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) - kViewPaddingY - CGRectGetHeight(_nameLabel.frame) * 0.5);
    } else {
        self.width = kMatchTeamOddsHViewWidth;
        self.height = kMatchTeamOddsHViewHeight;
        
        _oddsLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame));
        _oddsLabel.center = CGPointMake(CGRectGetWidth(_oddsLabel.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
        
        _nameLabel.frame = _oddsLabel.bounds;
        _nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(_nameLabel.frame) * 0.5, CGRectGetHeight(self.frame));
    }
}

- (void)setStatus:(LGMatchTeamOddsViewStatus)status {
    _status = status;
    
    switch (status) {
        case LGMatchTeamOddsViewStatus_Enable:
            
            break;
        case LGMatchTeamOddsViewStatus_Disable:
            
            break;
        case LGMatchTeamOddsViewStatus_Locked:
            
            break;
    }
}

@end
