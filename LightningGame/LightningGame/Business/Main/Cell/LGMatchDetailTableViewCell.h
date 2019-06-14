//
//  LGMatchDetailTableViewCell.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/13.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGMatchDetailTableViewCell : UITableViewCell

- (void)setMatchDic:(NSDictionary *)matchDic teamArray:(NSArray *)teamArray oddsArray:(NSArray *)oddsArray;
+ (CGFloat)cellHeight:(NSArray *)oddsArray;

@end

NS_ASSUME_NONNULL_END
