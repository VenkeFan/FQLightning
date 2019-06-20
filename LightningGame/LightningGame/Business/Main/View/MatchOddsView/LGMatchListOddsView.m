//
//  LGMatchListOddsView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/14.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchListOddsView.h"

#define kMatchTeamOddsVViewWidth            kSizeScale(130.0)
#define kMatchTeamOddsVViewHeight           kSizeScale(40.0)

@implementation LGMatchListOddsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, kMatchTeamOddsVViewWidth, kMatchTeamOddsVViewHeight)]) {
        
        self.oddsLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * 0.5 - kViewPaddingY);
        self.oddsLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, kViewPaddingY + CGRectGetHeight(self.oddsLabel.frame) * 0.5);
        
        self.nameLabel.frame = self.oddsLabel.bounds; // CGRectMake(0, 0, [self nameLabelWidth], self.oddsLabel.height);
        self.nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) - kViewPaddingY - CGRectGetHeight(self.nameLabel.frame) * 0.5);
    }
    return self;
}

- (void)setStatus:(LGMatchOddsStatus)status {
    [super setStatus:status];
    
    self.oddsLabel.hidden = YES;
    self.lockLayer.hidden = YES;
    
    [self adjustNameLabelFont];
    
    switch (status) {
        case LGMatchOddsStatus_Normal: {
            self.oddsLabel.hidden = NO;
            
            self.oddsLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, kViewPaddingY + CGRectGetHeight(self.oddsLabel.frame) * 0.5);
            self.nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) - kViewPaddingY - CGRectGetHeight(self.nameLabel.frame) * 0.5);
        }
            break;
        case LGMatchOddsStatus_Locked: {
            self.lockLayer.hidden = NO;
            
            self.lockLayer.position = CGPointMake(CGRectGetWidth(self.frame) * 0.5, kViewPaddingY + CGRectGetHeight(self.oddsLabel.frame) * 0.5);
            self.nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) - kViewPaddingY - CGRectGetHeight(self.nameLabel.frame) * 0.5);
        }
            break;
        case LGMatchOddsStatus_Hidden: {
            self.nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
        }
            break;
        case LGMatchOddsStatus_Finished: {
            self.nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
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
}

- (void)adjustNameLabelFont {
    [self adjustNameLabelFont:self.nameLabel maxWidth:self.width - kViewPaddingX * 2];
}

@end
