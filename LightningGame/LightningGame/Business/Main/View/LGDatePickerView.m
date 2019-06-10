//
//  LGDatePickerView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/10.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGDatePickerView.h"
#import "LGDatePickerViewModel.h"

@interface LGDatePickerView ()

@property (nonatomic, strong, readwrite) LGDatePickerViewModel *viewModel;
@property (nonatomic, strong) UIButton *dateBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation LGDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kMarqueeBgColor;
        
        _viewModel = [LGDatePickerViewModel new];
        [_viewModel addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        
        [self initializeUI];
    }
    return self; 
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = CGRectGetHeight(self.frame) * 0.5;
    
    _dateBtn.frame = CGRectMake(0, 0, kSizeScale(140.0), self.height);
    _dateBtn.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    _leftBtn.frame = CGRectMake(0, 0, self.height, self.height);
    _leftBtn.center = CGPointMake(CGRectGetMinX(_dateBtn.frame) - _leftBtn.width * 0.5, self.height * 0.5);
    _rightBtn.frame = CGRectMake(0, 0, self.height, self.height);
    _rightBtn.center = CGPointMake(CGRectGetMaxX(_dateBtn.frame) + _rightBtn.width * 0.5, self.height * 0.5);
}

- (void)dealloc {
    [_viewModel removeObserver:self forKeyPath:@"currentIndex"];
}

- (void)initializeUI {
    _dateBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitleColor:kMainOnTintColor forState:UIControlStateNormal];
        btn.titleLabel.font = kRegularFont(kNoteFontSize);
        [btn addTarget:self action:@selector(dateBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    [self addSubview:_dateBtn];
    
    _leftBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:@"<" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(leftBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    [self addSubview:_leftBtn];
    
    _rightBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:@">" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(rightBtnOnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    [self addSubview:_rightBtn];
}

#pragma mark - Public

- (void)setIndex:(NSUInteger)index {
    [self.viewModel setCurrentIndex:index];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:_viewModel] && [keyPath isEqualToString:@"currentIndex"]) {
        
        [self.dateBtn setTitle:self.viewModel.dateStr forState:UIControlStateNormal];
        self.leftBtn.enabled = self.viewModel.canPreviously;
        self.rightBtn.enabled = self.viewModel.canFuture;
    }
}

#pragma mark - Events

- (void)dateBtnOnClicked {
    if ([self.delegate respondsToSelector:@selector(datePickerViewDidClickedDate:)]) {
        [self.delegate datePickerViewDidClickedDate:self];
    }
}

- (void)leftBtnOnClicked {
    [self.viewModel previours];
}

- (void)rightBtnOnClicked {
    [self.viewModel future];
}

#pragma mark - Getter & Setter

- (void)setPreviously:(BOOL)previously {
    _previously = previously;
    
    [self.viewModel generateDateList:previously];
}

@end
