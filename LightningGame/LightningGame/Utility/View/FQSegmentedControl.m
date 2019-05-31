//
//  FQSegmentedControl.m
//  FQWidgets
//
//  Created by fan qi on 2018/5/4.
//  Copyright © 2018年 redefine. All rights reserved.
//

#import "FQSegmentedControl.h"

#define kSegTintFontColor               kUIColorFromRGB(0xCDC3B3)
#define kSegOnTintFontColor             kUIColorFromRGB(0xCDC3B3)
#define kSegHSeparLineColor             kUIColorFromRGB(0x1A1C26)

#define kTintFont                       kBoldFont(kNameFontSize)
#define kOnTintFont                     kBoldFont(kNameFontSize)

@interface FQSegmentedControl ()

@property (nonatomic, weak) UIView *markLine;
@property (nonatomic, weak) UIView *hSeparateLine;
@property (nonatomic, strong) NSMutableArray<UIButton *> *btnArray;

@end

@implementation FQSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0) {
        frame.size.width = kScreenWidth;
    }
    
    if (frame.size.height == 0) {
        frame.size.height = kSegmentHeight;
    }
    
    if (self = [super initWithFrame:frame]) {
        _btnArray = [NSMutableArray array];
        _showShadow = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self initializeUI];
}

#pragma mark - View

- (void)initializeUI {
    if (self.items.count == 0 || _btnArray.count > 0) {
        return;
    }
    
    CGFloat width = CGRectGetWidth(self.bounds) / self.items.count;
    CGFloat actualWidth = 0;
    
    for (int i = 0; i < self.items.count; i++) {
        if ([self.items[i] isKindOfClass:[NSString class]]) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = i;
            btn.selected = (i == _currentIndex);
            [btn setTitle:self.items[i] forState:UIControlStateNormal];
            [btn setTitleColor:self.tintColor forState:UIControlStateNormal];
            [btn setTitleColor:self.onTintColor forState:UIControlStateSelected];
            btn.titleLabel.font = btn.selected ? self.onTintFont : self.tintFont;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn sizeToFit];
            actualWidth = btn.width > actualWidth ? btn.width : actualWidth;
            btn.width = width;
            btn.center = CGPointMake((i * width) + width * 0.5, self.frame.size.height * 0.5);
            [self addSubview:btn];
            
            [_btnArray addObject:btn];
            
            if (i == 0 || !self.hasVSeparateLine) {
                continue;
            }
            UIView *separateLine = [[UIView alloc] init];
            separateLine.frame = CGRectMake(i * width, 10, 1, self.frame.size.height - 20);
            separateLine.backgroundColor = kMarqueeBgColor;
            [self addSubview:separateLine];
        }
    }
    
    
    UIView *hLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, CGRectGetWidth(self.bounds), 2)];
    hLineView.backgroundColor = self.hSeparateLineColor;
    [self addSubview:hLineView];
    _hSeparateLine = hLineView;
    
    CGFloat lineWith = width; // (actualWidth + 20) > width ? width : (actualWidth + 20);
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, lineWith, 2)];
    lineView.layer.cornerRadius = CGRectGetHeight(lineView.bounds) * 0.5;
    lineView.backgroundColor = self.markLineColor;
    lineView.center = CGPointMake(_btnArray[_currentIndex].center.x, lineView.center.y);
    [self addSubview:lineView];
    _markLine = lineView;
}

#pragma mark - Public

- (void)setItems:(NSArray *)items {
    _items = items;
    
    if (_btnArray.count > items.count) {
        return;
    }
    
    [_btnArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitle:items[idx] forState:UIControlStateNormal];
    }];
}

- (void)setLineOffsetX:(CGFloat)x {
    _markLine.center = CGPointMake(CGRectGetWidth(self.bounds) / self.items.count * 0.5 + x / self.items.count, _markLine.center.y);
}

- (void)hideTitleTipWithIndex:(NSInteger)index {
    if (index < _btnArray.count && index < self.items.count) {
        UIButton *btn = _btnArray[index];
        [btn setTitle:self.items[index] forState:UIControlStateNormal];
    }
}

- (void)addShadow {
    if (self.isShowShadow) {
        return;
    }
    
    _showShadow = YES;
    self.layer.shadowColor = kUIColorFromRGB(0x000000).CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowPath = CGPathCreateWithRect(CGRectMake(0, 5, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 5), NULL);
}

- (void)clearShadow {
    if (!self.isShowShadow) {
        return;
    }
    
    _showShadow = NO;
    self.layer.shadowColor = kUIColorFromRGBA(0x000000, 0.0).CGColor;
}

#pragma mark - Events

- (void)btnClicked:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    
    _preIndex = _currentIndex;
    _currentIndex = sender.tag;
    
    [self p_updateBtn:sender];
}

#pragma mark - Private

- (void)p_updateBtn:(UIButton *)sender {
    sender.selected = YES;
    sender.titleLabel.font = self.onTintFont;
    
    for (UIButton *tempBtn in _btnArray) {
        if (![sender isEqual:tempBtn]) {
            tempBtn.selected = NO;
            tempBtn.titleLabel.font = self.tintFont;
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self->_markLine.center = CGPointMake(sender.center.x, self->_markLine.center.y);
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(segmentedControl:didSelectedIndex:preIndex:)]) {
        [_delegate segmentedControl:self didSelectedIndex:_currentIndex preIndex:_preIndex];
    }
}

#pragma mark - Setter & Getter

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex == currentIndex) {
        return;
    }
    
    _preIndex = _currentIndex;
    _currentIndex = currentIndex;
    
    if (currentIndex >= 0 && currentIndex < _btnArray.count) {
        [self p_updateBtn:_btnArray[currentIndex]];
    }
}

- (UIColor *)tintColor {
    if (!_tintColor) {
        _tintColor = kSegTintFontColor;
    }
    return _tintColor;
}

- (UIColor *)onTintColor {
    if (!_onTintColor) {
        _onTintColor = kSegOnTintFontColor;
    }
    return _onTintColor;
}

- (UIFont *)tintFont {
    if (!_tintFont) {
        _tintFont = kTintFont;
    }
    return _tintFont;
}

- (UIFont *)onTintFont {
    if (!_onTintFont) {
        _onTintFont = kOnTintFont;
    }
    return _onTintFont;
}

- (UIColor *)markLineColor {
    if (!_markLineColor) {
        _markLineColor = kSegHSeparLineColor;
    }
    return _markLineColor;
}

- (UIColor *)hSeparateLineColor {
    if (!_hSeparateLineColor) {
        _hSeparateLineColor = kSegHSeparLineColor;
    }
    return _hSeparateLineColor;
}

@end
