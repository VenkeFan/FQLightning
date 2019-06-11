//
//  LGMatchParlayTopView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/5.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGMatchParlayTopView;

#define kLGMatchParlayViewTopHeight                 kSizeScale(40.0)

NS_ASSUME_NONNULL_BEGIN

@protocol LGMatchParlayTopViewDelegate <NSObject>

- (void)matchParlayTopViewDidClear:(LGMatchParlayTopView *)view;
- (void)matchParlayTopViewDidClose:(LGMatchParlayTopView *)view;

@end

@interface LGMatchParlayTopView : UIView

@property (nonatomic, assign) NSUInteger itemCount;
@property (nonatomic, weak) id<LGMatchParlayTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
