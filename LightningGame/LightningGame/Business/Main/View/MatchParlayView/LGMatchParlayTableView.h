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

extern NSString * const kMatchParlayTableViewRemoveItemNotif;
extern NSString * const kMatchParlayTableViewRemoveAllItemsNotif;

@protocol LGMatchParlayTableViewDelegate <NSObject>

- (void)matchParlayTableViewHeightDidChanged:(LGMatchParlayTableView *)view newHeight:(CGFloat)newHeight;
- (void)matchParlayTableViewDidClear:(LGMatchParlayTableView *)view;

@end

@interface LGMatchParlayTableView : UIView

@property (nonatomic, assign, readonly) NSUInteger itemCount;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, weak) id<LGMatchParlayTableViewDelegate> delegate;
- (BOOL)addTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic matchName:(NSString *)matchName;
- (BOOL)removeTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic matchName:(NSString *)matchName;
- (void)clearAll;

@end

NS_ASSUME_NONNULL_END
