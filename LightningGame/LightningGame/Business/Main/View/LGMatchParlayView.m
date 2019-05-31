//
//  LGMatchParlayView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/31.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchParlayView.h"

#define kLGMatchParlayViewAnimationDuration         (0.5)
#define kLGMatchParlayViewSpringVelocity            (5.0)

#define kLGMatchParlayViewTopHeight                 kSizeScale(30.0)
#define kLGMatchParlayViewBottomHeight              kSizeScale(45.0)
#define kLGMatchParlayViewHintHeight                kSizeScale(45.0)
#define kLGMatchParlayViewSingleHeight              kSizeScale(80.0)
#define kLGMatchParlayViewKeyboardHeight            kSizeScale(80.0)
#define kLGMatchParlayViewMixHeight                 (kLGMatchParlayViewSingleHeight + kLGMatchParlayViewTopHeight + kLGMatchParlayViewBottomHeight)

@interface LGMatchParlayView ()

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation LGMatchParlayView

+ (instancetype)instance {
    static LGMatchParlayView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] initWithFrame:CGRectMake(0, 0, kScreenWidth, kLGMatchParlayViewMixHeight)];
        
        _instance.backgroundColor = kMainBgColor;
        [_instance initializeUI];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [LGMatchParlayView instance];
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//
//    }
//    return self;
//}

- (void)initializeUI {
    _topView = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, self.width, kLGMatchParlayViewTopHeight);
        view.backgroundColor = [UIColor blueColor];
        
        
        view;
    });
}

#pragma mark - Public

- (void)addTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic {
    
}

- (void)display {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:kLGMatchParlayViewAnimationDuration
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:kLGMatchParlayViewSpringVelocity
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)dismiss {
    [UIView animateWithDuration:kLGMatchParlayViewAnimationDuration
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:kLGMatchParlayViewSpringVelocity
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

#pragma mark - Setter

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
}

@end
