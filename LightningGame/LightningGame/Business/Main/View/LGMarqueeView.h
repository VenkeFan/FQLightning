//
//  LGMarqueeView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/30.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMarqueeViewHeight              kSizeScale(22.0)

NS_ASSUME_NONNULL_BEGIN

@interface LGMarqueeView : UIView

- (void)fetchData;

@end

NS_ASSUME_NONNULL_END
