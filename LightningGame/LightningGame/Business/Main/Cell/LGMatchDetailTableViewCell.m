//
//  LGMatchDetailTableViewCell.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/13.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchDetailTableViewCell.h"
#import "LGMatchListKeys.h"
#import "LGMatchDetailOddsView.h"

#define kMatchDetailTableViewCellPadding        kSizeScale(8.0)

@interface LGMatchDetailTableViewCell ()

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *groupNameLab;
@property (nonatomic, strong) UIView *oddsGroupView;

@property (nonatomic, strong) NSMutableDictionary *cellHeightDicM;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation LGMatchDetailTableViewCell

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
    
    CGFloat x = kMatchDetailTableViewCellPadding;
    CGFloat padding = kMatchDetailTableViewCellPadding;
    
    _line.frame = CGRectMake(0, 0, kSizeScale(2.0), kSizeScale(14.0));
    _line.center = CGPointMake(x + _line.width * 0.5, padding + _line.height * 0.5);
    _groupNameLab.frame = CGRectMake(CGRectGetMaxX(_line.frame) + x, 0, self.width - (CGRectGetMaxX(_line.frame) + x) * 2, _groupNameLab.font.pointSize * 1.5);
    _groupNameLab.centerY = _line.centerY;
    
    {
        CGFloat y = CGRectGetMaxY(_groupNameLab.frame) + padding;
        
        CGFloat itemWidth = kMatchTeamOddsHViewWidth;
        CGFloat itemHeight = kMatchTeamOddsHViewHeight;
        CGFloat itemPadding = self.width - x * 2 - itemWidth * 2;
        NSInteger countInRow = 2;
        CGFloat totalHeight = 0;
        
        for (int i = 0; i < _oddsGroupView.subviews.count; i++) {
            LGMatchBasicOddsView *oddsView = _oddsGroupView.subviews[i];
            if (![oddsView isKindOfClass:[LGMatchBasicOddsView class]]) {
                continue;
            }
            
            oddsView.frame = CGRectMake((i % countInRow) * (itemWidth + itemPadding), (i / countInRow) * (itemHeight + padding), itemWidth, itemHeight);
            totalHeight = (i / countInRow) * (itemHeight + padding);
        }
        
        totalHeight += (itemHeight);
        _oddsGroupView.frame = CGRectMake(x, y, self.width - x * 2, totalHeight);
    }
}

- (void)initializeUI {
    _line = [UIView new];
    _line.backgroundColor = kMainBgColor;
    [self.contentView addSubview:_line];
    
    _groupNameLab = [UILabel new];
    _groupNameLab.backgroundColor = [UIColor clearColor];
    _groupNameLab.textColor = kNameFontColor;
    _groupNameLab.font = kRegularFont(kNoteFontSize);
    [self.contentView addSubview:_groupNameLab];
    
    _oddsGroupView = [UIView new];
    _oddsGroupView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_oddsGroupView];
}

- (void)setMatchDic:(NSDictionary *)matchDic teamArray:(NSArray *)teamArray oddsArray:(NSArray *)oddsArray {
    _groupNameLab.text = oddsArray.firstObject[kMatchOddsKeyGroupName];
    
    {
        [_oddsGroupView removeAllSubviews];
        for (int i = 0; i < oddsArray.count; i++) {
            NSDictionary *oddsDic = oddsArray[i];
            
            LGMatchDetailOddsView *oddsView = [LGMatchDetailOddsView new];
            [oddsView setTeamDic:teamArray.firstObject oddsDic:oddsDic matchName:matchDic[kMatchKeyMatchName]];
            oddsView.direction = ((i & 1) == 0) ? LGMatchDetailOddsView_Left : LGMatchDetailOddsView_Right;
            [_oddsGroupView addSubview:oddsView];
        }
    }
}

- (void)setCellHeightDic:(NSMutableDictionary *)cellHeightDic indexPath:(NSIndexPath *)indexPath {
    _cellHeightDicM = cellHeightDic;
    _indexPath = indexPath;
}

- (CGSize)sizeThatFits:(CGSize)size {
    if ([[self.cellHeightDicM objectForKey:self.indexPath] floatValue] > 0) {
        return CGSizeMake(size.width, [[self.cellHeightDicM objectForKey:self.indexPath] floatValue]);
    }
    
    CGSize newSize = CGSizeMake(size.width, CGRectGetMaxY(_oddsGroupView.frame));
    [self.cellHeightDicM setObject:@(newSize.height) forKey:self.indexPath];
    
    return newSize;
}

@end
