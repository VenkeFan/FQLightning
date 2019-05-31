//
//  LGTournamentListView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGTournamentListManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGTournamentListView : UIView

@property (nonatomic, assign) LGTournamentListType listType;

- (void)display;

@end

NS_ASSUME_NONNULL_END
