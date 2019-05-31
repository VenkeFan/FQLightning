//
//  LGMarqueeView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/30.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMarqueeView.h"
#import "FQComponentFactory.h"
#import "LGmarqueeViewModel.h"

@interface LGMarqueeView () <LGMarqueeViewModelDelegate> {
    BOOL _hasLoaded;
}

@property (nonatomic, strong) LGMarqueeViewModel *viewModel;
@property (nonatomic, strong) CATextLayer *txtLayer;

@end

@implementation LGMarqueeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kMarqueeBgColor;
        
        _hasLoaded = NO;
        
        _txtLayer = [FQComponentFactory textLayerWithFont:kRegularFont(kNoteFontSize)];
        _txtLayer.backgroundColor = [UIColor clearColor].CGColor;
        _txtLayer.alignmentMode = kCAAlignmentLeft;
        _txtLayer.foregroundColor = kMainOnTintColor.CGColor;
        [self.layer addSublayer:_txtLayer];
    }
    return self;
}

- (void)layoutSubviews {
    self.layer.cornerRadius = CGRectGetHeight(self.frame) * 0.5;
    
    _txtLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) - kCellMarginX * 2, _txtLayer.fontSize);
    _txtLayer.position = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
}

#pragma mark - Public

- (void)fetchData {
    if (!_hasLoaded) {
        _hasLoaded = YES;
        
        [self.viewModel fetchData];
    }
}

#pragma mark - LGMarqueeViewModelDelegate

- (void)marqueeViewModel:(LGMarqueeViewModel *)viewModel displayTxt:(NSString *)displayTxt {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self.txtLayer addAnimation:animation forKey:nil];
    self.txtLayer.string = displayTxt;
}

#pragma mark - Getter

- (LGMarqueeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [LGMarqueeViewModel instance];
        [_viewModel addListener:self];
    }
    return _viewModel;
}

@end
