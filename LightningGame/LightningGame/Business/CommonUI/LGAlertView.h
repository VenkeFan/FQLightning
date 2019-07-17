//
//  LGAlertView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "FQAlertView.h"

#define kAlertTopViewHeight                kSizeScale(40.0)

NS_ASSUME_NONNULL_BEGIN

@interface LGAlertView : FQAlertView

@property (nonatomic, strong, readonly) UIView *topView;
@property (nonatomic, strong) UIView *titleView;

@end

NS_ASSUME_NONNULL_END
