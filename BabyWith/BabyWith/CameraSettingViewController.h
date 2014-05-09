//
//  CameraSettingViewController.h
//  AiJiaJia
//
//  Created by wangminhong on 13-4-16.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParamNotifyProtocol.h"
#include "PPPP_API.h"
#include "PPPPChannel.h"
#include "PPPPDefine.h"
#include "cmdhead.h"
#import "BaseViewController.h"
@class WifiListViewController;
@class CameraParamSettingViewController;
@class CameraSetNameViewController;
@class CameraSetWifiViewController;

@interface CameraSettingViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate,WifiParamsProtocol>{
    UITableView *_cameraTableView;
    WifiListViewController *_wifiListViewController;
    NSMutableDictionary *_deviceDictionary;
    CameraParamSettingViewController *_cameraParamSettingViewController;
    CameraSetWifiViewController *_cameraSetWifiViewController;
    CameraSetNameViewController * _cameraSetNameViewController;
    int _passwordFlag;//是否使用初始密码连接过 0：没有  1：有
    NSString *_ssidStr;
}

-(void)reloadTableView;
-(void)ChangeQuality:(int)quality;
-(void)RebootDevice;
-(void)CameraIsValid;

@end
