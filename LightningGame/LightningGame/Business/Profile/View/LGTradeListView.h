//
//  LGTradeListView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGTradeHistoryKeys.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGTradeListView : UIView

@property (nonatomic, assign) LGTradeType tradeType;

- (void)display;

@end

NS_ASSUME_NONNULL_END
