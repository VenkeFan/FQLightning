//
//  LGMatchDetailOddsView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/14.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchDetailOddsView.h"
#import "LGMatchListKeys.h"

#define kViewPaddingX                       kSizeScale(6.0)

#define kMaxNameLabelWidth                  (kMatchTeamOddsHViewWidth * 4 / 5.0)
#define kMaxOddsLabelWidth                  (kMatchTeamOddsHViewWidth * 1 / 5.0)

@interface LGMatchDetailOddsView ()

@property (nonatomic, assign) CGFloat nameLabelWidth;

@end

@implementation LGMatchDetailOddsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, kMatchTeamOddsHViewWidth, kMatchTeamOddsHViewHeight)]) {
        
        self.nameLabel.frame = CGRectMake(0, 0, self.nameLabelWidth, self.height);
        self.nameLabel.center = CGPointMake(kViewPaddingX + self.nameLabel.width * 0.5, self.height * 0.5);
        
        self.oddsLabel.frame = CGRectMake(0, 0, kMaxOddsLabelWidth, self.height);
        self.oddsLabel.center = CGPointMake(self.width - kViewPaddingX - self.oddsLabel.width * 0.5, self.height * 0.5);
    }
    return self;
}

- (void)setDirection:(LGMatchDetailOddsViewDirection)direction {
    _direction = direction;
    
    switch (direction) {
        case LGMatchDetailOddsView_Left: {
            self.nameLabel.center = CGPointMake(kViewPaddingX + self.nameLabelWidth * 0.5, self.height * 0.5);
            
            self.oddsLabel.frame = CGRectMake(0, 0, kMaxOddsLabelWidth, self.height);
            self.oddsLabel.center = CGPointMake(self.width - kViewPaddingX - self.oddsLabel.width * 0.5, self.height * 0.5);
        }
            break;
        case LGMatchDetailOddsView_Right: {
            self.oddsLabel.frame = CGRectMake(0, 0, kMaxOddsLabelWidth, self.height);
            self.oddsLabel.center = CGPointMake(kViewPaddingX + self.oddsLabel.width * 0.5, self.height * 0.5);
            
            self.nameLabel.center = CGPointMake(self.width - kViewPaddingX - self.nameLabelWidth * 0.5, self.height * 0.5);
        }
            break;
    }
    
    self.lockLayer.position = self.oddsLabel.center;
}

- (void)setTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic matchName:(nonnull NSString *)matchName {
    [super setTeamDic:teamDic oddsDic:oddsDic matchName:matchName];
    
    self.nameLabel.text = oddsDic[kMatchOddsKeyName];
    [self.nameLabel sizeToFit];
}

- (void)setStatus:(LGMatchOddsStatus)status {
    [super setStatus:status];
    
    self.oddsLabel.hidden = YES;
    self.lockLayer.hidden = YES;
    
    self.nameLabel.centerY = self.height * 0.5;
    self.oddsLabel.centerY = self.height * 0.5;
    
    switch (status) {
        case LGMatchOddsStatus_Normal: {
            self.oddsLabel.hidden = NO;
        }
            break;
        case LGMatchOddsStatus_Locked: {
            self.lockLayer.hidden = NO;
        }
            break;
        case LGMatchOddsStatus_Hidden: {
            
        }
            break;
        case LGMatchOddsStatus_Finished: {
            
        }
            break;
        case LGMatchOddsStatus_Exception: {
            
        }
            break;
    }
    
//    switch (status) {
//        case LGMatchOddsStatus_Enable: {
//            self.oddsLabel.hidden = NO;
//        }
//            break;
//        case LGMatchOddsStatus_Disable: {
//            
//        }
//            break;
//        case LGMatchOddsStatus_Locked: {
//            self.lockLayer.hidden = NO;
//        }
//            break;
//    }
}

- (CGFloat)nameLabelWidth {
//    CGFloat labWidth = self.nameLabel.width;
//    return labWidth > kMaxNameLabelWidth ? kMaxNameLabelWidth: labWidth;
    
    
    if (self.nameLabel.width > kMaxNameLabelWidth) {
        [self adjustNameLabelFont];
    }
    return self.nameLabel.width;
}

- (void)adjustNameLabelFont {
    UIFont *font = self.nameLabel.font;
    UIFont *newFont = [UIFont fontWithName:font.familyName size:font.pointSize - 2.0];
    self.nameLabel.font = newFont;
    [self.nameLabel sizeToFit];
    
    if (self.nameLabel.width > kMaxNameLabelWidth) {
        [self adjustNameLabelFont];
    }
}

@end
