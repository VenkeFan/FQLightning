//
//  FQAlertView.h
//  FQWidgets
//
//  Created by fanqi on 17/6/28.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FQAlertView : UIView

@property (nonatomic, strong, readonly) UIView *contentView;

- (void)show;
- (void)showWithCompleted:(void (^)(void))completed;
- (void)dismiss;

@end
