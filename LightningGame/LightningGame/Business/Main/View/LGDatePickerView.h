//
//  LGDatePickerView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/10.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGDatePickerView, LGDatePickerViewModel;

#define kDatePickerViewHeight              kSizeScale(22.0)

NS_ASSUME_NONNULL_BEGIN

@protocol LGDatePickerViewDelegate <NSObject>

- (void)datePickerViewDidClickedDate:(LGDatePickerView *)view;

@end

@interface LGDatePickerView : UIView

@property (nonatomic, strong, readonly) LGDatePickerViewModel *viewModel;
@property (nonatomic, assign, getter=isPreviously) BOOL previously;
@property (nonatomic, weak) id<LGDatePickerViewDelegate> delegate;

- (void)setIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
