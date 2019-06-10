//
//  LGMatchParlayTopView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/5.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchParlayTopView.h"
#import "Masonry.h"
#import "FQComponentFactory.h"

@interface LGMatchParlayTopView ()

@property (nonatomic, strong) UILabel *countLab;

@end

@implementation LGMatchParlayTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kMainOnTintColor;
        
        if (@available(iOS 11.0, *)) {
            self.layer.cornerRadius = kCornerRadius;
            self.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        } else {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                       byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                             cornerRadii:CGSizeMake(kCornerRadius, kCornerRadius)];
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = path.CGPath;
            
            self.layer.mask = shapeLayer;
        }
        self.layer.masksToBounds = YES;
        
        [self initializeUI];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - UI

- (void)initializeUI {
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [UIColor redColor];
    closeBtn.frame = CGRectMake(0, 0, self.height, self.height);
    closeBtn.center = CGPointMake(self.width - closeBtn.width * 0.5, self.height * 0.5);
    [closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    UIControl *clearCtr = ({
        UIControl *ctr =  [[UIControl alloc] init];
        [ctr addTarget:self action:@selector(clearCtrClicked) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat padding = 4.0;
        self.countLab = [UILabel new];
        self.countLab.backgroundColor = kUIColorFromRGB(0x282F42);
        self.countLab.text = @"1";
        self.countLab.textColor = [UIColor whiteColor];
        self.countLab.font = kRegularFont(kNoteFontSize);
        self.countLab.textAlignment = NSTextAlignmentCenter;
        [self.countLab sizeToFit];
        self.countLab.layer.cornerRadius = self.countLab.height * 0.5;
        self.countLab.layer.masksToBounds = YES;
        [ctr addSubview:self.countLab];
        [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ctr).offset(padding);
            make.centerY.mas_equalTo(ctr);
            make.size.mas_equalTo(CGSizeMake(self.countLab.width + 12.0, self.countLab.height + 2.0));
        }];
        
        UILabel *lab = [FQComponentFactory labelWithFont:kRegularFont(kNoteFontSize)];
        lab.text = @"删除全部";
        [ctr addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.countLab.mas_right).offset(padding);
            make.centerY.mas_equalTo(self.countLab);
            make.right.mas_equalTo(ctr).offset(-padding);
        }];
        
        ctr;
    });
    [self addSubview:clearCtr];
    [clearCtr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self);
    }];
}

#pragma mark - Events

- (void)clearCtrClicked {
    if ([self.delegate respondsToSelector:@selector(matchParlayTopViewDidClear:)]) {
        [self.delegate matchParlayTopViewDidClear:self];
    }
}

- (void)closeBtnClicked {
    if ([self.delegate respondsToSelector:@selector(matchParlayTopViewDidClose:)]) {
        [self.delegate matchParlayTopViewDidClose:self];
    }
}

#pragma mark - Setter

- (void)setItemCount:(NSUInteger)itemCount {
    _itemCount = itemCount;
    
    NSString *text = [NSString stringWithFormat:@"%ld", (long)itemCount];
    CGSize size = [text boundingRectWithSize:self.bounds.size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: self.countLab.font}
                                     context:nil].size;
    self.countLab.text = text;
    [self.countLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(size.width + 12.0, size.height + 2.0));
    }];
}

@end
