//
//  LGTradeListView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGLazyLoadProtocol.h"
#import "LGTradeHistoryKeys.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGTradeListView : UIView <LGLazyLoadProtocol>

@property (nonatomic, assign) LGTradeType tradeType;

@end

NS_ASSUME_NONNULL_END
