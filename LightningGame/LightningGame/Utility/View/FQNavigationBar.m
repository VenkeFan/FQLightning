//
//  FQNavigationBar.m
//  FQWidgets
//
//  Created by fan qi on 2018/5/9.
//  Copyright © 2018年 redefine. All rights reserved.
//

#import "FQNavigationBar.h"

@interface FQNavigationBar () {
    UIView *_titleView;
    UILabel *_titleLabel;
    UIView *_navLine;
    UIButton *_leftBtn;
}

@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, weak) UIView *subTitleView;

@property (nonatomic, assign) CGFloat statusBarHeight;

@property (nonatomic, copy) NSString *headUrl;

@end

@implementation FQNavigationBar {
    CGFloat _titleLabelWidth;
}

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)]) {
        self.backgroundColor = kNavBarColor;
        _titleAlignment = FQNavigationBarTitleAlignment_Center;
        
        [self addSubview:self.contentView];
//        [self addSubview:self.navLine];
        
        self.tintColor = kNameFontColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(0, self.statusBarHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - self.statusBarHeight);
    if (CGRectGetWidth(self.leftBtn.frame) < CGRectGetHeight(self.contentView.bounds)) {
        self.leftBtn.width = CGRectGetHeight(self.contentView.bounds);
    }
    
    CGFloat rightBtnWidth = CGRectGetWidth(self.rightBtn.bounds) > CGRectGetHeight(self.contentView.bounds) ? CGRectGetWidth(self.rightBtn.bounds) : CGRectGetHeight(self.contentView.bounds);
    self.rightBtn.width = rightBtnWidth;
    self.rightBtn.height = CGRectGetHeight(self.contentView.bounds);
    if (self.rightBtn.left == 0) {
        self.rightBtn.left = CGRectGetWidth(self.contentView.bounds) - rightBtnWidth;
    }
    
    CGFloat left = CGRectGetMaxX(self.leftBtn.frame);
    CGFloat right = 0; //CGRectGetWidth(self.contentView.bounds) - CGRectGetMinX(self.rightBtn.frame);
    
    {
        if (self.leftBtnArray.count > 0) {
            left = 0;
            
            CGFloat defaultSize = CGRectGetHeight(self.contentView.bounds);
            CGFloat left = 0;
            
            for (int i = 0; i < self.leftBtnArray.count; i++) {
                UIButton *btn = self.leftBtnArray[i];
                if (btn.frame.size.width == 0 || btn.frame.size.height == 0) {
                    btn.frame = CGRectMake(0, 0, defaultSize, defaultSize);
                }
                
//                if (i == 0) {
//                    right = CGRectGetWidth(self.contentView.bounds) - btn.frame.size.width;
//                } else {
//                    right -= (btn.frame.size.width);
//                }
                btn.left = left;
                btn.top = (kSingleNavBarHeight - btn.height) / 2.0;
                
                if (btn.alpha > 0.0) {
                    left += (btn.frame.size.width);
                }
            }
        }
        
        if (self.rightBtnArray.count > 0) {
            right = 0;
            
            CGFloat defaultSize = CGRectGetHeight(self.contentView.bounds);
            CGFloat left = 0;
            for (int i = 0; i < self.rightBtnArray.count; i++) {
                UIButton *btn = self.rightBtnArray[i];
                if (btn.frame.size.width == 0 || btn.frame.size.height == 0) {
                    btn.frame = CGRectMake(0, 0, defaultSize, defaultSize);
                }
                
                if (btn.alpha > 0.0) {
                    right += (btn.frame.size.width);
                }
                
                if (i == 0) {
                    left = CGRectGetWidth(self.contentView.bounds) - btn.frame.size.width;
                } else {
                    left -= (btn.frame.size.width);
                }
                btn.left = left;
                btn.top = (kSingleNavBarHeight - btn.height) / 2.0;
            }
        }
    }
    
    CGFloat titleViewWidth = left > right ? CGRectGetWidth(self.contentView.bounds) - left * 2 : CGRectGetWidth(self.contentView.bounds) - right * 2;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.titleView.left = left;
                         self.titleView.width = titleViewWidth;
                         if (self.titleLabel.width >= titleViewWidth) {
                             self.titleLabel.width = titleViewWidth;
                         } else {
                             self.titleLabel.width = self->_titleLabelWidth;
                         }
                         
                         if (self.titleAlignment == FQNavigationBarTitleAlignment_Left) {
                             self.titleLabel.center = CGPointMake(CGRectGetWidth(self.titleLabel.bounds) * 0.5, CGRectGetHeight(self.titleView.bounds) * 0.5);
                         } else {
                             self.titleLabel.center = CGPointMake(CGRectGetWidth(self.titleView.bounds) * 0.5, CGRectGetHeight(self.titleView.bounds) * 0.5);
                         }
                     }];
    
    self.subTitleView.center = CGPointMake(CGRectGetWidth(self.titleView.bounds) * 0.5, CGRectGetHeight(self.titleView.bounds) * 0.5);
}

#pragma mark - Override

- (void)setAlpha:(CGFloat)alpha {
    UIColor *color = self.backgroundColor;
    CGFloat red, greed, blue, oldAlpha;
    
    BOOL getted = [color getRed:&red green:&greed blue:&blue alpha:&oldAlpha];
    if (getted) {
        self.backgroundColor = [UIColor colorWithRed:red green:greed blue:blue alpha:alpha];
    }
    
    if (alpha == 0.0) {
        self.navLine.hidden = YES;
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    
    self.titleLabel.textColor = tintColor;
}

#pragma mark - Public

- (void)setLeftBtnTitle:(NSString *)title {
    [self.leftBtn setTitle:title forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
}

- (void)setLeftBtnImageName:(NSString *)imageName {
    [self.leftBtn setTitle:nil forState:UIControlStateNormal];
    [self.leftBtn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}

- (void)setRightBtnTitle:(NSString *)title {
    [self.rightBtn setTitle:title forState:UIControlStateNormal];
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
}

- (void)setRightBtnImageName:(NSString *)imageName {
    [self.rightBtn setTitle:nil forState:UIControlStateNormal];
    [self.rightBtn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}

#pragma mark - Event

- (void)leftBtnClicked:(UIButton *)sender {
    if (sender.allTargets.count > 1) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(navigationBarLeftBtnDidClicked)]) {
        [self.delegate navigationBarLeftBtnDidClicked];
    }
}

#pragma mark - Setter

- (void)setLeftBtn:(UIButton *)leftBtn {
    _leftBtn = leftBtn;
    
    if (leftBtn) {
        [self.contentView addSubview:leftBtn];
    }
}

- (void)setRightBtn:(UIButton *)rightBtn {
    _rightBtn = rightBtn;
    
    if (rightBtn) {
        [self.contentView addSubview:rightBtn];
    }
}

- (void)setTitleView:(UIView *)titleView {
    self.subTitleView = titleView;
    [self.titleView addSubview:self.subTitleView];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
    
    [self.titleLabel sizeToFit];
    _titleLabelWidth = CGRectGetWidth(self.titleLabel.bounds);
    
    if (self.titleAlignment == FQNavigationBarTitleAlignment_Left) {
        self.titleLabel.center = CGPointMake(CGRectGetWidth(self.titleLabel.bounds) * 0.5, CGRectGetHeight(self.titleView.bounds) * 0.5);
    } else {
        self.titleLabel.center = CGPointMake(CGRectGetWidth(self.titleView.bounds) * 0.5, CGRectGetHeight(self.titleView.bounds) * 0.5);
    }
}

- (void)setLeftBtnArray:(NSArray<UIButton *> *)leftBtnArray {
    _leftBtnArray = [leftBtnArray copy];
    
    if (leftBtnArray.count > 0) {
        [self.leftBtn removeFromSuperview];
        
        for (int i = 0; i < leftBtnArray.count; i++) {
            UIButton *btn = leftBtnArray[i];
            [self.contentView addSubview:btn];
        }
    }
}

- (void)setRightBtnArray:(NSArray<UIButton *> *)rightBtnArray {
    _rightBtnArray = [rightBtnArray copy];
    
    if (rightBtnArray.count > 0) {
        [self.rightBtn removeFromSuperview];
        
        for (int i = 0; i < rightBtnArray.count; i++) {
            UIButton *btn = rightBtnArray[i];
            [self.contentView addSubview:btn];
        }
    }
}

#pragma mark - Getter

- (UIView *)contentView {
    if (!_contentView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(0, self.statusBarHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - self.statusBarHeight);
        _contentView = view;
        
        [view addSubview:self.titleView];
        [view addSubview:self.leftBtn];
    }
    return _contentView;
}

- (UIView *)navLine {
    if (!_navLine) {
        _navLine = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight - 0.5, CGRectGetWidth(self.bounds), 0.5)];
        _navLine.backgroundColor = kUIColorFromRGBA(0xDDDDDD, 0.5);
    }
    return _navLine;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        UIImage *image = [[UIImage imageNamed:@"common_icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tintColor = [UIColor whiteColor];
        btn.frame = CGRectMake(0, 0, CGRectGetHeight(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds));
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitleColor:kNameFontColor forState:UIControlStateNormal];
        btn.titleLabel.font = kBoldFont(kNoteFontSize);
        [btn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn = btn;
    }
    return _leftBtn;
}

- (UIView *)titleView {
    if (!_titleView) {
        CGFloat x = CGRectGetMaxX(self.leftBtn.frame);
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(x, 0, CGRectGetWidth(self.contentView.bounds) - x * 2, CGRectGetHeight(self.contentView.bounds));
        view.clipsToBounds = YES;
        _titleView = view;
        
        [view addSubview:self.titleLabel];
    }
    return _titleView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *lab = [[UILabel alloc] init];
        lab.backgroundColor = [UIColor clearColor];
        lab.frame = self.titleView.bounds;
        lab.textColor = kNavBarTitleColor;
        lab.font = kBoldFont(kNavBarTitleFontSize);
        lab.textAlignment = NSTextAlignmentCenter;
        _titleLabel = lab;
    }
    return _titleLabel;
}

- (CGFloat)statusBarHeight {
    if (kSystemStatusBarHeight > 0) {
        return kSystemStatusBarHeight;
    }
    
    return kIsiPhoneX ? 44 : 20;
}

@end
