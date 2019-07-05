//
//  LGMatchListBasicCell.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGMatchListKeys.h"
#import "LGMatchListOddsView.h"
#import "FQComponentFactory.h"
#import "FQImageButton.h"

#define kLGMatchListBasicCellContainerHeight        kSizeScale(166.0)
#define kLGMatchListBasicCellHeight                 (kLGMatchListBasicCellContainerHeight + kCellMarginY)

#define kLGMatchListCellMarginX                     kSizeScale(6.0)
#define kLGMatchListCellMarginY                     kSizeScale(6.0)
#define kLGMatchListCellPaddingX                    kSizeScale(8.0)

NS_ASSUME_NONNULL_BEGIN

@protocol LGMatchListBasicCellProtocol <NSObject>

@required
- (void)addSubviews;

@end

@interface LGMatchListBasicCell : UITableViewCell <LGMatchListBasicCellProtocol>

@property (nonatomic, strong, readonly) UIView *containerView;
@property (nonatomic, strong, readonly) UIView *titleView;
@property (nonatomic, strong, readonly) LGMatchBasicOddsView *leftOddsView;
@property (nonatomic, strong, readonly) LGMatchBasicOddsView *rightOddsView;

@property (nonatomic, copy, readonly) NSDictionary *leftTeam;
@property (nonatomic, copy, readonly) NSDictionary *rightTeam;
@property (nonatomic, copy, readonly) NSDictionary *leftOdds;
@property (nonatomic, copy, readonly) NSDictionary *rightOdds;

@property (nonatomic, copy) NSDictionary *dataDic;

- (void)separateTeamsAndOdds;
- (void)setLeftScoreLayer:(CATextLayer *)leftLayer rightLayer:(CATextLayer *)rightLayer;
- (void)setTopBtn:(FQImageButton *)topBtn btmBtn:(FQImageButton *)btmBtn;

@end

@interface LGMatchListBasicCell (Factory)

- (void)generateScoreView:(__strong UIView *_Nullable*_Nullable)scoreView
                     line:(__weak CALayer *_Nullable*_Nullable)line
                     left:(__weak CATextLayer *_Nullable*_Nullable)left
                    right:(__weak CATextLayer *_Nullable*_Nullable)right;

- (void)generateTimeLabel:(__strong UILabel *_Nullable*_Nullable)timeLabel;

- (void)generateTopStatusBtn:(__strong FQImageButton *_Nonnull*_Nonnull)topStatusBtn;
- (void)generateBtmStatusBtn:(__strong FQImageButton *_Nonnull*_Nonnull)btmStatusBtn;
- (NSString *)shortStartTime:(NSString *)startTime;

@end

NS_ASSUME_NONNULL_END
