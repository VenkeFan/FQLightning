//
//  LGAlertOrderView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/24.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGAlertOrderView : LGAlertView

- (void)showWithOrderArray:(NSArray *)orderArray oddsInfoDic:(NSDictionary *)oddsInfoDic;

@end

NS_ASSUME_NONNULL_END
