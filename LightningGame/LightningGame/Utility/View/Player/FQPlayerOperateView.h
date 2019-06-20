//
//  FQPlayerOperateView.h
//  FQWidgets
//
//  Created by fan qi on 2018/4/10.
//  Copyright © 2018年 fan qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FQPlayerOperateView;

@protocol FQPlayerOperateViewDelegate <NSObject>

@optional
- (void)playerOperateViewDidClickedFill:(FQPlayerOperateView *)operateView;
- (void)playerOperateViewDidClickedClose:(FQPlayerOperateView *)operateView;

@end

@interface FQPlayerOperateView : UIView

@property (nonatomic, weak) id<FQPlayerOperateViewDelegate> delegate;

- (void)prepare;

@end
