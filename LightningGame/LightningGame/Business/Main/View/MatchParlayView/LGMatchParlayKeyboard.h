//
//  LGMatchParlayKeyboard.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/4.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGMatchParlayKeyboard;

#define kLGMatchParlayKeyboardHeight                kSizeScale(70.0)

extern NSInteger const kMatchParlayMaxBet;

NS_ASSUME_NONNULL_BEGIN

@protocol LGMatchParlayKeyboardDelegate <NSObject>

- (void)matchParlayKeyboard:(LGMatchParlayKeyboard *)keyboard number:(NSInteger)number;
- (void)matchParlayKeyboard:(LGMatchParlayKeyboard *)keyboard maxBet:(NSInteger)maxBet;
- (void)matchParlayKeyboardDeleted:(LGMatchParlayKeyboard *)keyboard;
- (void)matchParlayKeyboardConfirmed:(LGMatchParlayKeyboard *)keyboard;

@end

@interface LGMatchParlayKeyboard : UIView

@property (nonatomic, weak) id<LGMatchParlayKeyboardDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
