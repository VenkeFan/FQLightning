//
//  FQAlertView.h
//  FQWidgets
//
//  Created by fanqi on 17/6/28.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FQAlertViewPopDirection) {
    FQAlertViewPopDirectionFromBottom,  ///< bottom to top
    FQAlertViewPopDirectionFromTop      ///< top to bottom
};

typedef NS_ENUM(NSInteger, FQAlertViewPopPosition) {
    FQAlertViewPopPositionBottom,
    FQAlertViewPopPositionCenter
};

@interface FQAlertView : UIView

@property (nonatomic, strong, readonly) UIView *containerView;
@property (nonatomic, assign) FQAlertViewPopDirection direction;
@property (nonatomic, assign) FQAlertViewPopPosition position;

- (void)displayInWindow;
- (void)displayInParentView:(UIView *)parentView;
- (void)displayInParentView:(UIView *)parentView completed:(void (^)(void))completed;
- (void)dismiss;

@end
