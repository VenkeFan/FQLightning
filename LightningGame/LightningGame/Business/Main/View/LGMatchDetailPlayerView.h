//
//  LGMatchDetailPlayerView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGMatchDetailPlayerView;

NS_ASSUME_NONNULL_BEGIN

@protocol LGMatchDetailPlayerViewDelegate <NSObject>

- (void)matchDetailPlayerViewDidStop:(LGMatchDetailPlayerView *)view;

@end

@interface LGMatchDetailPlayerView : UIView

@property (nonatomic, copy) NSDictionary *dataDic;
@property (nonatomic, weak) id<LGMatchDetailPlayerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
