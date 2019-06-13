//
//  LGMatchListManager.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGMatchListKeys.h"

@class LGMatchListManager;

typedef NS_ENUM(NSInteger, LGMatchListType) {
    LGMatchListType_Today,
    LGMatchListType_Rolling,
    LGMatchListType_Before,
    LGMatchListType_Finished
};

NS_ASSUME_NONNULL_BEGIN

@protocol LGMatchListManagerDelegate <NSObject>

- (void)managerDidFetch:(LGMatchListManager *)manager data:(NSArray *)data last:(BOOL)last errCode:(NSInteger)errCode;
- (void)managerDidMore:(LGMatchListManager *)manager data:(NSArray *)data last:(BOOL)last errCode:(NSInteger)errCode;

@end

@interface LGMatchListManager : NSObject

@property (nonatomic, weak) id<LGMatchListManagerDelegate> delegate;
@property (nonatomic, assign) LGMatchListType listType;

- (void)fetchData;
- (void)loadMoreData;

@end

NS_ASSUME_NONNULL_END
