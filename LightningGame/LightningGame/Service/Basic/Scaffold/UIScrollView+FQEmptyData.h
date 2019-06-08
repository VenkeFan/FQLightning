//
//  UIScrollView+FQEmptyData.h
//  FQWidgets
//
//  Created by fan qi on 2018/4/26.
//  Copyright © 2018年 redefine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FQScrollEmptyType) {
    FQScrollEmptyType_None = 0,
    FQScrollEmptyType_Empty_Data,
    FQScrollEmptyType_Empty_Relationship,
    FQScrollEmptyType_Empty_Message,
    FQScrollEmptyType_Empty_Deleted,
    FQScrollEmptyType_Empty_Network,
    FQScrollEmptyType_Empty_Location,
    FQScrollEmptyType_Empty_Topic
};

@protocol UIScrollViewEmptyDelegate <NSObject>

@optional
- (void)emptyScrollViewDidClickedBtn:(UIScrollView *)scrollView;

@end

@protocol UIScrollViewEmptyDataSource <NSObject>

@optional
- (UIImage *)imageForEmptyDataSource:(UIScrollView *)scrollView;
- (NSString *)descriptionForEmptyDataSource:(UIScrollView *)scrollView;
- (NSString *)buttonTitleForEmptyDataSource:(UIScrollView *)scrollView;

@end

@interface UIScrollView (FQEmptyData)

@property (nonatomic, weak) id<UIScrollViewEmptyDelegate> emptyDelegate;
@property (nonatomic, weak) id<UIScrollViewEmptyDataSource> emptyDataSource;

@property (nonatomic, assign) CGFloat emptyTop;

@property (nonatomic, assign, getter=isLoading) BOOL loading;

@property (nonatomic, assign) BOOL displayEmptyImage;
@property (nonatomic, assign) FQScrollEmptyType emptyType;

- (void)reloadEmptyData;

@end
