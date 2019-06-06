//
//  LGAPIErrorCode.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/6.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#ifndef LGAPIErrorCode_h
#define LGAPIErrorCode_h

typedef NS_ENUM(NSInteger, LGErrorCode){
    LGErrorCode_UnDefine                                    = -1,
    LGErrorCode_Success                                     = 200,
    LGErrorCode_ParamVerify                                 = 1001,
    LGErrorCode_ParamFormatVerify                           = 1002,
    LGErrorCode_ParamLength                                 = 1003,
    LGErrorCode_AccountNameExist                            = 1004,
    LGErrorCode_MobileExist                                 = 1005,
    LGErrorCode_VerifyCode                                  = 1006,
    LGErrorCode_Register                                    = 1007,
    LGErrorCode_VerifyCodeExist                             = 1008,
    LGErrorCode_VerifyFetch                                 = 1009,
};

#endif /* LGAPIErrorCode_h */
