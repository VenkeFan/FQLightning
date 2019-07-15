//
//  LGProfileViewCell.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LGProfileViewCellAccessoryType) {
    LGProfileViewCellAccessoryTypeNone,
    LGProfileViewCellAccessoryTypeDisclosureIndicator,
    LGProfileViewCellAccessoryTypeSwitchButton,
    LGProfileViewCellAccessoryTypeDatePicker,
};

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kProfileItemTitleKey;
extern NSString * const kProfileItemBadgeKey;
extern NSString * const kProfileItemIconKey;
extern NSString * const kProfileItemAccessoryInfoKey;
extern NSString * const kProfileItemAccessoryTypeKey;
extern NSString * const kProfileItemClassKey;

@interface LGProfileViewCell : UITableViewCell

@property (nonatomic, copy) NSDictionary *itemDic;

@end

NS_ASSUME_NONNULL_END
