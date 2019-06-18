//
//  LGMatchDetailHeaderView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGMatchDetailHeaderView;

NS_ASSUME_NONNULL_BEGIN

@protocol LGMatchDetailHeaderViewDelegate <NSObject>

- (void)matchDetailHeaderViewDidPlay:(LGMatchDetailHeaderView *)view;

@end

@interface LGMatchDetailHeaderView : UIView

@property (nonatomic, copy) NSDictionary *dataDic;
@property (nonatomic, weak) id<LGMatchDetailHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
