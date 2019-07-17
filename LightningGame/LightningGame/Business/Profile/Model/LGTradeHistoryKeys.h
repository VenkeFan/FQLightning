//
//  LGTradeHistoryKeys.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/17.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#ifndef LGTradeHistoryKeys_h
#define LGTradeHistoryKeys_h

typedef NS_ENUM(NSInteger, LGTradeType) {
    LGTradeTypeAll = 0,
    LGTradeTypeCharge = 3,
    LGTradeTypeWithdraw = 4,
    LGTradeTypeDiscount = 5
};

typedef NS_ENUM(NSInteger, LGTradeWithdrawStatus) {
    LGTradeWithdrawStatusInit = 0,
    LGTradeWithdrawStatusProcess = 1,
    LGTradeWithdrawStatusSuccees = 2,
    LGTradeWithdrawStatusFailure = 3
};

typedef NS_ENUM(NSInteger, LGTradeChargeStatus) {
    LGTradeChargeStatusInit = 0,
    LGTradeChargeStatusSuccees = 1,
    LGTradeChargeStatusFailure = 2
};

static inline NSString* tradeTypeMapping(LGTradeType type) {
    NSString *str = @"";
    
    switch (type) {
        case LGTradeTypeAll:
            str = kLocalizedString(@"trade_all");
            break;
        case LGTradeTypeCharge:
            str = kLocalizedString(@"trade_charge");
            break;
        case LGTradeTypeWithdraw:
            str = kLocalizedString(@"trade_withdraw");
            break;
        case LGTradeTypeDiscount:
            str = kLocalizedString(@"trade_discount");
            break;
    }
    
    return str;
}

static inline NSString* chargeStatusMapping(LGTradeChargeStatus status) {
    NSString *str = @"";
    
    switch (status) {
        case LGTradeChargeStatusInit:
            str = @"已提交";
            break;
        case LGTradeChargeStatusSuccees:
            str = @"成功";
            break;
        case LGTradeChargeStatusFailure:
            str = @"失败";
            break;
    }
    
    return str;
}

static inline NSString* withdrawStatusMapping(LGTradeWithdrawStatus status) {
    NSString *str = @"";
    
    switch (status) {
        case LGTradeWithdrawStatusInit:
            str = @"已提交";
            break;
        case LGTradeWithdrawStatusProcess:
            str = @"处理中";
            break;
        case LGTradeWithdrawStatusSuccees:
            str = @"成功";
            break;
        case LGTradeWithdrawStatusFailure:
            str = @"失败";
            break;
    }
    
    return str;
}

extern NSString * const kTradeHistoryKeyWithdrawStatus;
extern NSString * const kTradeHistoryKeyID;
extern NSString * const kTradeHistoryKeyMoney;
extern NSString * const kTradeHistoryKeyChargeStatus;
extern NSString * const kTradeHistoryKeyTimestamp;
extern NSString * const kTradeHistoryKeyType;

#endif /* LGTradeHistoryKeys_h */
