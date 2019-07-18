//
//  LGUserDatePickerView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGUserDatePickerView.h"

@interface LGUserDatePickerView ()

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation LGUserDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.position = FQAlertViewPopPositionBottom;
        
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI {
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.height = kSizeScale(350.0);
    
    self.titleView = ({
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.backgroundColor = [UIColor clearColor];
        [confirmBtn setTitle:kLocalizedString(@"parlay_confirm") forState:UIControlStateNormal];
        [confirmBtn setTitleColor:kUIColorFromRGB(0x000000) forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = kRegularFont(kNameFontSize);
        [confirmBtn sizeToFit];
        confirmBtn.width += 16.0;
        [confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        confirmBtn;
    });
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.containerView.width, self.containerView.height - CGRectGetMaxY(self.topView.frame))];
    _datePicker.backgroundColor = [UIColor clearColor];
    _datePicker.locale = [NSLocale currentLocale];
    _datePicker.calendar = [NSCalendar currentCalendar];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
    [self.containerView addSubview:_datePicker];
}

#pragma mark - Events

- (void)confirmBtnClicked {
    if ([self.delegate respondsToSelector:@selector(userDatePickerView:didSelectedDate:)]) {
        [self.delegate userDatePickerView:self
                          didSelectedDate:self.datePicker.date];
    }
    [super dismiss];
}

- (void)datePickerDateChanged:(UIDatePicker *)picker {
    
}

@end
