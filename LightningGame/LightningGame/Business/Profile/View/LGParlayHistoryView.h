//
//  LGParlayHistoryView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/12.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGLazyLoadProtocol.h"
#import "LGOrderMetaKeys.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGParlayHistoryView : UIView <LGLazyLoadProtocol>

@property (nonatomic, assign) LGOrderStatus orderStatus;

@end

NS_ASSUME_NONNULL_END
