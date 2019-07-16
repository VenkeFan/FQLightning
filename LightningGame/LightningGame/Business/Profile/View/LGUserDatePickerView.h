//
//  LGUserDatePickerView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "FQAlertView.h"

@class LGUserDatePickerView;

NS_ASSUME_NONNULL_BEGIN

@protocol LGUserDatePickerViewDelegate <NSObject>

- (void)userDatePickerView:(LGUserDatePickerView *)view didSelectedDate:(NSDate *)date;

@end

@interface LGUserDatePickerView : FQAlertView

@property (nonatomic, weak) id<LGUserDatePickerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
