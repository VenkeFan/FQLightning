//
//  LGMatchListOddsView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/14.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchListOddsView.h"

#define kViewPaddingY                       kSizeScale(4.0)
#define kMatchTeamOddsVViewWidth            kSizeScale(130.0)
#define kMatchTeamOddsVViewHeight           kSizeScale(40.0)

@implementation LGMatchListOddsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, kMatchTeamOddsVViewWidth, kMatchTeamOddsVViewHeight)]) {
        
        self.oddsLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * 0.5 - kViewPaddingY);
        self.oddsLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, kViewPaddingY + CGRectGetHeight(self.oddsLabel.frame) * 0.5);
        
        self.nameLabel.frame = self.oddsLabel.bounds;
        self.nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) - kViewPaddingY - CGRectGetHeight(self.nameLabel.frame) * 0.5);
    }
    return self;
}

- (void)setStatus:(LGMatchBasicOddsViewStatus)status {
    [super setStatus:status];
    
    self.oddsLabel.hidden = YES;
    self.lockLayer.hidden = YES;
    
    switch (status) {
        case LGMatchBasicOddsViewStatus_Enable: {
            self.oddsLabel.hidden = NO;
            
            self.oddsLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, kViewPaddingY + CGRectGetHeight(self.oddsLabel.frame) * 0.5);
            self.nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) - kViewPaddingY - CGRectGetHeight(self.nameLabel.frame) * 0.5);
        }
            break;
        case LGMatchBasicOddsViewStatus_Disable: {
            self.nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
        }
            break;
        case LGMatchBasicOddsViewStatus_Locked: {
            self.lockLayer.hidden = NO;
            
            self.lockLayer.position = CGPointMake(CGRectGetWidth(self.frame) * 0.5, kViewPaddingY + CGRectGetHeight(self.oddsLabel.frame) * 0.5);
            self.nameLabel.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) - kViewPaddingY - CGRectGetHeight(self.nameLabel.frame) * 0.5);
        }
            break;
    }
}

@end
