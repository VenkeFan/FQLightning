//
//  LGUserBankListView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LGUserBankListViewDelegate <NSObject>

- (void)userBankListViewDidSelected:(NSDictionary *)itemDic;

@end

@interface LGUserBankListView : LGAlertView

@property (nonatomic, weak) id<LGUserBankListViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
