//
//  FQAuthorizationHelper.m
//  FQWidgets
//
//  Created by fan qi on 2018/6/7.
//  Copyright © 2018年 redefine. All rights reserved.
//

#import "FQAuthorizationHelper.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSInteger, FQAuthorizationType) {
    FQAuthorizationType_Photo,
    FQAuthorizationType_Camera,
    FQAuthorizationType_Microphone,
    FQAuthorizationType_Location
};

@implementation FQAuthorizationHelper

#pragma mark - Public

+ (void)requestPhotoAuthorizationWithFinished:(AuthorizeFinished)finished {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        
        if (authStatus == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                BOOL granted = (status == PHAuthorizationStatusAuthorized);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(granted);
                    }
                });
            }];
        } else if (authStatus == PHAuthorizationStatusAuthorized) {
            if (finished) {
                finished(YES);
            }
        } else {
            [self p_showMessageWithType:FQAuthorizationType_Photo finished:finished];
        }
    }
}

+ (void)requestCameraAuthorizationWithFinished:(AuthorizeFinished)finished {
    AVMediaType mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:mediaType
                                 completionHandler:^(BOOL granted) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (finished) {
                                             finished(granted);
                                         }
                                     });
                                 }];
    } else if (status == AVAuthorizationStatusAuthorized) {
        if (finished) {
            finished(YES);
        }
    } else {
        [self p_showMessageWithType:FQAuthorizationType_Camera finished:finished];
    }
}

+ (void)requestMicrophoneAuthorizationWithFinished:(AuthorizeFinished)finished {
    AVMediaType mediaType = AVMediaTypeAudio;
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:mediaType
                                 completionHandler:^(BOOL granted) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (finished) {
                                             finished(granted);
                                         }
                                     });
                                 }];
    } else if (status == AVAuthorizationStatusAuthorized) {
        if (finished) {
            finished(YES);
        }
    } else {
        [self p_showMessageWithType:FQAuthorizationType_Microphone finished:finished];
    }
}

#pragma mark - Private

+ (void)p_showMessageWithType:(FQAuthorizationType)type finished:(AuthorizeFinished)finished {
//    NSString *str = nil;
//    
//    switch (type) {
//        case FQAuthorizationType_Photo:
//            str = [AppContext getStringForKey:@"authorize_photo" fileName:@"common"];
//            break;
//        case FQAuthorizationType_Camera:
//            str = [AppContext getStringForKey:@"authorize_camera" fileName:@"common"];
//            break;
//        case FQAuthorizationType_Microphone:
//            str = [AppContext getStringForKey:@"authorize_microphone" fileName:@"common"];
//            break;
//        case FQAuthorizationType_Location:
//            str = [AppContext getStringForKey:@"authorize_location" fileName:@"common"];
//            break;
//    }
//    
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
//                                                                   message:str
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:[AppContext getStringForKey:@"mine_setting_text" fileName:@"user"]
//                                              style:UIAlertActionStyleDefault
//                                            handler:^(UIAlertAction * _Nonnull action) {
//                                                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                                                
//                                                if (@available(iOS 10.0, *)) {
//                                                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//                                                } else {
//                                                    [[UIApplication sharedApplication] openURL:url];
//                                                }
//                                            }]];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:[AppContext getStringForKey:@"common_cancel" fileName:@"common"]
//                                              style:UIAlertActionStyleCancel
//                                            handler:^(UIAlertAction * _Nonnull action) {
//                                                if (finished) {
//                                                    finished(NO);
//                                                }
//                                            }]];
//    
//    [[UIViewController currentViewController] presentViewController:alert animated:YES completion:nil];
}

@end
