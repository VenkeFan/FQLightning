//
//  LGMatchBasicOddsView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/30.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LGMatchOddsStatus) {
    LGMatchOddsStatus_Normal = 1,
    LGMatchOddsStatus_Locked = 2,
    LGMatchOddsStatus_Hidden = 4,
    LGMatchOddsStatus_Finished = 5,
    LGMatchOddsStatus_Exception = 99
};

NS_ASSUME_NONNULL_BEGIN

@interface LGMatchBasicOddsView : UIView

@property (nonatomic, assign) LGMatchOddsStatus status;

@property (nonatomic, strong, readonly) UILabel *oddsLabel;
@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) CALayer *lockLayer;

- (void)setTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic matchName:(NSString *)matchName;

@end

NS_ASSUME_NONNULL_END
