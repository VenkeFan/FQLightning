//
//  FQNavigationBar.h
//  FQWidgets
//
//  Created by fan qi on 2018/5/9.
//  Copyright © 2018年 redefine. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNavBarPaddingX             (8.0)
#define kNavBarTitleFontSize        (16.0)

typedef NS_ENUM(NSInteger, FQNavigationBarTitleAlignment) {
    FQNavigationBarTitleAlignment_Left,
    FQNavigationBarTitleAlignment_Center
};

@protocol FQNavigationBarDelegate <NSObject>

@optional
- (void)navigationBarLeftBtnDidClicked;

@end

@interface FQNavigationBar : UIView

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIView *navLine;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, copy) NSArray<UIButton *> *leftBtnArray;
@property (nonatomic, copy) NSArray<UIButton *> *rightBtnArray;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL showLine;
@property (nonatomic, assign) FQNavigationBarTitleAlignment titleAlignment;
@property (nonatomic, weak) id<FQNavigationBarDelegate> delegate;

- (void)setLeftBtnTitle:(NSString *)title;
- (void)setLeftBtnImageName:(NSString *)imageName;
- (void)setRightBtnTitle:(NSString *)title;
- (void)setRightBtnImageName:(NSString *)imageName;

@end
