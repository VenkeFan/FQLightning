//
//  LGTradeListCell.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLGTradeListCellContainerHeight         kSizeScale(48.0)
#define kLGTradeListCellHeight                  (kLGTradeListCellContainerHeight + kCellMarginY)

NS_ASSUME_NONNULL_BEGIN

@interface LGTradeListCell : UITableViewCell

@property (nonatomic, copy) NSDictionary *itemDic;

@end

NS_ASSUME_NONNULL_END
