//
//  LGMatchDetailOddsView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/14.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchDetailOddsView.h"
#import "LGMatchListKeys.h"

#define kMaxNameLabelWidth                  ((kMatchTeamOddsHViewWidth - kViewPaddingX) * 4 / 5.0)
#define kMaxOddsLabelWidth                  ((kMatchTeamOddsHViewWidth - kViewPaddingX) * 1 / 5.0)

@interface LGMatchDetailOddsView ()

@property (nonatomic, strong) CALayer *flagLayer;

@end

@implementation LGMatchDetailOddsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, kMatchTeamOddsHViewWidth, kMatchTeamOddsHViewHeight)]) {
        
        self.nameLabel.frame = CGRectMake(0, 0, self.nameLabel.width, self.height);
        self.nameLabel.center = CGPointMake(kViewPaddingX + self.nameLabel.width * 0.5, self.height * 0.5);
        
        self.oddsLabel.frame = CGRectMake(0, 0, kMaxOddsLabelWidth, self.height);
        self.oddsLabel.center = CGPointMake(self.width - kViewPaddingX - self.oddsLabel.width * 0.5, self.height * 0.5);
        
        _flagLayer = [CALayer layer];
        _flagLayer.hidden = YES;
        _flagLayer.frame = CGRectMake(0, 0, kSizeScale(22.0), kSizeScale(32.0));
        _flagLayer.contentsScale = kScreenScale;
        _flagLayer.contentsGravity = kCAGravityResizeAspect;
        [self.layer addSublayer:_flagLayer];
    }
    return self;
}

- (void)setTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic matchName:(nonnull NSString *)matchName {
    [super setTeamDic:teamDic oddsDic:oddsDic matchName:matchName];
    
    self.nameLabel.text = oddsDic[kMatchOddsKeyName];
    [self.nameLabel sizeToFit];
    
    self.flagLayer.contents = [oddsDic[kMatchOddsKeyWin] integerValue] == 1 ?
    (__bridge id)[UIImage imageNamed:@"main_win"].CGImage :
    (__bridge id)[UIImage imageNamed:@"main_lose"].CGImage;
}

- (void)setDirection:(LGMatchDetailOddsViewDirection)direction {
    _direction = direction;
    
    [self p_updateLayout];
}

- (void)setStatus:(LGMatchOddsStatus)status {
    [super setStatus:status];
    
    [self p_updateLayout];
}

- (void)p_updateLayout {
    [self adjustNameLabelFont];
    
    switch (self.direction) {
        case LGMatchDetailOddsView_Left: {
            self.nameLabel.center = CGPointMake(kViewPaddingX + self.nameLabel.width * 0.5, self.height * 0.5);
            
            self.oddsLabel.frame = CGRectMake(0, 0, kMaxOddsLabelWidth, self.height);
            self.oddsLabel.center = CGPointMake(self.width - kViewPaddingX - self.oddsLabel.width * 0.5, self.height * 0.5);
        }
            break;
        case LGMatchDetailOddsView_Right: {
            self.oddsLabel.frame = CGRectMake(0, 0, kMaxOddsLabelWidth, self.height);
            self.oddsLabel.center = CGPointMake(kViewPaddingX + self.oddsLabel.width * 0.5, self.height * 0.5);
            
            self.nameLabel.center = CGPointMake(self.width - kViewPaddingX - self.nameLabel.width * 0.5, self.height * 0.5);
        }
            break;
    }
    
    
    self.oddsLabel.hidden = YES;
    self.lockLayer.hidden = YES;
    self.flagLayer.hidden = YES;
    
    switch (self.status) {
        case LGMatchOddsStatus_Normal: {
            self.oddsLabel.hidden = NO;
            
            self.nameLabel.centerY = self.height * 0.5;
            self.oddsLabel.centerY = self.height * 0.5;
        }
            break;
        case LGMatchOddsStatus_Locked: {
            self.lockLayer.hidden = NO;
            
            self.nameLabel.centerY = self.height * 0.5;
            self.oddsLabel.centerY = self.height * 0.5;
        }
            break;
        case LGMatchOddsStatus_Hidden: {
            self.nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
        }
            break;
        case LGMatchOddsStatus_Finished: {
            self.flagLayer.hidden = NO;
            
            self.nameLabel.centerY = self.height * 0.5;
            self.oddsLabel.centerY = self.height * 0.5;
        }
            break;
        case LGMatchOddsStatus_Exception: {
            self.nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
        }
            break;
        default: {
            self.nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
        }
            break;
    }
    
    self.lockLayer.position = self.oddsLabel.center;
    self.flagLayer.position = self.oddsLabel.center;
}

- (void)adjustNameLabelFont {
    [self adjustNameLabelFont:self.nameLabel maxWidth:kMaxNameLabelWidth];
}

@end
