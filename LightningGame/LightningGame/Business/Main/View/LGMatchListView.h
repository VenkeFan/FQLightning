//
//  LGMatchListView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGLazyLoadProtocol.h"
#import "LGMatchListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGMatchListView : UIView <LGLazyLoadProtocol>

@property (nonatomic, assign) LGMatchListType listType;
@property (nonatomic, copy) NSDictionary *filterGameIDDic;

@end

NS_ASSUME_NONNULL_END
