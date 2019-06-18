//
//  FQPlayerConfig.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/18.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#ifndef FQPlayerConfig_h
#define FQPlayerConfig_h

typedef NS_ENUM(NSInteger, FQPlayerViewStatus) {
    FQPlayerViewStatus_Unknown,
    FQPlayerViewStatus_ReadyToPlay,
    FQPlayerViewStatus_Playing,
    FQPlayerViewStatus_Paused,
    FQPlayerViewStatus_CachingPaused,
    FQPlayerViewStatus_Stopped,
    FQPlayerViewStatus_Completed,
    FQPlayerViewStatus_Failed
};

typedef NS_ENUM(NSInteger, FQPlayerViewWindowMode) {
    FQPlayerViewWindowMode_Screen,
    FQPlayerViewWindowMode_Widget
};

typedef NS_ENUM(NSInteger, FQPlayerViewOrientation) {
    FQPlayerViewOrientation_Portrait,
    FQPlayerViewOrientation_Landscape
};

typedef NS_ENUM(NSInteger, WLPlayerViewGravity) {
    WLPlayerViewGravity_ResizeAspectFill,
    WLPlayerViewGravity_ResizeAspect
};

#endif /* FQPlayerConfig_h */
