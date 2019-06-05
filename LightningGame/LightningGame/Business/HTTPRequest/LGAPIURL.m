//
//  LGNetworkURL.m
//  FQWidgets
//
//  Created by fanqi on 17/7/19.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "LGAPIURL.h"

#ifndef CCTV
#define CCTV    1
#endif

#ifdef CCTV
#define kBasicURLDefine           @"http://test.FQWidgets.com/"
#else
#define kBasicURLDefine           @"http://www.FQWidgets.com/"
#endif

NSString * const kBasicURL                                  = kBasicURLDefine;
NSString * const kLGImageHost                               = @"https://www.nmgdjkj.com/";

#pragma mark - 帐号相关

NSString * const kLoginChannelURL                           = @"api/v1/sessions";
NSString * const kOAuthLoginURL                             = @"api/v1/sessions/oauth_login";
NSString * const kSessionLoginURL                           = @"api/v1/sessions/login";
NSString * const kSessionSignupURL                          = @"api/v1/sessions/signup";

#pragma mark - 直播节目相关

NSString * const kProgrammeGuideURL                         = @"api/v1/programs";
NSString * const kProgrammeDetailURL                        = @"api/v1/programs/";
NSString * const kProgrammeApplyOrderURL                    = @"api/v1/program_checks";
NSString * const kProgrammeOfMyBookedURL                    = @"api/v1/programs/my_booked_programs";
NSString * const kProgrammeCancelURL                        = @"api/v1/programs/cancel";
NSString * const kProgrammeSubscribeOtherURL                = @"api/v1/program_subscribes";
NSString * const kProgrammeLikeURL                          = @"api/v1/praises";
NSString * const kProgrammeCommentURL                       = @"api/v1/comments";

#pragma mark - 直播相关

NSString * const kLivePlayURL                               = @"api/v1/programs/play_url";
NSString * const kLivePushStreamingURL                      = @"api/v1/programs/publish_url";
NSString * const kLiveResultURL                             = @"api/v1/programs/program_result";
NSString * const kLiveInformURL                             = @"api/v1/reports";
NSString * const kLiveUserOnlineURL                         = @"api/v1/users/online";

#pragma mark - 充值

NSString * const kProductIDsURL                             = @"api/v1/token_coins";
NSString * const kIAPurchaseURL                             = @"api/v1/orders";
NSString * const kVerifyPurchaseReceiptURL                  = @"api/v1/orders/verify";

#pragma mark - 礼物

NSString * const kGiftListURL                               = @"api/v1/gifts";
NSString * const KGiftSendURL                               = @"api/v1/user_gifts";

#pragma mark - 个人中心

NSString * const kUserInfoURL                               = @"api/v1/users/";
NSString * const kUserMoreRecordsURL                        = @"api/v1/users/operated_programs/";
NSString * const kUserFocusingURL                           = @"api/v1/user_relations";
NSString * const kUserUnFocusingURL                         = @"api/v1/user_relations/remove";
NSString * const kUserMyPrograms                            = @"api/v1/programs/my_programs";
NSString * const kUserMySubscribes                          = @"api/v1/program_subscribes";
NSString * const kUserMyIncome                              = @"api/v1/users/income";

#pragma mark - WebView

NSString * const kTipURL                                    = @"/mobile/tips";

#pragma mark - Other

NSString * const kVersionUpdateURL                          = @"api/v1/app_versions";
NSString * const kRandomStringURL                           = @"api/v1/users/random_string";
NSString * const kErrorInfoURL                              = @"api/v1/error_infos";

