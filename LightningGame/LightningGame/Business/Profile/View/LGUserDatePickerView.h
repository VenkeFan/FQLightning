//
//  LGUserDatePickerView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGUserDatePickerView;

NS_ASSUME_NONNULL_BEGIN

@protocol LGUserDatePickerViewDelegate <NSObject>

- (void)userDatePickerView:(LGUserDatePickerView *)view didSelectedDate:(NSDate *)date;

@end

@interface LGUserDatePickerView : UIView

@property (nonatomic, weak) id<LGUserDatePickerViewDelegate> delegate;

- (void)displayInParentView:(UIView *)parentView;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
