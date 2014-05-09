//
//  BabyWithCameraManagement.m
//  BabyWith
//
//  Created by wangminhong on 13-8-27.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#include "BabyWithCameraManagement.h"

BabyWithCameraManagement::BabyWithCameraManagement(){
    
}

BabyWithCameraManagement::~BabyWithCameraManagement(){
    
}

int BabyWithCameraManagement::CheckOnline(const char *szDID){
    [m_Lock lock];
    int i;
    for (i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        
        NSLog(@"bValid= [%d] [%s]", m_PPPPChannel[i].bValid, m_PPPPChannel[i].szDID);
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID, szDID)==0) {
            NSLog(@"m_PPPPChannel checkOnline");
            m_PPPPChannel[i].pPPPPChannel->CheckOnline();
            [m_Lock unlock];
            return 1;
        }
    }
    
    [m_Lock unlock];
    
    return  0;
}

int BabyWithCameraManagement::CheckOnlineReturn(const char *szDID){

    int i;
    for (i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        
        NSLog(@"bValid return = [%d] [%s] [%d]", m_PPPPChannel[i].bValid, m_PPPPChannel[i].szDID,strcmp(m_PPPPChannel[i].szDID, szDID));
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID, szDID)==0) {
            NSLog(@"m_PPPPChannel checkOnline");
            return m_PPPPChannel[i].pPPPPChannel->CheckOnlineReturn();
        }
    }
    
    return  -1;
}

int BabyWithCameraManagement::SetPlayViewParamNotifyDelegate(const char *szDID, id<ParamNotifyProtocol> delegate){
    [m_Lock lock];
    int i;
    for (i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID, szDID)==0) {
            m_PPPPChannel[i].pPPPPChannel->SetPlayViewParamNotifyDelegate(delegate);
            [m_Lock unlock];
            return 1;
        }
    }
    [m_Lock unlock];
    return  0;
}

int BabyWithCameraManagement::CheckUser(const char *szDID, const char *user, const char *passwd){
    [m_Lock lock];
    int i;
    for (i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID, szDID)==0) {
            m_PPPPChannel[i].pPPPPChannel->CheckUser(user, passwd);
            [m_Lock unlock];
            return 1;
        }
    }
    [m_Lock unlock];
    return  0;
}

int BabyWithCameraManagement::RebootDevice(const char *szDID, const char *user, const char *passwd){
    [m_Lock lock];
    int i;
    for (i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID, szDID)==0) {
            m_PPPPChannel[i].pPPPPChannel->RebootDevice(user, passwd);
            [m_Lock unlock];
            return 1;
        }
    }
    [m_Lock unlock];
    return  0;
}

int BabyWithCameraManagement::SetUserPwdForOther(const char *szDID, const char *user, const char *passwd){
    [m_Lock lock];
    int i;
    for (i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID, szDID)==0) {
            m_PPPPChannel[i].pPPPPChannel->SetUserPwdForOther(user, passwd);
            [m_Lock unlock];
            return 1;
        }
    }
    [m_Lock unlock];
    return  0;
}

int BabyWithCameraManagement::SetUserAndPwd(const char *szDID, const char *user, const char *passwd){
    [m_Lock lock];
    int i;
    for (i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID, szDID)==0) {
            m_PPPPChannel[i].pPPPPChannel->SetUserAndPwd(user, passwd);
            [m_Lock unlock];
            return 1;
        }
    }
    [m_Lock unlock];
    return  0;
}


int BabyWithCameraManagement::SetOnlineFlag(const char *szDID ,int flag){
    [m_Lock lock];
    int i;
    for (i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID, szDID)==0) {
            m_PPPPChannel[i].pPPPPChannel->SetOnlineFlag(flag);
            [m_Lock unlock];
            return 0;
        }
    }
    [m_Lock unlock];
    return  -1;
}

int BabyWithCameraManagement::SetWifiParamGettingDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetWifiParamsGettingDelegate(delegate);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}

//int BabyWithCameraManagement::CameraControl(const char *szDID, int param, int value){
//    [m_Lock lock];
//    int i;
//    for (i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
//        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID, szDID)==0) {
//            m_PPPPChannel[i].pPPPPChannel->CameraControl(param, value);
//            [m_Lock unlock];
//            return 1;
//        }
//    }
//    [m_Lock unlock];
//    return  0;
//}

int BabyWithCameraManagement::ChangeStatusDelegate(const char * szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->m_PPPPStatusDelegate = delegate;
            [m_Lock unlock];
            return 1;
        }
    }
    
    [m_Lock unlock];
    
    return 0;
}

