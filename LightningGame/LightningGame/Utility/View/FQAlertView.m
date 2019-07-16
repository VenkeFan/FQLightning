//
//  FQAlertView.m
//  FQWidgets
//
//  Created by fanqi on 17/6/28.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "FQAlertView.h"

@interface FQAlertView ()

@property (nonatomic, strong, readwrite) UIView *containerView;

@end

@implementation FQAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(![self isMemberOfClass:[FQAlertView class]], @"FQAlertView is an abstract class, you should not instantiate it directly.");
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.alpha = 0;
        
        _direction = FQAlertViewPopDirectionFromBottom;
        _position = FQAlertViewPopPositionCenter;
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Public

- (void)displayInWindow {
    [self displayInParentView:kCurrentWindow];
}

- (void)displayInParentView:(UIView *)parentView {
    [self displayInParentView:parentView completed:nil];
}

- (void)displayInParentView:(UIView *)parentView completed:(void (^)(void))completed {
    [parentView addSubview:self];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         switch (self.position) {
                             case FQAlertViewPopPositionBottom:
                                 self.containerView.centerY = self.height - self.containerView.height * 0.5;
                                 break;
                             case FQAlertViewPopPositionCenter:
                                 self.containerView.centerY = self.height * 0.5;
                                 break;
                         }
                         
                         self.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         if (completed) {
                             completed();
                         }
                     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self p_setContainerViewCenterY];
                         
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
    [_containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_containerView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)p_setContainerViewCenterY {
    switch (self.direction) {
        case FQAlertViewPopDirectionFromBottom:
            self.containerView.center = CGPointMake(self.width * 0.5, self.height + self.containerView.height * 0.5);
            break;
        case FQAlertViewPopDirectionFromTop:
            self.containerView.center = CGPointMake(self.width * 0.5, -self.containerView.height * 0.5);
            break;
    }
}

#pragma mark - Setter

- (void)setDirection:(FQAlertViewPopDirection)direction {
    _direction = direction;
    
    [self p_setContainerViewCenterY];
}

#pragma mark - Getter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = kCellBgColor;
        _containerView.frame = CGRectMake(0, 0, kScreenWidth, 0);
        _containerView.layer.cornerRadius = kCornerRadius;
        _containerView.layer.masksToBounds = YES;
        [self addSubview:_containerView];
        
        [self p_setContainerViewCenterY];
    }
    return _containerView;
}

@end
