//
//  WebInfoService.h
//  AiJiaJia
//
//  Created by wangminhong on 13-5-7.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebInfoBinding : NSObject{
    NSURL *_address;
    NSTimeInterval _defaultTimeout;
    NSMutableArray *_cookies;
    NSString *_username;
    NSString *_password;
    BOOL synchOperComplete;
}

@property (retain) NSURL *address;
@property (assign) NSTimeInterval defaultTimeout;
@property (nonatomic, retain) NSMutableArray *cookies;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

-(id) initWithAddress:(NSString *)address;
-(id) initWithAddress:(NSString *)address Timeout:(NSTimeInterval )timeout;
-(NSDictionary *)UserGetGateAddressUsingAppVersion:(NSString *)aAppVersion ClientType:(NSString *)aClientType  TestFlag:(NSString *)aTestFlag;
-(NSDictionary *)UserGetServerVersionUsingClientType:(NSString *)aClientType AppVersion:(NSString *)aAppVersion;
-(NSDictionary *)UserRegisterUsingUser:(NSString *)aUser Vesting:(NSString *)aVesting RegistType:(NSString *)aRegistType;
-(NSDictionary *)UserRegisterUsingUser:(NSString *)aUser Vesting:(NSString *)aVesting refist_type:(NSString *)aRefist_type Password:(NSString *)aPassword Mac:(NSString *)aMac;
-(NSDictionary *)UserLoginUsingUsername:(NSString *)aUsername Password:(NSString *)aPassword Version:(NSString *)aVersion Vesting:(NSString *)aVesting ClientType:(NSString *)aClientType  DeviceToken:(NSString *)aDeviceToken;
-(NSDictionary *)UserLogoutUsingToken:(NSString *)aToken;
-(NSDictionary *)UserBindMacUsingToken:(NSString *)aToken Mac:(NSString *)aMac AuthCode:(NSString *)aAuthCode;
-(NSDictionary *)UserBindEmailUsingToken:(NSString *)aToken Email:(NSString *)aEmail;
-(NSDictionary *)UserBindEmailUsingToken:(NSString *)aToken Email:(NSString *)aEmail AuthCode:(NSString *)aAuthCode;
-(NSDictionary *)UserGetDeviceInfoUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId;
-(NSDictionary *)UserAddDeviceUsingDeviceId:(NSString *)aDeviceId DeviceName:(NSString *)aDeviceName Token:(NSString *)aToken;
-(NSDictionary *)UserRenameDeviceUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId DeviceName:(NSString *)aDeviceName;
-(NSDictionary *)UserModifyDeviceAuthSwitchUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId AuthSwitch:(NSString *)aAuthSwitch;
-(NSDictionary *)UserUnbindDeviceUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId;
-(NSDictionary *)UserUpdateDeviceInfoUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId Authority:(NSString *)aAuthority;
-(NSDictionary *)UserModifyDevicePasswordUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId DeviceUser:(NSString *)aDeviceUser DevicePasswd:(NSString *)aDevicePasswd;
-(NSDictionary *)UserGetEmailCodeUsingToken:(NSString *)aToken;
-(NSDictionary *)UserForgotPasswordUsingPhone:(NSString *)aPhone Vesting:(NSString *)aVesting;
-(NSDictionary *)UserResetPasswordByPhoneUsingUsername:(NSString *)aUsername Authcode:(NSString *)aAuthCode Password:(NSString *)aPassword;
-(NSDictionary *)UserModifyPasswordUsingToken:(NSString *)aToken Password:(NSString *)aPassword NewPassword:(NSString *)aNewPassword;
-(NSDictionary *)UserGetMessageUsingToken:(NSString *)aToken;


//修改昵称
-(NSDictionary *)UserModifyAppelUsingAppel:(NSString *)aAppel Toekn:(NSString *)aToken;
//分享设备
-(NSDictionary *)UserShareDeviceUsingDeviceID:(NSString *)aDeviceID Phone:(NSString *)aPhone Token:(NSString *)aToken PhoneType:(NSString *)aPhoneType;

//同意添加设备
-(NSDictionary *)UserAgreeAddDeviceUsingIDMer:(NSString *)aIDMer Toekn:(NSString *)aToken;

@end

@interface WebInfoBindingOper : NSOperation<NSURLConnectionDataDelegate, NSURLConnectionDelegate>{
    WebInfoBinding *_binding;
    NSDictionary *_responseDic;
    NSMutableData *_responseData;
    NSURLConnection *_urlConnection;
}

@property (retain) WebInfoBinding *binding;
@property (nonatomic, retain) NSDictionary *responseDic;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURLConnection *urlConnection;

-(id)initWithBinding:(WebInfoBinding *)binding;

@end

//获取服务网关地址
@interface WebInfoBinding_GetGateAddress : WebInfoBindingOper{
    NSString *_app_version;
    NSString *_client_type;
    NSString *_test_flag;
}

@property(retain) NSString *app_version;
@property(retain) NSString *client_type;
@property(retain) NSString *test_flag;

-(id)initWithBinding:(WebInfoBinding *)binding AppVersion:(NSString *)aAppVersion ClientType:(NSString *)aClientType TestFlag:(NSString *)aTestFlag;


@end

//获取版本更新信息
@interface WebInfoBinding_GetServerVersion : WebInfoBindingOper{
    NSString *_app_version;
    NSString *_client_type;
}

@property(retain) NSString *app_version;
@property(retain) NSString *client_type;

-(id)initWithBinding:(WebInfoBinding *)binding AppVersion:(NSString *)aAppVersion ClientType:(NSString *)aClientType;

@end


//注册第一步
@interface WebInfoBinding_UserRegister : WebInfoBindingOper{
    NSString *_user;
    NSString *_vesting;
    NSString *_regist_type;
}

@property (retain) NSString *user;
@property (retain) NSString *vesting;
@property (retain) NSString *regist_type;

-(id)initWithBinding:(WebInfoBinding *)binding User:(NSString *)aUser Vesting:(NSString *)aVesting RegistType:(NSString *)aRegistType;

@end

//注册第二步
@interface WebInfoBinding_UserRegisterNext : WebInfoBindingOper{
    NSString *_user;
    NSString *_vesting;
    NSString *_refist_type;
    NSString *_password;
    NSString *_mac;
    
}

@property (retain) NSString *user;
@property (retain) NSString *vesting;
@property (retain) NSString *refist_type;
@property (retain) NSString *password;
@property (retain) NSString *mac;




-(id)initWithBinding:(WebInfoBinding *)binding user:(NSString *)aUser vesting:(NSString *)aVesting refistType:(NSString *)aRefistType password:(NSString *)aPassword mac:(NSString *)aMac;

@end



//登陆
@interface WebInfoBinding_UserLogin : WebInfoBindingOper{
    NSString *_username;
    NSString *_password;
    NSString *_version;
    NSString *_vesting;
    NSString *_client_type;
    NSString *_device_token;
}

@property (retain) NSString *username;
@property (retain) NSString *password;
@property (retain) NSString *version;
@property (retain) NSString *vesting;
@property (retain) NSString *client_type;
@property (retain) NSString *device_token;


-(id)initWithBinding:(WebInfoBinding *)binding Username:(NSString *)aUsername Password:(NSString *)aPassword Version:(NSString *)aVersion Vesting:(NSString *)aVesting ClientType:(NSString *)aClientType DeviceToken:(NSString *)aDeviceToken;

@end

//注销
@interface WebInfoBinding_UserLogout : WebInfoBindingOper{
    NSString *_token;
}

@property (retain) NSString *token;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken;

@end





//更改绑定MAC地址
@interface WebInfoBinding_UpdateMacInfo : WebInfoBindingOper{
    NSString *_token;
}

@property (retain) NSString *token;

-(id)initWithBinding:(WebInfoBinding *)binding token:(NSString *)token;

@end




//绑定MAC
@interface WebInfoBinding_UserBindMac : WebInfoBindingOper{
    NSString *_token;
    NSString *_mac;
    NSString *_auth_code;
}

@property (retain) NSString *token;
@property (retain) NSString *mac;
@property (retain) NSString *auth_code;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken Mac:(NSString *)aMac AuthCode:(NSString *)aAuthCode;

@end

//绑定邮箱第一步 获取验证码
@interface WebInfoBinding_UserBindEmail : WebInfoBindingOper{
    NSString *_token;
    NSString *_email;
}

@property (retain) NSString *token;
@property (retain) NSString *email;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken Email:(NSString *)aEmail;

@end

//绑定邮箱第二步
@interface WebInfoBinding_UserBindEmailNext : WebInfoBindingOper{
    NSString *_token;
    NSString *_email;
    NSString *_auth_code;
}

@property (retain) NSString *token;
@property (retain) NSString *email;
@property (retain) NSString *auth_code;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken Email:(NSString *)aEmail AuthCode:(NSString *)aAuthCode;

@end




//获取设备信息
@interface WebInfoBinding_UserGetDeviceInfo : WebInfoBindingOper{
    NSString *_token;
    NSString *_device_id;
}

@property (retain) NSString *token;
@property (retain) NSString *device_id;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken DeviceId:(NSString *)aDeviceId;

@end

//添加设备
@interface WebInfoBinding_UserAddDevice : WebInfoBindingOper{
    NSString *_token;
    NSString *_deviceID;
    NSString *_deviceName;

}

@property (retain) NSString *token;
@property (retain) NSString *deviceID;
@property (retain) NSString *deviceName;


-(id)initWithBinding:(WebInfoBinding *)binding DeviceId:(NSString *)aDeviceId DeviceName:(NSString *)aDeviceName Token:(NSString *)aToken;

@end

//设备重命名
@interface WebInfoBinding_UserRenameDevice : WebInfoBindingOper{
    NSString *_token;
    NSString *_deviceID;
    NSString *_deviceName;
}

@property (retain) NSString *token;
@property (retain) NSString *deviceID;
@property (retain) NSString *deviceName;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken DeviceId:(NSString *)aDeviceId DeviceName:(NSString *)aDeviceName;

@end

//更改设备开放权限
@interface WebInfoBinding_UserModifyDeviceAuthSwitch : WebInfoBindingOper{
    NSString *_token;
    NSString *_deviceID;
    NSString *_authSwitch;
}


@property (retain) NSString *token;
@property (retain) NSString *deviceID;
@property (retain) NSString *authSwitch;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken DeviceId:(NSString *)aDeviceId AuthSwitch:(NSString *)aAuthSwitch;

@end

//设备解绑
@interface WebInfoBinding_UserUnbindDevice : WebInfoBindingOper{
    NSString *_token;
    NSString *_deviceID;
}

@property (retain) NSString *token;
@property (retain) NSString *deviceID;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken DeviceId:(NSString *)aDeviceId;

@end


//设备修改权限
@interface WebInfoBinding_UserUpdateDeviceInfo : WebInfoBindingOper{
    NSString *_token;
    NSString *_deviceID;
    NSString *_authority;
}

@property (retain) NSString *token;
@property (retain) NSString *deviceID;
@property (retain) NSString *authority;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken DeviceId:(NSString *)aDeviceId Authority:(NSString *)aAuthority;

@end

//设备密码修改
@interface WebInfoBinding_UserModifyDevicePassword : WebInfoBindingOper{
    NSString *_token;
    NSString *_deviceID;
    NSString *_deviceUser;
    NSString *_devicePasswd;
}

@property (retain) NSString *token;
@property (retain) NSString *deviceID;
@property (retain) NSString *deviceUser;
@property (retain) NSString *devicePasswd;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken DeviceId:(NSString *)aDeviceId DeviceUser:(NSString *)aDeviceUser DevicePasswd:(NSString *)aDevicePasswd;

@end



//获取验证码
@interface WebInfoBinding_UserGetEmailCode: WebInfoBindingOper{
    NSString *_token;
}

@property (retain) NSString *token;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken;

@end



//忘记密码
@interface WebInfoBinding_UserForgetPassword: WebInfoBindingOper{
    NSString *_phoneNumber;
    NSString *_vesting;
}

@property (retain) NSString *phoneNumber;
@property (retain) NSString *vesting;

-(id)initWithBinding:(WebInfoBinding *)binding PhoneNumber:(NSString *)aPhoneNumber Vesting:(NSString *)aVesting;

@end

//忘记密码 验证验证码and 重置密码
@interface WebInfoBinding_UserResetPasswordByPhoneNumber: WebInfoBindingOper{
    NSString *_username;
    NSString *_authCode;
    NSString *_password;
}

@property (retain) NSString *username;
@property (retain) NSString *authCode;
@property (retain) NSString *password;

-(id)initWithBinding:(WebInfoBinding *)binding Username:(NSString *)aUsername AuthCode:(NSString *)aAuthCode Password:(NSString *)aPassword;

@end





//修改密码
@interface WebInfoBinding_UserModifyPassword: WebInfoBindingOper{
    NSString *_token;
    NSString *_oldPassword;
    NSString *_modifyPassword;
}

@property (retain) NSString *token;
@property (retain) NSString *oldPassword;
@property (retain) NSString *modifyPassword;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken Password:(NSString *)aPassword NewPassword:(NSString *)aNewPassword;

@end


//获取消息
@interface WebInfoBinding_UserGetMessage : WebInfoBindingOper{
    NSString *_token;
    
}

@property (retain) NSString *token;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken;

@end




//修改昵称
@interface WebInfoBinding_AppelModify : WebInfoBindingOper
{

    NSString *_appel;
    NSString *_token;

}
@property (retain) NSString *appel;
@property (retain) NSString *token;

-(id)initWithBinding:(WebInfoBinding *)binding Appel:(NSString *)aAppel Token:(NSString *)aToken;

@end


//分享设备
@interface WebInfoBinding_ShareDevice : WebInfoBindingOper
{

    NSString *_device_id;
    NSString *_phone;
    NSString *_token;
    NSString *_phoneType;


}
@property (retain) NSString *device_id;
@property (retain) NSString *phone;
@property (retain) NSString *token;
@property (retain) NSString *phoneType;
-(id)initWithBinding:(WebInfoBinding *)binding DeviceId:(NSString *)aDeviceId Phone:(NSString *)aPhone token:(NSString *)aToken PhoneType:(NSString *)aPhoneType;
@end


//同意添加设备
@interface WebInfoBinding_AgreeAdd : WebInfoBindingOper
{

    NSString *_id_mer;
    NSString *_token;

}
@property (retain) NSString * id_mer;
@property (retain) NSString *token;
-(id)initWithBinding:(WebInfoBinding *)binding IDMer:(NSString *)aIDMer Toekn:(NSString *)aToken;

@end







