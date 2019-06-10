//
//  LGLoadingView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/10.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGLoadingView.h"

@interface LGLoadingView ()

@property (nonatomic, assign) BOOL isDisplay;

@end

@implementation LGLoadingView

+ (LGLoadingView *)instance {
    static LGLoadingView *_instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^(){
        _instance = [[self alloc] initWithFrame:CGRectMake(0, 0, kSizeScale(80), kSizeScale(80))];
        _instance.center = CGPointMake(kScreenWidth / 2.0, kScreenHeight / 2.0);
        _instance.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
        _instance.layer.cornerRadius = 6.0;
        _instance.layer.masksToBounds = YES;
        _instance.alpha = 0;
        _instance.isDisplay = NO;
    });
    return _instance;
}

+ (void)display {
    dispatch_async(dispatch_get_main_queue(), ^{
        LGLoadingView *bgView = [self instance];
        if (bgView.isDisplay) {
            return;
        }
        bgView.isDisplay = YES;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:bgView];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.center = CGPointMake(bgView.width * 0.5, bgView.height * 0.5);
        [bgView addSubview:indicatorView];
        
        [indicatorView startAnimating];
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             bgView.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    });
}

+ (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^{
        LGLoadingView *bgView = [self instance];
        if (!bgView.isDisplay) {
            return;
        }
        bgView.isDisplay = NO;
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(){
                             bgView.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             [bgView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
                             [bgView removeFromSuperview];
                         }];
    });
}

@end
