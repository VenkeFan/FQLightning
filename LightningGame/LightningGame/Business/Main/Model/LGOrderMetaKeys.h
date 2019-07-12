//
//  LGOrderMetaKeys.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/25.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#ifndef LGOrderMetaKeys_h
#define LGOrderMetaKeys_h

typedef NS_ENUM(NSInteger, LGOrderStatus) {
    LGOrderStatus_UnSettle = 0,
    LGOrderStatus_Settled = 1,
};

#pragma mark - Order Meta

extern NSString * const kOrderMetaKeyCode;
extern NSString * const kOrderMetaKeyOddsID;
extern NSString * const kOrderMetaKeyOddsValue;
extern NSString * const kOrderMetaKeyBetMoney;
extern NSString * const kOrderMetaKeyGainMoney;
extern NSString * const kOrderMetaKeyCreatedTimeStamp;
extern NSString * const kOrderMetaKeyID;
extern NSString * const kOrderMetaKeyBetOddsValue;
extern NSString * const kOrderMetaKeySite;
extern NSString * const kOrderMetaKeyGameID;
extern NSString * const kOrderMetaKeyGameLogo;
extern NSString * const kOrderMetaKeyGameName;
extern NSString * const kOrderMetaKeyGroupID;
extern NSString * const kOrderMetaKeyGroupName;
extern NSString * const kOrderMetaKeyGroupShortName;
extern NSString * const kOrderMetaKeyMatchID;
extern NSString * const kOrderMetaKeyMatchName;
extern NSString * const kOrderMetaKeyMatchShortName;
extern NSString * const kOrderMetaKeyMatchStage;
extern NSString * const kOrderMetaKeyOddsName;
extern NSString * const kOrderMetaKeyOrderNumber;
extern NSString * const kOrderMetaKeyOperationStatus;
extern NSString * const kOrderMetaKeyRealGainMoney;
extern NSString * const kOrderMetaKeyMatchStartTimeStamp;
extern NSString * const kOrderMetaKeyOrderStatus;
extern NSString * const kOrderMetaKeyBetResult;

#endif /* LGOrderMetaKeys_h */
