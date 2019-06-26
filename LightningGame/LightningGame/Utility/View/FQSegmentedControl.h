//
//  FQSegmentedControl.h
//  FQWidgets
//
//  Created by fan qi on 2018/5/4.
//  Copyright © 2018年 fan qi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSegmentHeight               40

@class FQSegmentedControl;

@protocol FQSegmentedControlDelegate <NSObject>

@optional
- (void)segmentedControl:(FQSegmentedControl *)control didSelectedIndex:(NSInteger)index preIndex:(NSInteger)preIndex animated:(BOOL)animated;

@end

@interface FQSegmentedControl : UIControl

@property (nonatomic, copy) NSArray *items;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *onTintColor;
@property (nonatomic, strong) UIColor *markLineColor;
@property (nonatomic, strong) UIColor *hSeparateLineColor;
@property (nonatomic, strong) UIFont *tintFont;
@property (nonatomic, strong) UIFont *onTintFont;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL hasVSeparateLine;
@property (nonatomic, weak) id<FQSegmentedControlDelegate> delegate;

@property (nonatomic, assign, readonly) NSInteger preIndex;
@property (nonatomic, assign, readonly, getter=isShowShadow) BOOL showShadow;

- (void)setLineOffsetX:(CGFloat)x;
- (void)hideTitleTipWithIndex:(NSInteger)index;

- (void)addShadow;
- (void)clearShadow;

@end
