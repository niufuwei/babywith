//
//  WebInfoManager.m
//  AiJiaJia
//
//  Created by wangminhong on 13-5-7.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "WebInfoManager.h"
#include "Configuration.h"
#import "MainAppDelegate.h"
#import "DeviceConnectManager.h"
#import <AdSupport/ASIdentifierManager.h>

@implementation WebInfoManager

-(void)SetPersonalInfo:(NSDictionary *)dictionary{
    
    [appDelegate.appDefault setObject:[dictionary objectForKey:@"id_member"] forKey:@"Member_id_self"];
    [appDelegate.appDefault setObject:[dictionary objectForKey:@"realname"] forKey:@"Realname_self"];
    [appDelegate.appDefault setObject:[dictionary objectForKey:@"appel"] forKey:@"Appel_self"];
    [appDelegate.appDefault setObject:[dictionary objectForKey:@"phone_bind"] forKey:@"Phone_bind_self"];
    [appDelegate.appDefault setObject:[dictionary objectForKey:@"mac_bind"] forKey:@"Mac_bind_self"];
}

-(void)ClearInfo{
   
    
    //个人信息
    [appDelegate.appDefault setObject:@"" forKey:@"Member_id_self"];
    [appDelegate.appDefault setObject:@"" forKey:@"Realname_self"];
    [appDelegate.appDefault setObject:@"" forKey:@"Appel_self"];
    [appDelegate.appDefault setObject:@"" forKey:@"Phone_bind_self"];
        [appDelegate.appDefault setObject:@"" forKey:@"Mac_bind_self"];
    
   
    
    //设备信息
    [appDelegate.deviceConnectManager removeDeviceList];
}

-(void)SetPartnerInfo:(NSDictionary *)dictionary{
    
    NSLog(@"SetPartnerInfo = [%@]", dictionary);
    [appDelegate.appDefault setObject:[dictionary objectForKey:@"id_member"] forKey:@"Member_id_partner"];
    [appDelegate.appDefault setObject:[dictionary objectForKey:@"realname"] forKey:@"Realname_partner"];
    [appDelegate.appDefault setObject:[dictionary objectForKey:@"appellation"] forKey:@"Appel_partner"];
    
}



-(BOOL)UserGetGateAddressUsingAppVersion:(NSString *)aAppVersion ClientType:(NSString *)aClientType TestFlag:(NSString *)aTestFlag{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:babywith_gate_address];
    
    NSDictionary *response = [binding UserGetGateAddressUsingAppVersion:aAppVersion ClientType:aClientType TestFlag:aTestFlag];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        [appDelegate.appDefault setObject:[[response objectForKey:@"value"] objectForKey:@"url"] forKey:@"BabyWith_address"];
        [appDelegate.appDefault setObject:[NSString stringWithFormat:@"%@/api", [[response objectForKey:@"value"] objectForKey:@"url"]] forKey:@"BabyWith_address_api"];
        return YES;
    }else{
        NSLog(@"UserLogin Error");
        return NO;
    }
}

-(int)UserGetServerVersionUsingAppVersion:(NSString *)aAppVersion ClientType:(NSString *)aClientType{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/service/get_api_version",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    
    NSDictionary *response = [binding UserGetServerVersionUsingClientType:aClientType AppVersion:aAppVersion];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        return [[[response objectForKey:@"value"] objectForKey:@"upgrade"] integerValue];
    }else{
        NSLog(@"UserLogin Error");
        return -1;
    }
}


-(BOOL)UserRegisterUsingUser:(NSString *)aUser Vesting:(NSString *)aVesting RegistType:(NSString *)aRegistType{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/user/Regist1",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    
    NSDictionary *response = [binding UserRegisterUsingUser:aUser Vesting:aVesting RegistType:aRegistType];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        [appDelegate.appDefault setObject:[[response objectForKey:@"value"] objectForKey:@"auth"] forKey:@"Phone_checkcode"];
        return YES;
    }else{
        NSLog(@"UserLogin Error");
        return NO;
    }
}

-(BOOL)UserRegisterUsingUser:(NSString *)aUser Vesting:(NSString *)aVesting RefistType:(NSString *)aRefistType Password:(NSString *)aPassword Mac:(NSString *)aMac{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/user/Regist1", [appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    
    NSDictionary *response = [binding UserRegisterUsingUser:aUser Vesting:aVesting refist_type:aRefistType Password:aPassword Mac:aMac];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        
        //类似登陆成功后的赋值
        [appDelegate.appDefault setObject:aUser forKey:@"Username"];
        [appDelegate.appDefault setObject:aPassword forKey:@"Password"];
        
//        //对应数据清理
//        [appDelegate.appDefault setObject:@"" forKey:@"Phone_checkcode"];
        
        return YES;
    }else{
        
        NSLog(@"UserRegisterNext Error");
        return NO;
    }
}


-(BOOL)UserLoginUsingUsername:(NSString *)aUsername Password:(NSString *)aPassword Version:(NSString *)aVersion Vesting:(NSString *)aVesting ClientType:(NSString *)aClientType DeviceToken:(NSString *)aDeviceToken{
    
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/user/DoLogin",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    
    NSDictionary *response = [binding UserLoginUsingUsername:aUsername Password:aPassword Version:aVersion Vesting:aVesting ClientType:aClientType DeviceToken:aDeviceToken];
    NSLog(@"%@",response);
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"])
    {
        
        [self ClearInfo];
        
        [appDelegate.appDefault setObject:aUsername forKey:@"Username"];
        [appDelegate.appDefault setObject:aPassword forKey:@"Password"];
        [appDelegate.appDefault setObject:[[response objectForKey:@"value"] objectForKey:@"token"] forKey:@"Token"];
        
       
        
        [appDelegate.deviceConnectManager removeDeviceList];
        [appDelegate.deviceConnectManager putDeviceInfo:[[response objectForKey:@"value"] objectForKey:@"device_info"]];
        
        [appDelegate.appDefault setObject:@"" forKey:@"Phone_bind_new"];
        [appDelegate.appDefault setObject:@"" forKey:@"Phone_checkcode"];
        [appDelegate.appDefault setInteger:0 forKey:@"Relative_get_flag"];
        [appDelegate.appDefault setObject:@"" forKey:@"Last_device_id"];
        [appDelegate.appDefault setObject:nil forKey:@"Device_selected"];
        
        //设置MAC合法标志
        if ([appDelegate.appDefault objectForKey:@"Mac_bind_self"] != nil && [[appDelegate.appDefault objectForKey:@"Mac_bind_self"] length] !=0)
        {
            
            NSLog(@"adver =[%@]",[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]);
            
            //修正IOS7 获取到的MAC默认地址
            if ([[appDelegate.appDefault objectForKey:@"Mac_bind_self"] caseInsensitiveCompare:@"02:00:00:00:00:00"] == NSOrderedSame)
            {
                
                //更新MAC地址
                BOOL result = [appDelegate.webInfoManger UserBindMacUsingToken:[appDelegate.appDefault objectForKey:@"Token"] Mac:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] AuthCode:@"-1"];
                
                if (result)
                {
                    [appDelegate.appDefault setObject:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] forKey:@"Mac_self"];
                }
                
                [appDelegate.appDefault setInteger:1 forKey:@"Mac_valid_flag"];
                return YES;
            }
            
            
            if ([[appDelegate.appDefault objectForKey:@"Mac_bind_self"] isEqualToString:[appDelegate.appDefault objectForKey:@"Mac_self"]])
            {
                [appDelegate.appDefault setInteger:1 forKey:@"Mac_valid_flag"];
            }else{
                if ([[appDelegate.appDefault objectForKey:@"Mac_bind_self"] isEqualToString:@"-1"]){
                    [appDelegate.appDefault setInteger:1 forKey:@"Mac_valid_flag"];
                }else{
                    [appDelegate.appDefault setInteger:0 forKey:@"Mac_valid_flag"];
                }
            }
        }else{
            [appDelegate.appDefault setInteger:0 forKey:@"Mac_valid_flag"];
        }
        
        return YES;
    }
    
    else
    {
        
//        [appDelegate.appDefault setObject:@"" forKey:@"Password"];
//        [appDelegate.appDefault setObject:@"" forKey:@"Token"];
        return NO;
    }
}

-(BOOL)UserLogoutUsingToken:(NSString *)aToken{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/user/LogOut",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    
    [appDelegate.appDefault setObject:nil forKey:@"Device_selected"];
    [binding UserLogoutUsingToken:aToken];
    [binding release];
    
    [self ClearInfo];
    
    return YES;
}

-(BOOL)UserBindMacUsingToken:(NSString *)aToken Mac:(NSString *)aMac AuthCode:(NSString *)aAuthCode{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/user/bind_mac",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    
    NSDictionary *response = [ binding UserBindMacUsingToken:aToken Mac:aMac AuthCode:aAuthCode];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        
        [appDelegate.appDefault setObject:aMac forKey:@"Mac_bind_self"];
        [appDelegate.appDefault setInteger:1 forKey:@"Mac_valid_flag"];
        
        return YES;
        
    }else{
        return NO;
    }
}

//绑定邮箱
-(BOOL)UserBindEmailUsingToken:(NSString *)aToken Email:(NSString *)aEmail{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/user/bind_email1",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    
    NSDictionary *response = [ binding UserBindEmailUsingToken:aToken Email:aEmail];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        
        [appDelegate.appDefault setObject:[[response objectForKey:@"value"] objectForKey:@"auth"] forKey:@"Email_checkcode"];
        [appDelegate.appDefault setObject:aEmail forKey:@"Email_bind_new"];
        
        return YES;
        
    }else{
        return NO;
    }
}

//绑定邮箱第二步
-(BOOL)UserBindEmailUsingToken:(NSString *)aToken Email:(NSString *)aEmail AuthCode:(NSString *)aAuthCode{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/user/bind_email2",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    
    NSDictionary *response = [ binding UserBindEmailUsingToken:aToken Email:aEmail AuthCode:aAuthCode];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        
        [appDelegate.appDefault setObject:aEmail forKey:@"Email_bind_self"];
        
        return YES;
        
    }else{
        return NO;
    }
}







/*获取设备信息*/
-(BOOL)UserGetDeviceInfoUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId{
    
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/device/get_device_info",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [ binding UserGetDeviceInfoUsingToken:aToken DeviceId:aDeviceId];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        [appDelegate.deviceConnectManager putDeviceInfo:(NSArray *)[response objectForKey:@"value"]];
        
        NSLog(@"GET record base info success ");
        return YES;
        
    }else{
        NSLog(@"GET record base info  Error ");
        return NO;
    }

    
}

/*添加设备*/
-(BOOL)UserAddDeviceUsingDeviceId:(NSString *)aDeviceId DeviceName:(NSString *)aDeviceName Token:(NSString *)aToken{
    
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/device/bind_device",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [ binding UserAddDeviceUsingDeviceId:aDeviceId DeviceName:aDeviceName Token:aToken];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        
        //添加设备
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:aDeviceId, @"device_id", aDeviceName, @"name", aDeviceUser, @"user", aDevicePasswd, @"pass", [appDelegate.appDefault objectForKey:@"Memeber_id_self"], @"id_member", nil];
//        NSArray *array = [NSArray arrayWithObject:dic];
        
        NSArray *array = [NSArray arrayWithObject:[response objectForKey:@"value"]];
        [appDelegate.deviceConnectManager putDeviceInfo:array];
        
        NSLog(@"UserAddDeviceUsingToken success ");
        return YES;
        
    }else{
        NSLog(@"UserAddDeviceUsingToken  Error ");
        return NO;
    }
}

/*设备重命名*/
-(BOOL)UserRenameDeviceUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId DeviceName:(NSString *)aDeviceName{
    
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/device/update_name",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [ binding UserRenameDeviceUsingToken:aToken DeviceId:aDeviceId DeviceName:aDeviceName];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        
        //修改设备名称
        [appDelegate.deviceConnectManager renameDevice:aDeviceId Name:aDeviceName];
        [appDelegate.appDefault setObject:[appDelegate.deviceConnectManager getDeviceInfo:aDeviceId] forKey:@"Device_selected"];
        
        NSLog(@"UserRenameDeviceUsingToken success ");
        return YES;
        
    }else{
        NSLog(@"UserRenameDeviceUsingToken  Error ");
        return NO;
    }
}

/*更改设备开放权限*/
-(BOOL)UserModifyDeviceAuthSwitchUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId AuthSwitch:(NSString *)aAuthSwitch{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/device/open_device",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [binding UserModifyDeviceAuthSwitchUsingToken:aToken DeviceId:aDeviceId AuthSwitch:aAuthSwitch];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] caseInsensitiveCompare:@"success"] == NSOrderedSame) {
        //修改设备开放权限
        [appDelegate.deviceConnectManager modifyDeviceAuthSwitch:aDeviceId AuthSwitch:aAuthSwitch];
        [appDelegate.appDefault setObject:[appDelegate.deviceConnectManager getDeviceInfo:aDeviceId] forKey:@"Device_selected"];
        
        NSLog(@"UserModifyDeviceAuthSwitchUsingToken success ");
        return YES;
    }else{
        NSLog(@"UserModifyDeviceAuthSwitchUsingToken  Error ");
        return NO;
    }
}

/*设备解绑*/
-(BOOL)UserUnbindDeviceUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/device/dissolve_device",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [ binding UserUnbindDeviceUsingToken:aToken DeviceId:aDeviceId];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        
        //删除设备
        [appDelegate.deviceConnectManager removeDeviceInfo:aDeviceId];
//        [appDelegate.appDefault setObject:nil forKey:@"Device_selected"];
        
        NSLog(@"UserUnbindDeviceUsingToken success ");
        return YES;
        
    }else{
        NSLog(@"UserUnbindDeviceUsingToken  Error ");
        return NO;
    }
}

/*设备密码修改*/
-(BOOL)UserModifyDevicePasswordUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId DeviceUser:(NSString *)aDeviceUser DevicePasswd:(NSString *)aDevicePasswd{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/device/update_device_pass",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [binding UserModifyDevicePasswordUsingToken:aToken DeviceId:aDeviceId DeviceUser:aDeviceUser DevicePasswd:aDevicePasswd];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        
        NSLog(@"UserModifyDevicePasswordUsingToken success ");
        return YES;
        
    }else{
        NSLog(@"UserModifyDevicePasswordUsingToken Error ");
        return NO;
    }
}

-(BOOL)UserUpdateDeviceUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId Authority:(NSString *)aAuthority{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/device/update_device",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [ binding UserUpdateDeviceInfoUsingToken:aToken DeviceId:aDeviceId Authority:aAuthority];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        
        //修改设备信息
        [appDelegate.deviceConnectManager updateDeviceAuthorityInfo:aDeviceId Authority:aAuthority];
        
        NSLog(@"UserUpdateDeviceUsingToken success");
        return YES;
    }else{
        NSLog(@"UserUnbindDeviceUsingToken  Error ");
        return NO;
    }
}

/*获取邮箱验证码*/
-(BOOL)UserGetEmailCodeUsingToken:(NSString *)aToken{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/user/get_email_auth",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [binding UserGetEmailCodeUsingToken:aToken];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        [appDelegate.appDefault setObject:[[response objectForKey:@"value"] objectForKey:@"auth"] forKey:@"Email_checkcode"];
        return YES;
        
    }else{
        return NO;
    }
}


/*忘记密码*/
-(BOOL)UserForgetPasswordUsingPhone:(NSString *)aPhone Vesting:(NSString *)aVesting
{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/user/forgot_pass1",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [binding UserForgotPasswordUsingPhone:aPhone Vesting:aVesting];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        [appDelegate.appDefault setObject:[[response objectForKey:@"value"] objectForKey:@"auth"] forKey:@"Phone_checkcode"];
        return YES;
        
    }else{
        return NO;
    }
}

/*通过电话验证码重置密码*/
-(BOOL)UserResetPasswordByPhoneUsingUsername:(NSString *)aUsername Authcode:(NSString *)aAuthCode Password:(NSString *)aPassword{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/user/forgot_pass2",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [ binding UserResetPasswordByPhoneUsingUsername:aUsername Authcode:aAuthCode Password:aPassword];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"])
    {
        
        [appDelegate.appDefault setObject:@"" forKey:@"Username"];
        [appDelegate.appDefault setObject:@"" forKey:@"Password"];
        return YES;
        
    }else{
        return NO;
    }
}

/*修改密码*/
-(BOOL)UserModifyPasswordUsingToken:(NSString *)aToken Password:(NSString *)aPassword NewPassword:(NSString *)aNewPassword{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/user/update_pass",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [ binding UserModifyPasswordUsingToken:aToken Password:aPassword NewPassword:aNewPassword];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"]) {
        [appDelegate.appDefault setObject:aNewPassword forKey:@"Password"];
        
        return YES;
        
    }else{
        return NO;
    }
}


-(NSDictionary *)UserGetMessageUsingToken:(NSString *)aToken{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/message/get_messages",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [ binding UserGetMessageUsingToken:aToken];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"])
    {
        
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [response objectForKey:@"value"]];
        return dic;
        
    }
    else
    {
        return nil;
    }
}

//修改昵称
-(BOOL)UserModifyAppelUsingAppel:(NSString *)aAppel Toekn:(NSString *)aToken
{

    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/user/update_user_info",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [binding UserModifyAppelUsingAppel:aAppel Toekn:aToken];
    [binding release];

    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"])
    {
        
        return YES;
    }
    
    else
   {
    return NO;

    }


}

//分享设备
-(BOOL)UserShareDeviceUsingDeviceID:(NSString *)aDeviceID Phone:(NSString *)aPhone Token:(NSString *)aToken PhoneType:(NSString *)aPhoneType
{

    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/device/get_device_info",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [binding UserShareDeviceUsingDeviceID:aDeviceID Phone:aPhone Token:aToken PhoneType:aPhoneType];
    NSLog(@"分享的返回数%@",response);
    [binding release];
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"])
    {
        return YES;
    }
    else
    {
        return NO;
    }




}

//同意分享设备
-(BOOL)UserAgreeAddDeviceUsingIDMer:(NSString *)aIDMer Toekn:(NSString *)aToken
{
    WebInfoBinding *binding = [[WebInfoBinding alloc] initWithAddress:[NSString stringWithFormat:@"%@/family/add_baby",[appDelegate.appDefault objectForKey:@"BabyWith_address_api"]]];
    NSDictionary *response = [binding UserAgreeAddDeviceUsingIDMer:aIDMer Toekn:aToken];
    [binding release];
    
    if (response && [[response objectForKey:@"result"] isEqualToString:@"success"])
    {
        [appDelegate.deviceConnectManager putDeviceInfo:[response objectForKey:@"value"]] ;
        return YES;
    }
    else
    {
        return NO;
    }
}

@end


