//
//  LGGameCollectionViewModel.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGGameCollectionViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol LGGameCollectionViewModelDelegate <NSObject>

- (void)gameListDidFetch:(LGGameCollectionViewModel *)viewModel data:(nullable NSArray *)data error:(nullable NSError *)error;

@end

@interface LGGameCollectionViewModel : NSObject

@property (nonatomic, weak) id<LGGameCollectionViewModelDelegate> delegate;
- (void)fetchGameList;

@end

NS_ASSUME_NONNULL_END
