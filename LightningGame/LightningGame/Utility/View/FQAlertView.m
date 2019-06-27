//
//  FQAlertView.m
//  FQWidgets
//
//  Created by fanqi on 17/6/28.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "FQAlertView.h"

@interface FQAlertView ()

@property (nonatomic, strong, readwrite) UIView *contentView;

@end

@implementation FQAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(![self isMemberOfClass:[FQAlertView class]], @"FQAlertView is an abstract class, you should not instantiate it directly.");
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.alpha = 0;
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Public

- (void)show {
    [self showWithCompleted:nil];
}

- (void)showWithCompleted:(void (^)(void))completed {
    [kCurrentWindow addSubview:self];
    
    UIView *view = self.contentView;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.centerY = self.height * 0.5;
                         
                         self.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         if (completed) {
                             completed();
                         }
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
                         [self p_removeSelf];
                     }];
}

#pragma mark - Events

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

#pragma mark - Private

- (void)p_removeSelf {
    [_contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_contentView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - Getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = kCellBgColor;
        _contentView.frame = CGRectMake(0, 0, kScreenWidth, 0);
        _contentView.center = CGPointMake(self.width * 0.5, self.height + _contentView.height * 0.5);
        _contentView.layer.cornerRadius = kCornerRadius;
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
    }
    return _contentView;
}

@end
