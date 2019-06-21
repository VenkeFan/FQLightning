//
//  LGMatchParlayTableViewCell.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGMatchParlayTableViewCell;

#define kLGMatchParlayTableViewCellHeight                   kSizeScale(68.0)

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kLGMatchParlayTableViewCellKeyTeamDic;
extern NSString * const kLGMatchParlayTableViewCellKeyOddsDic;
extern NSString * const kLGMatchParlayTableViewCellKeyMatchName;
extern NSString * const kLGMatchParlayTableViewCellKeyFieldFocused;
extern NSString * const kLGMatchParlayTableViewCellKeyAnte;

@protocol LGMatchParlayTableViewCellDelegate <NSObject>

- (void)matchParlayTableCellDidDeleted:(LGMatchParlayTableViewCell *)cell;
- (void)matchParlayTableCellKeyboardWillShow:(LGMatchParlayTableViewCell *)cell;
- (void)matchParlayTableCellKeyboardWillHide:(LGMatchParlayTableViewCell *)cell;
- (void)matchParlayTableCellOnTapped:(LGMatchParlayTableViewCell *)cell;
- (void)matchParlayTableCellDidBetting:(LGMatchParlayTableViewCell *)cell;

@end

@interface LGMatchParlayTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, weak) id<LGMatchParlayTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
