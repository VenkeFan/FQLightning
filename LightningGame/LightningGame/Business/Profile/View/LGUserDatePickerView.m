//
//  LGUserDatePickerView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGUserDatePickerView.h"

@interface LGUserDatePickerView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation LGUserDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        self.alpha = 0;
    }
    return self;
}

#pragma mark - Public

- (void)displayInParentView:(UIView *)parentView {
    [parentView addSubview:self];
    
    UIView *view = self.contentView;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.centerY = self.height - view.height * 0.5;
                         
                         self.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)dismiss {
    UIView *view = self.contentView;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.centerY = self.height + view.height * 0.5;
                         
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                         [self.contentView removeFromSuperview];
                         [self removeFromSuperview];
                     }];
}

#pragma mark - Events

- (void)closeBtnClicked {
    [self dismiss];
}

- (void)confirmBtnClicked {
    if ([self.delegate respondsToSelector:@selector(userDatePickerView:didSelectedDate:)]) {
        [self.delegate userDatePickerView:self
                          didSelectedDate:self.datePicker.date];
    }
    [self dismiss];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

- (void)datePickerDateChanged:(UIDatePicker *)picker {
    
}

#pragma mark - Getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake(0, 0, kScreenWidth, kSizeScale(350));
        _contentView.center = CGPointMake(self.width * 0.5, self.height + _contentView.height * 0.5);
        _contentView.layer.cornerRadius = kCornerRadius;
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
        
        CGFloat size = kSizeScale(40.0);
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.backgroundColor = [UIColor clearColor];
        closeBtn.frame = CGRectMake(0, 0, size, size);
        closeBtn.center = CGPointMake(_contentView.width - closeBtn.width * 0.5, closeBtn.height * 0.5);
        [closeBtn setTitle:@"×" forState:UIControlStateNormal];
        [closeBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
        closeBtn.titleLabel.font = kRegularFont(kScoreFontSize);
        [closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:closeBtn];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.backgroundColor = [UIColor clearColor];
        [confirmBtn setTitle:kLocalizedString(@"parlay_confirm") forState:UIControlStateNormal];
        [confirmBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = kRegularFont(kNameFontSize);
        [confirmBtn sizeToFit];
        confirmBtn.height = size;
        confirmBtn.width += 16.0;
        [confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:confirmBtn];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, size, _contentView.width, _contentView.height - size)];
        _datePicker.backgroundColor = [UIColor clearColor];
        _datePicker.locale = [NSLocale currentLocale];
        _datePicker.calendar = [NSCalendar currentCalendar];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
        [_contentView addSubview:_datePicker];
    }
    return _contentView;
}

@end
