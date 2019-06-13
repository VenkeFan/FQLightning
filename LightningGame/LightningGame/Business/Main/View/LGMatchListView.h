//
//  LGMatchListView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGMatchListManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGMatchListView : UIView

@property (nonatomic, assign) LGMatchListType listType;

- (void)display;

@end

NS_ASSUME_NONNULL_END
