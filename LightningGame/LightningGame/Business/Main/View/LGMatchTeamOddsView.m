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

@property (nonatomic, assign) LGMatchTeamOddsViewStatus status;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, copy) NSDictionary *teamDic;
@property (nonatomic, strong) NSMutableDictionary *oddsDic;
@property (nonatomic, copy) NSString *matchName;

@property (nonatomic, strong) UILabel *oddsLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) CALayer *lockLayer;

@end

@implementation LGMatchTeamOddsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kMarqueeBgColor;
        self.layer.cornerRadius = kCornerRadius;
        _selected = NO;
        
        _oddsLabel = [UILabel new];
        _oddsLabel.textAlignment = NSTextAlignmentCenter;
        _oddsLabel.textColor = kNameFontColor;
        _oddsLabel.font = kRegularFont(kNameFontSize);
        [self addSubview:_oddsLabel];
        
        _lockLayer = [CALayer layer];
        UIImage *img = [UIImage imageNamed:@"main_lock"];
        _lockLayer.frame = (CGRect){.origin = CGPointZero, .size = img.size};
        _lockLayer.contents = (__bridge id)img.CGImage;
        _lockLayer.contentsScale = [[UIScreen mainScreen] scale];
        _lockLayer.contentsGravity = kCAGravityResizeAspect;
        [self.layer addSublayer:_lockLayer];
        
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

- (void)setTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic matchName:(nonnull NSString *)matchName {
    self.teamDic = teamDic;
    self.oddsDic = (NSMutableDictionary *)oddsDic;
    self.matchName = matchName;
    [self setSelected:[self.oddsDic[kTournamentOddsExoticKeyIsSelected] boolValue]];
    
    _oddsLabel.hidden = YES;
    _lockLayer.hidden = YES;
    
    _oddsLabel.text = oddsDic[kTournamentOddsKeyOdds];
    _nameLabel.text = teamDic[kTournamentTeamKeyName];
    
    if (kIsNull(oddsDic[kTournamentOddsKeyOdds])) {
        [self setStatus:LGMatchTeamOddsViewStatus_Disable];
    } else {
        if ([oddsDic[kTournamentOddsKeyStatus] integerValue] == 2) {
            [self setStatus:LGMatchTeamOddsViewStatus_Enable];
        } else {
            [self setStatus:LGMatchTeamOddsViewStatus_Locked];
        }
    }
}

#pragma mark - Event

- (void)selfOnTapped {
    if (self.status == LGMatchTeamOddsViewStatus_Enable) {
        self.selected = !self.isSelected;
        
        if (self.isSelected) {
            [[LGMatchParlayView instance] addTeamDic:self.teamDic oddsDic:self.oddsDic matchName:self.matchName];
            
        } else {
            [[LGMatchParlayView instance] removeTeamDic:self.teamDic oddsDic:self.oddsDic matchName:self.matchName];
        }
    }
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

- (void)setSelected:(BOOL)selected {
    if (_selected == selected) {
        return;
    }
    
    _selected = selected;
    
    [self.oddsDic setObject:@(self.isSelected) forKey:kTournamentOddsExoticKeyIsSelected];
    
    if (selected) {
        self.layer.borderColor = kMainOnTintColor.CGColor;
        self.layer.borderWidth = 1.0;
    } else {
        self.layer.borderWidth = 0.0;
    }
}

- (void)setStatus:(LGMatchTeamOddsViewStatus)status {
    _status = status;
    
    switch (status) {
        case LGMatchTeamOddsViewStatus_Enable: {
            _oddsLabel.hidden = NO;
            
            _oddsLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, kViewPaddingY + CGRectGetHeight(_oddsLabel.frame) * 0.5);
            _nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) - kViewPaddingY - CGRectGetHeight(_nameLabel.frame) * 0.5);
        }
            break;
        case LGMatchTeamOddsViewStatus_Disable: {
            _nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
        }
            break;
        case LGMatchTeamOddsViewStatus_Locked:
            _lockLayer.hidden = NO;
            
            _lockLayer.position = CGPointMake(CGRectGetWidth(self.frame) * 0.5, kViewPaddingY + CGRectGetHeight(_oddsLabel.frame) * 0.5);
            _nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) - kViewPaddingY - CGRectGetHeight(_nameLabel.frame) * 0.5);
            break;
    }
}

@end
