//
//  WebInfoManager.h
//  AiJiaJia
//
//  Created by wangminhong on 13-5-7.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebInfoBinding.h"
#import "Configuration.h"

//#define address @"http://192.168.1.88:8080/aiJIaJIaWebservice/api"
//#define address @"http://121.199.57.140:8080/babywithService_test/api"
//#define babywith_address @"http://121.199.57.140:8080/aiJIaJIaWebservice/api"

@interface WebInfoManager : NSObject

//    dispatch_queue_t _webInfoQueue;
//}
//
//@property(nonatomic) dispatch_queue_t webInfoQueue;

/*获取网关地址*/
-(BOOL)UserGetGateAddressUsingAppVersion:(NSString *)aAppVersion ClientType:(NSString *)aClientType TestFlag:(NSString *)aTestFlag;

/*获取服务器版本信息*/
-(int)UserGetServerVersionUsingAppVersion:(NSString *)aAppVersion ClientType:(NSString *)aClientType;

/*注册*/
-(BOOL)UserRegisterUsingUser:(NSString *)aUser Vesting:(NSString *)aVesting RegistType:(NSString *)aRegistType;

/*注册第二步*/
-(BOOL)UserRegisterUsingUser:(NSString *)aUser Vesting:(NSString *)aVesting RefistType:(NSString *)aRefistType Password:(NSString *)aPassword Mac:(NSString *)aMac  ;
/*登陆*/
-(BOOL)UserLoginUsingUsername:(NSString *)aUsername Password:(NSString *)aPassword Version:(NSString *)aVersion Vesting:(NSString *)aVesting ClientType:(NSString *)aClientType DeviceToken:(NSString *)aDeviceToken;

/*注销*/
-(BOOL)UserLogoutUsingToken:(NSString *)aToken;


/*绑定MAC*/
-(BOOL)UserBindMacUsingToken:(NSString *)aToken Mac:(NSString *)aMac AuthCode:(NSString *)aAuthCode;

/*绑定邮箱*/
-(BOOL)UserBindEmailUsingToken:(NSString *)aToken Email:(NSString *)aEmail;

/*绑定邮箱第二步*/
-(BOOL)UserBindEmailUsingToken:(NSString *)aToken Email:(NSString *)aEmail AuthCode:(NSString *)aAuthCode;

/*获取设备信息*/
-(BOOL)UserGetDeviceInfoUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId;

/*添加设备*/
-(BOOL)UserAddDeviceUsingDeviceId:(NSString *)aDeviceId DeviceName:(NSString *)aDeviceName Token:(NSString *)aToken;

/*设备重命名*/
-(BOOL)UserRenameDeviceUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId DeviceName:(NSString *)aDeviceName;

/*更改设备开放权限*/
-(BOOL)UserModifyDeviceAuthSwitchUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId AuthSwitch:(NSString *)aAuthSwitch;

/*设备解绑*/
-(BOOL)UserUnbindDeviceUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId;

/*设备密码修改*/
-(BOOL)UserModifyDevicePasswordUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId DeviceUser:(NSString *)aDeviceUser DevicePasswd:(NSString *)aDevicePasswd;

/*更改设备权限*/
-(BOOL)UserUpdateDeviceUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId Authority:(NSString *)aAuthority;

/*获取邮箱验证码*/
-(BOOL)UserGetEmailCodeUsingToken:(NSString *)aToken;

/*获取邮箱验证码*/
-(BOOL)UserForgetPasswordUsingPhone:(NSString *)aPhone Vesting:(NSString *)aVesting;

/*通过电话号码重置密码*/
-(BOOL)UserResetPasswordByPhoneUsingUsername:(NSString *)aUsername Authcode:(NSString *)aAuthCode Password:(NSString *)aPassword;

/*修改密码*/
-(BOOL)UserModifyPasswordUsingToken:(NSString *)aToken Password:(NSString *)aPassword NewPassword:(NSString *)aNewPassword;

/*获取消息*/
-(NSDictionary *)UserGetMessageUsingToken:(NSString *)aToken;


//修改昵称
-(BOOL)UserModifyAppelUsingAppel:(NSString *)aAppel Toekn:(NSString *)aToken ;

//分享设备
-(BOOL)UserShareDeviceUsingDeviceID:(NSString *)aDeviceID Phone:(NSString *)aPhone Token:(NSString *)aToken PhoneType:(NSString *)aPhoneType;

//同意分享设备
-(BOOL)UserAgreeAddDeviceUsingIDMer:(NSString *)aIDMer Toekn:(NSString *)aToken;


@end
