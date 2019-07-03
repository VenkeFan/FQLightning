//
//  LGGameCollectionView.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGGameCollectionView;

NS_ASSUME_NONNULL_BEGIN

@protocol LGGameCollectionViewDelegate <NSObject>

- (void)gameViewDidSelected:(LGGameCollectionView *)gameView gameIDDic:(NSDictionary *)gameIDDic;;

@end

@interface LGGameCollectionView : UIView

@property (nonatomic, assign, readonly) BOOL isDisplaying;

@property (nonatomic, weak) id<LGGameCollectionViewDelegate> delegate;

- (void)displayInView:(UIView *)parentView;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
