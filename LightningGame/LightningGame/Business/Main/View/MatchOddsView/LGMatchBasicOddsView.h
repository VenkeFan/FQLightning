//
//  LGMatchBasicOddsView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/30.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LGMatchBasicOddsViewStatus) {
    LGMatchBasicOddsViewStatus_Enable,
    LGMatchBasicOddsViewStatus_Disable,
    LGMatchBasicOddsViewStatus_Locked
};

NS_ASSUME_NONNULL_BEGIN

@interface LGMatchBasicOddsView : UIView

@property (nonatomic, assign) LGMatchBasicOddsViewStatus status;

@property (nonatomic, strong, readonly) UILabel *oddsLabel;
@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) CALayer *lockLayer;

- (void)setTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic matchName:(NSString *)matchName;

@end

NS_ASSUME_NONNULL_END
