//
//  FQAuthorizationHelper.h
//  FQWidgets
//
//  Created by fan qi on 2018/6/7.
//  Copyright © 2018年 redefine. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AuthorizeFinished)(BOOL granted);

@interface FQAuthorizationHelper : NSObject

+ (void)requestPhotoAuthorizationWithFinished:(AuthorizeFinished)finished;
+ (void)requestCameraAuthorizationWithFinished:(AuthorizeFinished)finished;
+ (void)requestMicrophoneAuthorizationWithFinished:(AuthorizeFinished)finished;

@end
