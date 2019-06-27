//
//  LGMatchListKeys.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/29.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#ifndef LGMatchListKeys_h
#define LGMatchListKeys_h

typedef NS_ENUM(NSInteger, LGMatchListType) {
    LGMatchListType_Today = 1,
    LGMatchListType_Rolling = 2,
    LGMatchListType_Prepare = 3,
    LGMatchListType_Finished = 4
};

typedef NS_ENUM(NSInteger, LGMatchStatus) {
    LGMatchStatus_Prepare = 1,
    LGMatchStatus_Rolling = 2,
    LGMatchStatus_Finished = 3,
    LGMatchStatus_Canceled = 4
};

typedef NS_ENUM(NSInteger, LGMatchOddsStatus) {
    LGMatchOddsStatus_Normal = 1,
    LGMatchOddsStatus_Locked = 2,
    LGMatchOddsStatus_Hidden = 4,
    LGMatchOddsStatus_Finished = 5,
    LGMatchOddsStatus_Exception = 99
};

#pragma mark - MatchKey

extern NSString * const kMatchKeyGameID;
extern NSString * const kMatchKeyStatus;
extern NSString * const kMatchKeyID;
extern NSString * const kMatchKeyEnableParlay;
extern NSString * const kMatchKeyGameName;
extern NSString * const kMatchKeyMatchName;
extern NSString * const kMatchKeyMatchShortName;
extern NSString * const kMatchKeyStartTime;
extern NSString * const kMatchKeyEndTime;
extern NSString * const kMatchKeyRound;
extern NSString * const kMatchKeyTournamentID;
extern NSString * const kMatchKeyTournamentName;
extern NSString * const kMatchKeyTournamentShortName;
extern NSString * const kMatchKeyPlayCount;
extern NSString * const kMatchKeyTeamArray;
extern NSString * const kMatchKeyOddsArray;
extern NSString * const kMatchKeyLiveUrl;

#pragma mark - TeamKey

extern NSString * const kMatchTeamKeyTeamID;
extern NSString * const kMatchTeamKeyLogo;
extern NSString * const kMatchTeamKeyName;
extern NSString * const kMatchTeamKeyShortName;
extern NSString * const kMatchTeamKeyScore;
extern NSString * const kMatchTeamKeyPos;
extern NSString * const kMatchTeamKeyID;
extern NSString * const kMatchTeamKeyMatchID;

#pragma mark - ScoreKey

extern NSString * const kMatchScoreKeyTotal;

#pragma mark - OddsKey

extern NSString * const kMatchOddsKeyEnableParlay;
extern NSString * const kMatchOddsKeyGameID;
extern NSString * const kMatchOddsKeyTournamentID;
extern NSString * const kMatchOddsKeySortIndex;
extern NSString * const kMatchOddsKeyGroupID;
extern NSString * const kMatchOddsKeyValue;
extern NSString * const kMatchOddsKeyWin;
extern NSString * const kMatchOddsKeyStatus;
extern NSString * const kMatchOddsKeyBetLimit;
extern NSString * const kMatchOddsKeyLastUpdate;
extern NSString * const kMatchOddsKeyMatchStage;
extern NSString * const kMatchOddsKeyMatchName;
extern NSString * const kMatchOddsKeyGroupName;
extern NSString * const kMatchOddsKeyGroupShortName;
extern NSString * const kMatchOddsKeyID;
extern NSString * const kMatchOddsKeyOddsID;
extern NSString * const kMatchOddsKeyTeamID;
extern NSString * const kMatchOddsKeyName;
extern NSString * const kMatchOddsKeyMatchID;
extern NSString * const kMatchOddsKeyOddsValue;
extern NSString * const kMatchOddsKeyTag;
extern NSString * const kMatchOddsExoticKeyIsSelected;

#endif /* LGMatchListKeys_h */
