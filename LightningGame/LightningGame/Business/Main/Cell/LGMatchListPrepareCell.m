//
//  LGMatchListPrepareCell.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/19.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchListPrepareCell.h"

@interface LGMatchListPrepareCell ()

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) FQImageButton *topStatusBtn;
@property (nonatomic, strong) FQImageButton *btmStatusBtn;

@end

@implementation LGMatchListPrepareCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat y = kLGMatchListCellMarginY;
    
    {
        _timeLabel.center = CGPointMake(self.containerView.width * 0.5, self.containerView.height * 0.5);
    }
    
    {
        _topStatusBtn.center = CGPointMake(CGRectGetWidth(self.containerView.frame) * 0.5, CGRectGetMaxY(self.titleView.frame) + y + _topStatusBtn.height * 0.5);
        _topStatusBtn.layer.cornerRadius = _topStatusBtn.height * 0.5;
        
        _btmStatusBtn.center = CGPointMake(CGRectGetWidth(self.containerView.frame) * 0.5, self.leftOddsView.centerY);
    }
}

- (void)addSubviews {
    [self generateTimeLabel:&_timeLabel];
    [self.containerView addSubview:_timeLabel];
    
    [self generateTopStatusBtn:&_topStatusBtn];
    [self.containerView addSubview:_topStatusBtn];
    
    [self generateBtmStatusBtn:&_btmStatusBtn];
    [self.containerView addSubview:_btmStatusBtn];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    [super setDataDic:dataDic];
    
    self.timeLabel.text = [dataDic[kMatchKeyStartTime] substringWithRange:NSMakeRange([dataDic[kMatchKeyStartTime] rangeOfString:@" "].location + 1, 5)];
    [self.timeLabel sizeToFit];
    
    [self setTopBtn:_topStatusBtn btmBtn:_btmStatusBtn];
    
    LGMatchStatus status = (LGMatchStatus)[self.dataDic[kMatchKeyStatus] integerValue];
    switch (status) {
        case LGMatchStatus_Prepare: {
            self.timeLabel.hidden = NO;
            
            self.topStatusBtn.hidden = NO;
            self.btmStatusBtn.hidden = NO;
        }
            break;
        default: {
            self.timeLabel.hidden = YES;
            
            self.topStatusBtn.hidden = YES;
            self.btmStatusBtn.hidden = YES;
        }
            break;
    }
}

@end
