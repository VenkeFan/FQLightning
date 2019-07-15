//
//  LGProfileViewCell.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGProfileViewCell.h"

NSString * const kProfileItemTitleKey = @"kProfileItemTitleKey";
NSString * const kProfileItemBadgeKey = @"kProfileItemBadgeKey";
NSString * const kProfileItemIconKey = @"kProfileItemIconKey";
NSString * const kProfileItemAccessoryInfoKey = @"kProfileItemAccessoryInfoKey";
NSString * const kProfileItemHasAccessoryKey = @"kProfileItemHasAccessoryKey";
NSString * const kProfileItemClassKey = @"kProfileItemClassKey";

@implementation LGProfileViewCell {
    UIView *_containerView;
    UIImageView *_iconImgView;
    UILabel *_titleLab;
    UILabel *_badgeLab;
    UILabel *_accessoryLab;
    UIImageView *_accessoryImgView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _containerView = [UIView new];
        _containerView.backgroundColor = kMainBgColor;
        _containerView.layer.cornerRadius = kCornerRadius;
        _containerView.layer.masksToBounds = YES;
        [self.contentView addSubview:_containerView];
        
        _iconImgView = [UIImageView new];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_containerView addSubview:_iconImgView];
        
        _titleLab = [UILabel new];
        _titleLab.textColor = kNameFontColor;
        _titleLab.font = kRegularFont(kNoteFontSize);
        [_containerView addSubview:_titleLab];
        
        _badgeLab = [UILabel new];
        _badgeLab.hidden = YES;
        _badgeLab.backgroundColor = kRedColor;
        _badgeLab.textColor = [UIColor blackColor];
        _badgeLab.font = kRegularFont(kNoteFontSize);
        _badgeLab.textAlignment = NSTextAlignmentCenter;
        [_containerView addSubview:_badgeLab];
        
        _accessoryLab = [UILabel new];
        _accessoryLab.textColor = kNameFontColor;
        _accessoryLab.font = kRegularFont(kNoteFontSize);
        [_containerView addSubview:_accessoryLab];
        
        _accessoryImgView = [UIImageView new];
        _accessoryImgView.contentMode = UIViewContentModeScaleAspectFit;
        _accessoryImgView.image = [UIImage imageNamed:@"nav_back"];
        _accessoryImgView.transform = CGAffineTransformMakeRotation(M_PI);
        [_accessoryImgView sizeToFit];
        [_containerView addSubview:_accessoryImgView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _containerView.frame = CGRectMake(kCellMarginX, kCellMarginY, self.width - kCellMarginX * 2, self.height - kCellMarginY);
    
    CGFloat centerY = _containerView.height * 0.5;
    
    _iconImgView.center = CGPointMake(kCellMarginX + _iconImgView.width * 0.5, centerY);
    _titleLab.center = CGPointMake(kCellMarginX + CGRectGetMaxX(_iconImgView.frame) + _titleLab.width * 0.5, centerY);
    _badgeLab.center = CGPointMake(kCellMarginX + CGRectGetMaxX(_titleLab.frame) + _badgeLab.width * 0.5, centerY);
    
    if (!_accessoryImgView.hidden) {
        _accessoryImgView.center = CGPointMake(_containerView.width - kCellMarginX - _accessoryImgView.width * 0.5, centerY);
        _accessoryLab.center = CGPointMake(CGRectGetMinX(_accessoryImgView.frame) - kCellMarginX - _accessoryLab.width * 0.5, centerY);
    } else {
        _accessoryLab.center = CGPointMake(_containerView.width - kCellMarginX - _accessoryLab.width * 0.5, centerY);
    }
}

- (void)setItemDic:(NSDictionary *)itemDic {
    _itemDic = [itemDic copy];
    
    _iconImgView.image = [UIImage imageNamed:itemDic[kProfileItemIconKey]];
    [_iconImgView sizeToFit];
    
    _titleLab.text = itemDic[kProfileItemTitleKey];
    [_titleLab sizeToFit];
    
    NSInteger badge = [itemDic[kProfileItemBadgeKey] integerValue];
    if (badge > 0) {
        _badgeLab.hidden = NO;
        _badgeLab.text = [NSString stringWithFormat:@"%ld", badge];
        [_badgeLab sizeToFit];
        _badgeLab.width += 12;
        _badgeLab.height += 2;
        
        _badgeLab.layer.cornerRadius = _badgeLab.height * 0.5;
        _badgeLab.layer.masksToBounds = YES;
    } else {
        _badgeLab.hidden = YES;
    }
    
    BOOL hasAccessory = [itemDic[kProfileItemHasAccessoryKey] boolValue];
    _accessoryImgView.hidden = !hasAccessory;
    
    _accessoryLab.text = itemDic[kProfileItemAccessoryInfoKey];
    [_accessoryLab sizeToFit];
}

@end
