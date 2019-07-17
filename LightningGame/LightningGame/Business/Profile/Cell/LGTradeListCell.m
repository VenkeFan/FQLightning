//
//  LGTradeListCell.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGTradeListCell.h"
#import "LGTradeHistoryKeys.h"
#import "NSDate+FQExtension.h"

@interface LGTradeListCell () {
    UIView *_containerView;
    UILabel *_typeLab;
    UILabel *_timeLab;
    UILabel *_moneyLab;
    UILabel *_statusLab;
}

@end

@implementation LGTradeListCell

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
    
    _containerView.frame = CGRectMake(kCellMarginX, kCellMarginY, CGRectGetWidth(self.frame) - kCellMarginX * 2, kLGTradeListCellContainerHeight);
    
    CGFloat marginY = kCellMarginY;
    
    _typeLab.left = kCellMarginX;
    _typeLab.top = marginY;
    
    _timeLab.left = kCellMarginX;
    _timeLab.top = CGRectGetMaxY(_typeLab.frame) + kSizeScale(4.0);
    
    _moneyLab.center = CGPointMake(_containerView.width - kCellMarginX - _moneyLab.width * 0.5, _typeLab.centerY);
    _statusLab.center = CGPointMake(_containerView.width - kCellMarginX - _statusLab.width * 0.5, _timeLab.centerY);
}

- (void)initializeUI {
    _containerView = [UIView new];
    _containerView.backgroundColor = kMainBgColor;
    _containerView.layer.cornerRadius = kCornerRadius;
    _containerView.layer.shouldRasterize = YES;
    _containerView.layer.rasterizationScale = kScreenScale;
    [self.contentView addSubview:_containerView];
    
    _typeLab = [UILabel new];
    _typeLab.textColor = kScoreFontColor;
    _typeLab.font = kRegularFont(kNameFontSize);
    [_containerView addSubview:_typeLab];
    
    _timeLab = [UILabel new];
    _timeLab.textColor = kNameFontColor;
    _timeLab.font = kRegularFont(kTinyFontSize);
    [_containerView addSubview:_timeLab];
    
    _moneyLab = [UILabel new];
    _moneyLab.textColor = kScoreFontColor;
    _moneyLab.font = kRegularFont(kNameFontSize);
    [_containerView addSubview:_moneyLab];
    
    _statusLab = [UILabel new];
    _statusLab.font = kRegularFont(kTinyFontSize);
    [_containerView addSubview:_statusLab];
}

- (void)setItemDic:(NSDictionary *)itemDic {
    _itemDic = [itemDic copy];
    
    LGTradeType type = (LGTradeType)[itemDic[kTradeHistoryKeyType] integerValue];
    _typeLab.text = tradeTypeMapping(type);
    [_typeLab sizeToFit];
    
    _timeLab.text = [[NSDate dateWithTimestamp:[itemDic[kTradeHistoryKeyTimestamp] longLongValue]] ISO8601StringDateAndTime];
    [_timeLab sizeToFit];
    
    _moneyLab.text = itemDic[kTradeHistoryKeyMoney];
    [_moneyLab sizeToFit];
    
    _statusLab.textColor = kNameFontColor;
    if (type == LGTradeTypeCharge) {
        LGTradeChargeStatus status = (LGTradeChargeStatus)[itemDic[kTradeHistoryKeyChargeStatus] integerValue];
        _statusLab.text = chargeStatusMapping(status);
        
        if (status == LGTradeChargeStatusSuccees) {
            _statusLab.textColor = kMainOnTintColor;
        } else if (status == LGTradeChargeStatusFailure) {
            _statusLab.textColor = kRedColor;
        }
        
    } else if (type == LGTradeTypeWithdraw) {
        LGTradeWithdrawStatus status = (LGTradeWithdrawStatus)[itemDic[kTradeHistoryKeyWithdrawStatus] integerValue];
        _statusLab.text = withdrawStatusMapping(status);
        
        if (status == LGTradeWithdrawStatusSuccees) {
            _statusLab.textColor = kMainOnTintColor;
        } else if (status == LGTradeWithdrawStatusFailure) {
            _statusLab.textColor = kRedColor;
        }
    }
    [_statusLab sizeToFit];
}

@end
