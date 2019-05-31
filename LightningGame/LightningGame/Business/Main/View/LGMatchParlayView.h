//
//  LGMatchParlayView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/31.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGMatchParlayView : UIView

+ (instancetype)instance;

@property (nonatomic, assign, getter=isExpanded) BOOL expanded;

- (void)addTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic;

- (void)display;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
