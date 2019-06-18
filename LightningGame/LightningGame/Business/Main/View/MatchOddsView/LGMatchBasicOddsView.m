//
//  LGMatchBasicOddsView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/30.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchBasicOddsView.h"
#import "LGMatchListKeys.h"
#import "LGMatchParlayView.h"

@interface LGMatchBasicOddsView ()

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, copy) NSDictionary *teamDic;
@property (nonatomic, strong) NSMutableDictionary *oddsDic;
@property (nonatomic, copy) NSString *matchName;

@end

@implementation LGMatchBasicOddsView

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
    [self setSelected:[self.oddsDic[kMatchOddsExoticKeyIsSelected] boolValue]];
    
    self.oddsLabel.text = oddsDic[kMatchOddsKeyOdds];
    self.nameLabel.text = teamDic[kMatchTeamKeyName];
    [self.nameLabel sizeToFit];
    
    [self setStatus:[oddsDic[kMatchOddsKeyStatus] integerValue]];
}

#pragma mark - Event

- (void)selfOnTapped {
    if (self.status == LGMatchOddsStatus_Normal) {
        self.selected = !self.isSelected;
        
        if (self.isSelected) {
            [[LGMatchParlayView instance] addTeamDic:self.teamDic oddsDic:self.oddsDic matchName:self.matchName];
            
        } else {
            [[LGMatchParlayView instance] removeTeamDic:self.teamDic oddsDic:self.oddsDic matchName:self.matchName];
        }
    }
}

#pragma mark - Setter

- (void)setSelected:(BOOL)selected {
    if (_selected == selected) {
        return;
    }
    
    _selected = selected;
    
    [self.oddsDic setObject:@(self.isSelected) forKey:kMatchOddsExoticKeyIsSelected];
    
    if (selected) {
        self.layer.borderColor = kMainOnTintColor.CGColor;
        self.layer.borderWidth = 1.0;
    } else {
        self.layer.borderWidth = 0.0;
    }
}

@end
