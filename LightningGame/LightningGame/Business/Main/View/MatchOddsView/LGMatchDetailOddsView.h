//
//  LGMatchDetailOddsView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/14.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGMatchBasicOddsView.h"

#define kMatchTeamOddsHViewWidth            kSizeScale(160.0)
#define kMatchTeamOddsHViewHeight           kSizeScale(40.0)

typedef NS_ENUM(NSInteger, LGMatchDetailOddsViewDirection) {
    LGMatchDetailOddsView_Left,
    LGMatchDetailOddsView_Right
};

NS_ASSUME_NONNULL_BEGIN

@interface LGMatchDetailOddsView : LGMatchBasicOddsView

@property (nonatomic, assign) LGMatchDetailOddsViewDirection direction;

@end

NS_ASSUME_NONNULL_END
