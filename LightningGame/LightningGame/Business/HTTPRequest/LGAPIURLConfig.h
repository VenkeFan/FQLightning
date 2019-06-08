//
//  LGAPIURLConfig.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/6.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#ifndef LGAPIURLConfig_h
#define LGAPIURLConfig_h

#ifndef LG_TEST
#define LG_TEST    1
#endif

#ifdef LG_TEST
#define kBasicURLDefine                 @"http://192.168.1.116:"
#else
#define kBasicURLDefine                 @"http://192.168.1.116:"
#endif

#define kBasicURL                       kBasicURLDefine
#define kLGImageHost                    @"https://www.nmgdjkj.com/"

#pragma mark - 帐号相关

#define kAPIVerifyCodeURL               @"9001/register/sms"
#define kAPISignUpURL                   @"9001/register/submit"
#define kAPIForgetPwdURL                @"9001/register/forget"
#define kAPISignInURL                   @"9002/login"

#endif /* LGAPIURLConfig_h */
