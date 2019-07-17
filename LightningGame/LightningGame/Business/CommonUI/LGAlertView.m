//
//  LGAlertView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGAlertView.h"

@interface LGAlertView ()

@property (nonatomic, strong, readwrite) UIView *topView;

@end

@implementation LGAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _topView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kAlertTopViewHeight)];
            view.backgroundColor = kMainOnTintColor;
            
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            closeBtn.backgroundColor = [UIColor clearColor];
            closeBtn.frame = CGRectMake(0, 0, view.height, view.height);
            closeBtn.center = CGPointMake(view.width - closeBtn.width * 0.5, view.height * 0.5);
            [closeBtn setTitle:@"×" forState:UIControlStateNormal];
            [closeBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
            closeBtn.titleLabel.font = kRegularFont(kScoreFontSize);
            [closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:closeBtn];
            
            UIView *line = [UIView new];
            line.backgroundColor = kMainBgColor;
            line.frame = CGRectMake(CGRectGetMinX(closeBtn.frame), 0, 1.0, view.height);
            [view addSubview:line];
            
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.enabled = NO;
//            [btn setImage:[UIImage imageNamed:@"common_calendar"] forState:UIControlStateDisabled];
//            [btn setTitle:kLocalizedString(@"order_succeed") forState:UIControlStateDisabled];
//            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, kSizeScale(10.0), 0, 0)];
//            [btn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateDisabled];
//            btn.titleLabel.font = kRegularFont(kFieldFontSize);
//            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//            [btn sizeToFit];
//            btn.width += btn.titleEdgeInsets.left;
//            btn.left = kSizeScale(12.0);
//            btn.top = (view.height - btn.height) * 0.5;
//            [view addSubview:btn];
            
            view;
        });
        [self.containerView addSubview:_topView];
    }
    return self;
}

- (void)setTitleView:(UIView *)titleView {
    [_titleView removeFromSuperview];
    _titleView = nil;
    
    _titleView = titleView;
    _titleView.center = CGPointMake(kSizeScale(12.0) + _titleView.width * 0.5, self.topView.height * 0.5);
    [self.topView addSubview:_titleView];
}

- (void)closeBtnClicked {
    [super dismiss];
}

@end
