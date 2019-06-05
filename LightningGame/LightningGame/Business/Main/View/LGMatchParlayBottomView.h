//
//  LGMatchParlayBottomView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/5.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGMatchParlayBottomView;

#define kLGMatchParlayViewBottomContentHeight       kSizeScale(45.0)
#define kLGMatchParlayViewBottomHeight              (kLGMatchParlayViewBottomContentHeight + kSafeAreaBottomY)

NS_ASSUME_NONNULL_BEGIN

@protocol LGMatchParlayBottomViewDelegate <NSObject>

- (void)matchParlayBottomViewDidChangeExpand:(LGMatchParlayBottomView *)view;

@end

@interface LGMatchParlayBottomView : UIView

@property (nonatomic, assign, getter=isExpanded) BOOL expanded;
@property (nonatomic, assign) NSUInteger itemCount;
@property (nonatomic, weak) id<LGMatchParlayBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
