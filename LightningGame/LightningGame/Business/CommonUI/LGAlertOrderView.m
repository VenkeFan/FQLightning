//
//  LGAlertOrderView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/24.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGAlertOrderView.h"
#import "LGOrderMetaKeys.h"
#import "FQComponentFactory.h"
#import "NSDate+FQExtension.h"
#import "CTMediator+LGProfileActions.h"

@interface LGAlertOrderMetaCell : UITableViewCell

- (void)setOrderDic:(NSDictionary *)orderDic;

@end

@implementation LGAlertOrderMetaCell {
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
    UIView *_cellLine;
}

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
    
    CGFloat x = kSizeScale(6.0), y = kSizeScale(12.0);
    
    _groupNameLab.center = CGPointMake(x * 2 + _groupNameLab.width * 0.5, y + _groupNameLab.height * 0.5);
    _tourNameLabel.center = CGPointMake(self.contentView.width - x * 2 - _tourNameLabel.width * 0.5, _groupNameLab.centerY);
    _lineView1.frame = CGRectMake(x, CGRectGetMaxY(_groupNameLab.frame) + y, self.contentView.width - x * 2, 1.0);
    
    _matchNameLab.left = x * 2;
    _matchNameLab.top = CGRectGetMaxY(_lineView1.frame) + y;
    _startTimeLab.left = x * 2;
    _startTimeLab.top = CGRectGetMaxY(_matchNameLab.frame) + y * 0.25;
    _oddsLab.left = x * 2;
    _oddsLab.top = CGRectGetMaxY(_startTimeLab.frame) + y * 0.25;
    _lineView2.frame = CGRectMake(x, CGRectGetMaxY(_oddsLab.frame) + y, self.contentView.width - x * 2, 1.0);
    
    _betHintLab.left = x * 2;
    _betHintLab.top = CGRectGetMaxY(_lineView2.frame) + y;
    _betLab.left = x * 2;
    _betLab.top = CGRectGetMaxY(_betHintLab.frame) + y * 0.25;
    _gainHintLab.center = CGPointMake(self.contentView.width - x * 2 - _gainHintLab.width * 0.5, _betHintLab.centerY);
    _gainLab.center = CGPointMake(self.contentView.width - x * 2 - _gainLab.width * 0.5, _betLab.centerY);
    
    _orderHintLab.center = CGPointMake(x * 2 + _orderHintLab.width * 0.5, CGRectGetMaxY(_gainLab.frame) + y + _orderHintLab.height * 0.5);
    _cellLine.frame = CGRectMake(0, self.contentView.height - 2.0, self.contentView.width, 2.0);
}

- (void)initializeUI {
    _groupNameLab = [FQComponentFactory labelWithFont:kRegularFont(kNameFontSize)];
    _groupNameLab.textColor = kNameFontColor;
    [self.contentView addSubview:_groupNameLab];
    
    _tourNameLabel = [FQComponentFactory labelWithFont:kRegularFont(kNameFontSize)];
    [self.contentView addSubview:_tourNameLabel];
    
    _lineView1 = [UIView new];
    _lineView1.backgroundColor = kSeparateLineColor;
    [self.contentView addSubview:_lineView1];
    
    _matchNameLab = [FQComponentFactory labelWithFont:kRegularFont(kFieldFontSize)];
    _matchNameLab.textColor = kNameFontColor;
    [self.contentView addSubview:_matchNameLab];
    
    _startTimeLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
    _startTimeLab.textColor = kOrderTintFontColor;
    [self.contentView addSubview:_startTimeLab];
    
    _oddsLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
    _oddsLab.textColor = kOrderTintFontColor;
    [self.contentView addSubview:_oddsLab];
    
    _lineView2 = [UIView new];
    _lineView2.backgroundColor = kSeparateLineColor;
    [self.contentView addSubview:_lineView2];
    
    _betHintLab = [FQComponentFactory labelWithFont:kRegularFont(kFieldFontSize)];
    _betHintLab.text = kLocalizedString(@"order_single");
    _betHintLab.textColor = kNameFontColor;
    [_betHintLab sizeToFit];
    [self.contentView addSubview:_betHintLab];
    
    _betLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
    _betLab.textColor = kNameFontColor;
    [self.contentView addSubview:_betLab];
    
    _gainHintLab = [FQComponentFactory labelWithFont:kRegularFont(kFieldFontSize)];
    _gainHintLab.text = kLocalizedString(@"order_succeed2");
    _gainHintLab.textColor = kMainOnTintColor;
    [_gainHintLab sizeToFit];
    [self.contentView addSubview:_gainHintLab];
    
    _gainLab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
    [self.contentView addSubview:_gainLab];
    
    _orderHintLab = [FQComponentFactory labelWithFont:kRegularFont(kTinyFontSize)];
    _orderHintLab.text = kLocalizedString(@"order_tip");
    _orderHintLab.textColor = kOrderTintFontColor;
    [_orderHintLab sizeToFit];
    [self.contentView addSubview:_orderHintLab];
    
    _cellLine = [UIView new];
    _cellLine.backgroundColor = kMarqueeBgColor;
    [self.contentView addSubview:_cellLine];
}

- (void)setOrderDic:(NSDictionary *)orderDic {
    {
        NSString *teamName = [orderDic objectForKey:kOrderMetaKeyOddsName];
        NSString *groupName = [orderDic objectForKey:kOrderMetaKeyGroupName];
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
        _matchNameLab.text = [orderDic objectForKey:kOrderMetaKeyMatchName];
        [_matchNameLab sizeToFit];
        
        NSTimeInterval timeStamp = [orderDic[kOrderMetaKeyMatchStartTimeStamp] doubleValue];
        NSDate *date = [NSDate dateWithTimestamp:timeStamp];
        _startTimeLab.text = [NSString stringWithFormat:@"开始时间: %@", [date ISO8601StringDateAndTime]];
        [_startTimeLab sizeToFit];
        
        _oddsLab.text = [NSString stringWithFormat:@"赔率: %@", orderDic[kOrderMetaKeyBetOddsValue]];
        [_oddsLab sizeToFit];
    }
    
    {
        _betLab.text = [NSString stringWithFormat:@"投注金额: %@", orderDic[kOrderMetaKeyBetMoney]];
        [_betLab sizeToFit];
        
        NSString *hint = @"预计最高返还: ";
        NSString *gain = orderDic[kOrderMetaKeyGainMoney];
        NSMutableString *strM = [NSMutableString stringWithFormat:@"%@%@", hint, gain];
        NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:strM];
        [strAttr addAttributes:@{NSFontAttributeName: kRegularFont(kNoteFontSize)} range:NSMakeRange(0, strM.length)];
        [strAttr addAttributes:@{NSForegroundColorAttributeName: kNameFontColor} range:NSMakeRange(0, hint.length)];
        [strAttr addAttributes:@{NSForegroundColorAttributeName: kMainOnTintColor} range:NSMakeRange(hint.length, strM.length - hint.length)];
        _gainLab.attributedText = strAttr;
        [_gainLab sizeToFit];
    }
}

@end


#define kAlertOrderTopViewHeight                kSizeScale(40.0)
#define kAlertOrderMetaViewHeight               kSizeScale(200.0)
#define kAlertOrderBtmViewHeight                kSizeScale(72.0)
#define kAlertOrderMetaDisplayCount             (2)

NSString * const kAlertOrderMetaCellReuseID = @"kAlertOrderMetaCellReuseID";

@interface LGAlertOrderView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *logBtn;

@property (nonatomic, copy) NSArray *orderArray;

@end

@implementation LGAlertOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.position = FQAlertViewPopPositionCenter;
        
        [self initializeUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = kSizeScale(12.0);
    
    _confirmBtn.frame = CGRectMake(x, CGRectGetMaxY(_tableView.frame) + kSizeScale(12.0), self.containerView.width - x * 2, kSizeScale(36.0));
    _logBtn.center = CGPointMake(self.containerView.width * 0.5, CGRectGetMaxY(_confirmBtn.frame) + _logBtn.height * 0.5);
}

- (void)initializeUI {
    self.containerView.backgroundColor = kCellBgColor;
    
    self.titleView = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.enabled = NO;
        [btn setImage:[UIImage imageNamed:@"common_calendar"] forState:UIControlStateDisabled];
        [btn setTitle:kLocalizedString(@"order_succeed") forState:UIControlStateDisabled];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, kSizeScale(10.0), 0, 0)];
        [btn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateDisabled];
        btn.titleLabel.font = kRegularFont(kFieldFontSize);
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn sizeToFit];
        btn.width += btn.titleEdgeInsets.left;
        
        btn;
    });
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.containerView.width, kAlertOrderMetaViewHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[LGAlertOrderMetaCell class] forCellReuseIdentifier:kAlertOrderMetaCellReuseID];
    _tableView.rowHeight = kAlertOrderMetaViewHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.containerView addSubview:_tableView];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.backgroundColor = kMainOnTintColor;
    _confirmBtn.layer.cornerRadius = kCornerRadius;
    [_confirmBtn setTitle:kLocalizedString(@"parlay_confirm") forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = kRegularFont(kHeaderFontSize);
    [_confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:_confirmBtn];
    
    _logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_logBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"查看投注记录"
                                                                attributes:@{NSFontAttributeName: kRegularFont(kTinyFontSize),
                                                                             NSForegroundColorAttributeName: kOrderTintFontColor,
                                                                             NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlineStylePatternSolid),
                                                                             NSUnderlineColorAttributeName: kOrderTintFontColor}]
                       forState:UIControlStateNormal];
    [_logBtn sizeToFit];
    [_logBtn addTarget:self action:@selector(logBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:_logBtn];
}

#pragma mark - Public

- (void)displayWithOrderArray:(NSArray *)orderArray {
    if (orderArray.count == 0) {
        return;
    }
    self.orderArray = orderArray;
    
    {
        self.tableView.scrollEnabled = self.orderArray.count > 1;
        
        if (self.orderArray.count < kAlertOrderMetaDisplayCount) {
            self.tableView.height = kAlertOrderMetaViewHeight * self.orderArray.count;
        } else {
            self.tableView.height = kAlertOrderMetaViewHeight * kAlertOrderMetaDisplayCount;
        }
        self.containerView.height = kAlertOrderTopViewHeight + kAlertOrderBtmViewHeight + self.tableView.height;
    }
    
    [self.tableView reloadData];
    
    [super displayInWindow];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGAlertOrderMetaCell *cell = [tableView dequeueReusableCellWithIdentifier:kAlertOrderMetaCellReuseID];
    
    NSDictionary *orderMeta = self.orderArray[indexPath.row];
    [cell setOrderDic:orderMeta];
    return cell;
}

#pragma mark - Events

- (void)confirmBtnClicked {
    [super dismiss];
}

- (void)logBtnClicked {
    UIViewController *ctr = [[CTMediator sharedInstance] mediator_generateParlayHistoryController];
    [[[FQWindowUtility currentViewController] navigationController] pushViewController:ctr animated:YES];
    
    [super dismiss];
}

@end
