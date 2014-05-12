//
//  BabyWithCameraManagement.h
//  BabyWith
//
//  Created by wangminhong on 13-8-27.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

//#import <Foundation/Foundation.h>

//@interface BabyWithCameraManagement : NSObject
//
//@end

#ifndef _BABYWITH_CAMERA_MANAGEMENT_H_
#define _BABYWITH_CAMERA_MANAGEMENT_H_

#import <Foundation/Foundation.h>
//#import "PPPPChannelManagement.h"
#include "PPPPChannelManagement.h"

class BabyWithCameraManagement: public CPPPPChannelManagement{

public:
    BabyWithCameraManagement();
    ~BabyWithCameraManagement();
    int CheckOnline(const char *szDID);
    int CheckOnlineReturn(const char *szDID);
    int SetPlayViewParamNotifyDelegate(const char *szDID, id<ParamNotifyProtocol> delegate); 
    int CheckUser(const char *szDID, const char *user, const char *passwd); 
    int RebootDevice(const char *szDID, const char *user, const char *passwd); 
    int SetUserPwdForOther(const char *szDID, const char *user, const char *passwd);
    int SetUserAndPwd(const char *szDID, const char *user, const char *passwd);
    int SetOnlineFlag(const char *szDID ,int flag);
    int SetWifiParamGettingDelegate(char *szDID, id delegate);
    int ChangeStatusDelegate(const char * szDID, id delegate);
};

#endif


