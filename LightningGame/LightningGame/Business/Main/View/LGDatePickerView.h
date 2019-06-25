//
//  LGDatePickerView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/10.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGDatePickerViewModel.h"

@class LGDatePickerView;

#define kDatePickerViewHeight              kSizeScale(22.0)

NS_ASSUME_NONNULL_BEGIN

@protocol LGDatePickerViewDelegate <NSObject>

- (void)datePickerViewDidClickedDate:(LGDatePickerView *)view;
- (void)datePickerViewDidChanged:(LGDatePickerView *)view newIndex:(NSUInteger)newIndex;

@end

@interface LGDatePickerView : UIView

@property (nonatomic, strong, readonly) LGDatePickerViewModel *viewModel;
@property (nonatomic, weak) id<LGDatePickerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
