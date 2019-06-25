//
//  LGMatchParlayViewModel.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/21.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGMatchParlayViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol LGMatchParlayViewModelDelegate <NSObject>

- (void)matchParlayViewModel:(LGMatchParlayViewModel *)viewModel responseObj:(nullable id)responseObj error:(nullable NSError *)error;

@end

@interface LGMatchParlayViewModel : NSObject

@property (nonatomic, weak) id<LGMatchParlayViewModelDelegate> delegate;

- (void)parlayWithOddsDic:(NSDictionary *)oddsDic;

@end

NS_ASSUME_NONNULL_END
