//
//  LGMatchBasicOddsView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/30.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGMatchListKeys.h"

#define kViewPaddingX                       kSizeScale(6.0)
#define kViewPaddingY                       kSizeScale(4.0)

NS_ASSUME_NONNULL_BEGIN

@interface LGMatchBasicOddsView : UIView

@property (nonatomic, assign) LGMatchOddsStatus status;

@property (nonatomic, strong, readonly) UILabel *oddsLabel;
@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) CALayer *lockLayer;

- (void)setTeamDic:(NSDictionary *)teamDic oddsDic:(NSDictionary *)oddsDic matchName:(NSString *)matchName;
- (void)adjustNameLabelFont:(UILabel *)label maxWidth:(CGFloat)maxWidth;

@end

NS_ASSUME_NONNULL_END
