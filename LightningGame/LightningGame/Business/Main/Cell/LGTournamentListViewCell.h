//
//  LGTournamentListViewCell.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLGTournamentListViewCellContainerHeight        kSizeScale(166.0)
#define kLGTournamentListViewCellHeight                 (kLGTournamentListViewCellContainerHeight + kCellMarginY)

NS_ASSUME_NONNULL_BEGIN

@interface LGTournamentListViewCell : UITableViewCell

@property (nonatomic, copy) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
