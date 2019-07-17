//
//  LGBankListView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LGBankListViewDelegate <NSObject>

- (void)bankListViewDidSelected:(NSDictionary *)itemDic;

@end

@interface LGBankListView : LGAlertView

@property (nonatomic, weak) id<LGBankListViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
