//
//  LGTournamentListManager.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGTournamentListKeys.h"

@class LGTournamentListManager;

typedef NS_ENUM(NSInteger, LGTournamentListType) {
    LGTournamentListType_Today,
    LGTournamentListType_Rolling,
    LGTournamentListType_Before,
    LGTournamentListType_Finished
};

NS_ASSUME_NONNULL_BEGIN

@protocol LGTournamentListManagerDelegate <NSObject>

- (void)managerDidFetch:(LGTournamentListManager *)manager data:(NSArray *)data last:(BOOL)last errCode:(NSInteger)errCode;
- (void)managerDidMore:(LGTournamentListManager *)manager data:(NSArray *)data last:(BOOL)last errCode:(NSInteger)errCode;

@end

@interface LGTournamentListManager : NSObject

@property (nonatomic, weak) id<LGTournamentListManagerDelegate> delegate;
@property (nonatomic, assign) LGTournamentListType listType;

- (void)fetchData;
- (void)loadMoreData;

@end

NS_ASSUME_NONNULL_END
