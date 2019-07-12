//
//  LGParlayHistoryCell.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/12.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLGParlayHistoryCellContainerHeight         kSizeScale(200.0)
#define kLGParlayHistoryCellHeight                  (kLGParlayHistoryCellContainerHeight + kCellMarginY)

NS_ASSUME_NONNULL_BEGIN

@interface LGParlayHistoryCell : UITableViewCell

@property (nonatomic, copy) NSDictionary *itemDic;

@end

NS_ASSUME_NONNULL_END
