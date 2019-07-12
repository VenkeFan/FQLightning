//
//  LGParlayHistoryCell.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/12.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGParlayHistoryCell.h"
#import "LGOrderMetaKeys.h"
#import "FQComponentFactory.h"
#import "NSDate+FQExtension.h"

@interface LGParlayHistoryCell () {
    UIView *_containerView;
    
    UILabel *_groupNameLab;
    UILabel *_tourNameLabel;
    UIView *_lineView1;
    UILabel *_matchNameLab;
    UILabel *_startTimeLab;
    UILabel *_oddsLab;
    UIView *_lineView2;
    UILabel *_betHintLab;
    UILabel *_betLab;
    UILabel *_gainHintLab;
    UILabel *_gainLab;
    UILabel *_orderHintLab;
}

@end

@implementation LGParlayHistoryCell

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
    
    _containerView.frame = CGRectMake(kCellMarginX, kCellMarginY, CGRectGetWidth(self.frame) - kCellMarginX * 2, kLGParlayHistoryCellContainerHeight);
    
    CGFloat x = kSizeScale(6.0), y = kSizeScale(12.0);
    
    _groupNameLab.center = CGPointMake(x * 2 + _groupNameLab.width * 0.5, y + _groupNameLab.height * 0.5);
    _tourNameLabel.center = CGPointMake(_containerView.width - x * 2 - _tourNameLabel.width * 0.5, _groupNameLab.centerY);
    _lineView1.frame = CGRectMake(x, CGRectGetMaxY(_groupNameLab.frame) + y, _containerView.width - x * 2, 1.0);
    
    _matchNameLab.left = x * 2;
    _matchNameLab.top = CGRectGetMaxY(_lineView1.frame) + y;
    _startTimeLab.left = x * 2;
    _startTimeLab.top = CGRectGetMaxY(_matchNameLab.frame) + y * 0.25;
    _oddsLab.left = x * 2;
    _oddsLab.top = CGRectGetMaxY(_startTimeLab.frame) + y * 0.25;
    _lineView2.frame = CGRectMake(x, CGRectGetMaxY(_oddsLab.frame) + y, _containerView.width - x * 2, 1.0);
    
    _betHintLab.left = x * 2;
    _betHintLab.top = CGRectGetMaxY(_lineView2.frame) + y;
    _betLab.left = x * 2;
    _betLab.top = CGRectGetMaxY(_betHintLab.frame) + y * 0.25;
    _gainHintLab.center = CGPointMake(_containerView.width - x * 2 - _gainHintLab.width * 0.5, _betHintLab.centerY);
    _gainLab.center = CGPointMake(_containerView.width - x * 2 - _gainLab.width * 0.5, _betLab.centerY);
    
    _orderHintLab.center = CGPointMake(x * 2 + _orderHintLab.width * 0.5, CGRectGetMaxY(_gainLab.frame) + y + _orderHintLab.height * 0.5);
}

- (void)initializeUI {
    _containerView = [UIView new];
    _containerView.backgroundColor = kCellBgColor;
    _containerView.layer.cornerRadius = kCornerRadius;
    _containerView.layer.shouldRasterize = YES;
    _containerView.layer.rasterizationScale = kScreenScale;
    [self.contentView addSubview:_containerView];
    
    _groupNameLab = [FQComponentFactory labelWithFont:kRegularFont(kNameFontSize)];
    _groupNameLab.textColor = kNameFontColor;
    [_containerView addSubview:_groupNameLab];
    
    _tourNameLabel = [FQComponentFactory labelWithFont:kRegularFont(kNameFontSize)];
    [_containerView addSubview:_tourNameLabel];
    
    _lineView1 = [UIView new];
    _lineView1.backgroundColor = kSeparateLineColor;
    [_containerView addSubview:_lineView1];
    
    _matchNameLab = [FQComponentFactory labelWithFont:kRegularFont(kFieldFontSize)];
    _matchNameLab.textColor = kNameFontColor;
    [_containerView addSubview:_matchNameLab];
    
    _startTimeLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
    _startTimeLab.textColor = kOrderTintFontColor;
    [_containerView addSubview:_startTimeLab];
    
    _oddsLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
    _oddsLab.textColor = kOrderTintFontColor;
    [_containerView addSubview:_oddsLab];
    
    _lineView2 = [UIView new];
    _lineView2.backgroundColor = kSeparateLineColor;
    [_containerView addSubview:_lineView2];
    
    _betHintLab = [FQComponentFactory labelWithFont:kRegularFont(kFieldFontSize)];
    _betHintLab.text = kLocalizedString(@"order_single");
    _betHintLab.textColor = kNameFontColor;
    [_betHintLab sizeToFit];
    [_containerView addSubview:_betHintLab];
    
    _betLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
    _betLab.textColor = kNameFontColor;
    [_containerView addSubview:_betLab];
    
    _gainHintLab = [FQComponentFactory labelWithFont:kRegularFont(kFieldFontSize)];
    _gainHintLab.textColor = kMainOnTintColor;
    [_containerView addSubview:_gainHintLab];
    
    _gainLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
    [_containerView addSubview:_gainLab];
    
    _orderHintLab = [FQComponentFactory labelWithFont:kRegularFont(kTinyFontSize)];
    _orderHintLab.textColor = kOrderTintFontColor;
    [_containerView addSubview:_orderHintLab];
}

- (void)setItemDic:(NSDictionary *)itemDic {
    {
        NSString *teamName = [itemDic objectForKey:kOrderMetaKeyOddsName];
        NSString *groupName = [itemDic objectForKey:kOrderMetaKeyGroupName];
        _groupNameLab.text = [NSString stringWithFormat:@"%@ %@", groupName, teamName];
        [_groupNameLab sizeToFit];
        
        //        NSString *tourName = dataDic[kMatchKeyTournamentName];
        //        NSString *round = [dataDic[kMatchKeyRound] uppercaseString];
        //        NSMutableString *strM = [NSMutableString stringWithFormat:@"%@/%@", tourName, round];
        //        NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:strM];
        //        [strAttr addAttributes:@{NSFontAttributeName: kRegularFont(kNameFontSize)} range:NSMakeRange(0, strM.length)];
        //        [strAttr addAttributes:@{NSForegroundColorAttributeName: kNameFontColor} range:NSMakeRange(0, tourName.length)];
        //        [strAttr addAttributes:@{NSForegroundColorAttributeName: kMainOnTintColor} range:NSMakeRange(tourName.length, strM.length - tourName.length)];
        //
        //        _tourNameLabel.attributedText = strAttr;
    }
    
    {
        _matchNameLab.text = [itemDic objectForKey:kOrderMetaKeyMatchName];
        [_matchNameLab sizeToFit];
        
        NSTimeInterval timeStamp = [itemDic[kOrderMetaKeyMatchStartTimeStamp] doubleValue];
        NSDate *date = [NSDate dateWithTimestamp:timeStamp];
        _startTimeLab.text = [NSString stringWithFormat:@"开始时间: %@", [date ISO8601String]];
        [_startTimeLab sizeToFit];
        
        _oddsLab.text = [NSString stringWithFormat:@"赔率: %@", itemDic[kOrderMetaKeyBetOddsValue]];
        [_oddsLab sizeToFit];
    }
    
    {
        _gainHintLab.text = [itemDic[kOrderMetaKeyOrderStatus] integerValue] == LGOrderStatus_UnSettle ? @"未结算" : @"已结算";
        [_gainHintLab sizeToFit];
        
        _betLab.text = [NSString stringWithFormat:@"投注金额: %@", itemDic[kOrderMetaKeyBetMoney]];
        [_betLab sizeToFit];
        
        NSString *hint = @"预计最高返还: ";
        NSString *gain = itemDic[kOrderMetaKeyGainMoney];
        NSMutableString *strM = [NSMutableString stringWithFormat:@"%@%@", hint, gain];
        NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:strM];
        [strAttr addAttributes:@{NSFontAttributeName: kRegularFont(kNoteFontSize)} range:NSMakeRange(0, strM.length)];
        [strAttr addAttributes:@{NSForegroundColorAttributeName: kNameFontColor} range:NSMakeRange(0, hint.length)];
        [strAttr addAttributes:@{NSForegroundColorAttributeName: kMainOnTintColor} range:NSMakeRange(hint.length, strM.length - hint.length)];
        _gainLab.attributedText = strAttr;
        [_gainLab sizeToFit];
        
        _orderHintLab.text = [NSString stringWithFormat:@"订单号: %@", itemDic[kOrderMetaKeyOrderNumber]];
        [_orderHintLab sizeToFit];
    }
}

@end
