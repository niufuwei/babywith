//
//  DeviceConnectManager.h
//  AiJiaJia
//
//  Created by wangminhong on 13-4-11.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Configuration.h"

@interface DeviceConnectManager : NSObject{
    NSMutableArray *DeviceList;       //设备列表
    NSCondition *DeviceCondition;
    int IsConnect;
}

-(void)initlize;                                           //初始化通道
//-(void)unInitlize;                                         //关闭通道
-(void)putDeviceInfo:(NSArray *)DeviceInfoList;     //添加设备列表信息
-(NSMutableArray *)getDeviceInfoList;                      //获得设备列表
-(NSDictionary *)getDeviceInfo:(NSString *)deviceUID;      //获得设备信息
-(NSMutableDictionary *)getDeviceInfoAtRow:(NSInteger)row;        //获得第row条设备信息
-(NSDictionary *)getFirstDeviceInfo;                       //获取最早的设备信息
-(NSInteger )getDeviceCount;
-(void)removeDeviceInfo:(NSString *)deviceUID;
-(void)removeDeviceList;
-(void)updateDeviceAuthorityInfo:(NSString *)deviceUID Authority:(NSString *)authority;
-(void)renameDevice:(NSString *)deviceUID Name:(NSString *)name;
-(void)modifyDevicePassword:(NSString *)deviceUID Password:(NSString *)password;
-(void)modifyDeviceAuthSwitch:(NSString *)deviceUID AuthSwitch:(NSString *)authSwitch; //修改看护器开放权限
//-(void)connectUID;                                         //连接摄像头
//-(void)closeConnectUID;                                    //关闭所有连接
//-(void)unConnectDevice:(NSString *)UID;                    //中断连接
@end
