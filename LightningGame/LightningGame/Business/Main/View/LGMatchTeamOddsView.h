//
//  LGMatchTeamOddsView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/30.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LGMatchTeamOddsViewStatus) {
    LGMatchTeamOddsViewStatus_Enable,
    LGMatchTeamOddsViewStatus_Disable,
    LGMatchTeamOddsViewStatus_Locked
};

typedef NS_ENUM(NSInteger, LGMatchTeamOddsViewDirection) {
    LGMatchTeamOddsViewDirection_Horizontal,
    LGMatchTeamOddsViewDirection_Vertical
};

NS_ASSUME_NONNULL_BEGIN

@interface LGMatchTeamOddsView : UIView

@property (nonatomic, assign) LGMatchTeamOddsViewStatus status;
@property (nonatomic, assign) LGMatchTeamOddsViewDirection direction;

- (void)setTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic;

@end

NS_ASSUME_NONNULL_END
