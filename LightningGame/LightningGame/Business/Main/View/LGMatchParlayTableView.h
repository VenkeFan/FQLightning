//
//  LGMatchParlayTableView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGMatchParlayTableViewCell.h"

@class LGMatchParlayTableView;

#define kLGMatchParlayTableViewMaxCellCount             (8)

NS_ASSUME_NONNULL_BEGIN

@protocol LGMatchParlayTableViewDelegate <NSObject>

- (void)matchParlayTableViewHeightDidChanged:(LGMatchParlayTableView *)view newHeight:(CGFloat)newHeight;
- (void)matchParlayTableViewDidClear:(LGMatchParlayTableView *)view;

@end

@interface LGMatchParlayTableView : UIView

@property (nonatomic, assign, readonly) NSUInteger itemCount;
@property (nonatomic, weak) id<LGMatchParlayTableViewDelegate> delegate;
- (void)addTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic matchName:(NSString *)matchName;
- (void)clearAll;

@end

NS_ASSUME_NONNULL_END
