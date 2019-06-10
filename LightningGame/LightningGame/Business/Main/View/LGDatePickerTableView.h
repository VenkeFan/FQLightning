//
//  LGDatePickerTableView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/10.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGDatePickerViewModel, LGDatePickerTableView;

NS_ASSUME_NONNULL_BEGIN

@protocol LGDatePickerTableViewDelegate <NSObject>

- (void)datePickerTableView:(LGDatePickerTableView *)view didSelectIndex:(NSUInteger)index;

@end

@interface LGDatePickerTableView : UIView

@property (nonatomic, strong) LGDatePickerViewModel *viewModel;
@property (nonatomic, weak) id<LGDatePickerTableViewDelegate> delegate;

- (void)displayInParentView:(UIView *)parentView;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
