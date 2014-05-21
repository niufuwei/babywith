//
//  WebInfoService.m
//  AiJiaJia
//
//  Created by wangminhong on 13-5-7.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "WebInfoBinding.h"
#import "Configuration.h"
#import "MainAppDelegate.h"
#import "NSData+Base64.h"
#import "SQLiteManager.h"

@implementation WebInfoBinding

@synthesize address = _address;
@synthesize defaultTimeout = _defaultTimeout;
@synthesize cookies = _cookies;
@synthesize username = _username;
@synthesize password = _password;

-(id)initWithAddress:(NSString *)address{
    
    self = [super init];
    if (self) {
        _address = [[NSURL URLWithString:address] retain];
        self.defaultTimeout = 10;
    }
    
    return self;
}

-(id) initWithAddress:(NSString *)address Timeout:(NSTimeInterval)timeout{
    self = [super init];
    if (self) {
        _address = [NSURL URLWithString:address];
        self.defaultTimeout = timeout;
    }
    
    return self;
}

-(void)dealloc{
    
    [_address release];
    [_cookies release];
    [_username release];
    [_password release];
    
    [super dealloc];
}

-(NSDictionary *)UserGetGateAddressUsingAppVersion:(NSString *)aAppVersion ClientType:(NSString *)aClientType TestFlag:(NSString *)aTestFlag{
    return [self performSynchOperation:(WebInfoBinding_GetGateAddress *)[[[WebInfoBinding_GetGateAddress alloc] initWithBinding:self AppVersion:aAppVersion ClientType:aClientType TestFlag:aTestFlag] autorelease]];
}

-(NSDictionary *)UserGetServerVersionUsingClientType:(NSString *)aClientType AppVersion:(NSString *)aAppVersion{
    return [self performSynchOperation:(WebInfoBinding_GetServerVersion *)[[[WebInfoBinding_GetServerVersion alloc] initWithBinding:self AppVersion:aAppVersion ClientType:aClientType] autorelease]];
}

-(NSDictionary *)UserRegisterUsingUser:(NSString *)aUser Vesting:(NSString *)aVesting RegistType:(NSString *)aRegistType{
    return [self performSynchOperation:(WebInfoBinding_UserRegister *)[[[WebInfoBinding_UserRegister alloc] initWithBinding:self User:aUser Vesting:aVesting RegistType:aRegistType] autorelease]];
}

-(NSDictionary *)UserRegisterUsingUser:(NSString *)aUser Vesting:(NSString *)aVesting refist_type:(NSString *)aRefist_type Password:(NSString *)aPassword Mac:(NSString *)aMac  {
    return [self performSynchOperation:(WebInfoBinding_UserRegisterNext *)[[[WebInfoBinding_UserRegisterNext alloc] initWithBinding:self user:aUser vesting:aVesting refistType:aRefist_type password:aPassword mac:aMac]autorelease]];
}

-(NSDictionary *)UserLoginUsingUsername:(NSString *)aUsername Password:(NSString *)aPassword Version:(NSString *)aVersion Vesting:(NSString *)aVesting ClientType:(NSString *)aClientType DeviceToken:(NSString *)aDeviceToken{
    return [self performSynchOperation:(WebInfoBinding_UserLogin *)[[[WebInfoBinding_UserLogin alloc] initWithBinding:self Username:aUsername Password:aPassword Version:aVersion Vesting:aVesting ClientType:aClientType DeviceToken:aDeviceToken] autorelease]];
}

-(NSDictionary *)UserLogoutUsingToken:(NSString *)aToken{
    return [self performSynchOperation:(WebInfoBinding_UserLogout *)[[[WebInfoBinding_UserLogout alloc] initWithBinding:self Token:aToken] autorelease]];
}






-(NSDictionary *)UserBindMacUsingToken:(NSString *)aToken Mac:(NSString *)aMac AuthCode:(NSString *)aAuthCode{
    return [self performSynchOperation:(WebInfoBinding_UserBindMac *)[[[WebInfoBinding_UserBindMac alloc] initWithBinding:self Token:aToken Mac:aMac AuthCode:aAuthCode] autorelease]];
}

-(NSDictionary *)UserBindEmailUsingToken:(NSString *)aToken Email:(NSString *)aEmail{
    return [self performSynchOperation:(WebInfoBinding_UserBindEmail *)[[[WebInfoBinding_UserBindEmail alloc] initWithBinding:self Token:aToken Email:aEmail] autorelease]];
}

-(NSDictionary *)UserBindEmailUsingToken:(NSString *)aToken Email:(NSString *)aEmail AuthCode:(NSString *)aAuthCode{
    return [self performSynchOperation:(WebInfoBinding_UserBindEmailNext *)[[[WebInfoBinding_UserBindEmailNext alloc] initWithBinding:self Token:aToken Email:aEmail AuthCode:aAuthCode] autorelease]];
}



-(NSDictionary *)UserGetDeviceInfoUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId{
    return [self performSynchOperation:(WebInfoBinding_UserGetDeviceInfo *)[[[WebInfoBinding_UserGetDeviceInfo alloc] initWithBinding:self Token:aToken DeviceId:aDeviceId] autorelease]];
}

-(NSDictionary *)UserAddDeviceUsingDeviceId:(NSString *)aDeviceId DeviceName:(NSString *)aDeviceName Token:(NSString *)aToken{
    return [self performSynchOperation:(WebInfoBinding_UserAddDevice *)[[[WebInfoBinding_UserAddDevice alloc] initWithBinding:self DeviceId:aDeviceId DeviceName:aDeviceName Token:aToken] autorelease]];
}

-(NSDictionary *)UserRenameDeviceUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId DeviceName:(NSString *)aDeviceName{
    return [self performSynchOperation:(WebInfoBinding_UserRenameDevice *)[[[WebInfoBinding_UserRenameDevice alloc] initWithBinding:self Token:aToken DeviceId:aDeviceId DeviceName:aDeviceName] autorelease]];
}

-(NSDictionary *)UserModifyDeviceAuthSwitchUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId AuthSwitch:(NSString *)aAuthSwitch{
    return [self performSynchOperation:(WebInfoBinding_UserModifyDeviceAuthSwitch *)[[[WebInfoBinding_UserModifyDeviceAuthSwitch alloc] initWithBinding:self Token:aToken DeviceId:aDeviceId AuthSwitch:aAuthSwitch] autorelease]];
}

-(NSDictionary *)UserUnbindDeviceUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId{
    return [self performSynchOperation:(WebInfoBinding_UserUnbindDevice *)[[[WebInfoBinding_UserUnbindDevice alloc] initWithBinding:self Token:aToken DeviceId:aDeviceId] autorelease]];
}

-(NSDictionary *)UserUpdateDeviceInfoUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId Authority:(NSString *)aAuthority{
    return [self performSynchOperation:(WebInfoBinding_UserUpdateDeviceInfo *)[[[WebInfoBinding_UserUpdateDeviceInfo alloc] initWithBinding:self Token:aToken DeviceId:aDeviceId Authority:aAuthority] autorelease]];
}

-(NSDictionary *)UserModifyDevicePasswordUsingToken:(NSString *)aToken DeviceId:(NSString *)aDeviceId DeviceUser:(NSString *)aDeviceUser DevicePasswd:(NSString *)aDevicePasswd{
    return [self performSynchOperation:(WebInfoBinding_UserModifyDevicePassword *)[[[WebInfoBinding_UserModifyDevicePassword alloc] initWithBinding:self Token:aToken DeviceId:aDeviceId DeviceUser:aDeviceUser DevicePasswd:aDevicePasswd] autorelease]];
}

-(NSDictionary *)UserGetEmailCodeUsingToken:(NSString *)aToken{
    return [self performSynchOperation:(WebInfoBinding_UserGetEmailCode *)[[[WebInfoBinding_UserGetEmailCode alloc] initWithBinding:self Token:aToken] autorelease]];
}

-(NSDictionary *)UserForgotPasswordUsingPhone:(NSString *)aPhone Vesting:(NSString *)aVesting{
    return [self performSynchOperation:(WebInfoBinding_UserForgetPassword *)[[[WebInfoBinding_UserForgetPassword alloc] initWithBinding:self PhoneNumber:aPhone Vesting:aVesting] autorelease]];
}

-(NSDictionary *)UserResetPasswordByPhoneUsingUsername:(NSString *)aUsername Authcode:(NSString *)aAuthCode Password:(NSString *)aPassword{
    return [self performSynchOperation:(WebInfoBinding_UserResetPasswordByPhoneNumber*)[[[WebInfoBinding_UserResetPasswordByPhoneNumber alloc] initWithBinding:self Username:aUsername AuthCode:aAuthCode Password:aPassword] autorelease]];
}

-(NSDictionary *)UserModifyPasswordUsingToken:(NSString *)aToken Password:(NSString *)aPassword NewPassword:(NSString *)aNewPassword{
    return [self performSynchOperation:(WebInfoBinding_UserModifyPassword *)[[[WebInfoBinding_UserModifyPassword alloc] initWithBinding:self Token:aToken Password:aPassword NewPassword:aNewPassword] autorelease]];
}

-(NSDictionary *)UserGetMessageUsingToken:(NSString *)aToken{
    return [self performSynchOperation:(WebInfoBinding_UserGetMessage *)[[[WebInfoBinding_UserGetMessage alloc] initWithBinding:self Token:aToken] autorelease]];
}


//修改昵称
-(NSDictionary *)UserModifyAppelUsingAppel:(NSString *)aAppel Toekn:(NSString *)aToken
{

    return [self performSynchOperation:(WebInfoBinding_AppelModify *)[[[WebInfoBinding_AppelModify alloc]  initWithBinding:self Appel:aAppel Token:aToken] autorelease]];


}
//分享设备
-(NSDictionary *)UserShareDeviceUsingDeviceID:(NSString *)aDeviceID Phone:(NSString *)aPhone Token:(NSString *)aToken PhoneType:(NSString *)aPhoneType
{

    return [self performSynchOperation:(WebInfoBinding_ShareDevice *)[[[WebInfoBinding_ShareDevice alloc] initWithBinding:self DeviceId:aDeviceID Phone:aPhone token:aToken PhoneType:aPhoneType] autorelease]];



}
//同意分享设备
-(NSDictionary *)UserAgreeAddDeviceUsingIDMer:(NSString *)aIDMer Toekn:(NSString *)aToken
{

    return [self performSynchOperation:(WebInfoBinding_AgreeAdd *)[[[WebInfoBinding_AgreeAdd alloc] initWithBinding:self IDMer:aIDMer Toekn:aToken] autorelease]];



}

-(NSDictionary *)performSynchOperation:(WebInfoBindingOper *)operation
{
    synchOperComplete = NO;
    [operation start];
    
    while (!synchOperComplete)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    if (operation.responseDic == nil || [operation.responseDic objectForKey:@"result"] == nil)
    {
        [appDelegate.appDefault setObject:@"请确认您的网络" forKey:@"Error_message"];
        [appDelegate.appDefault setObject:@"net_error" forKey:@"Error_code"];
    }
    else
    {
        if (![[operation.responseDic objectForKey:@"result"] isEqualToString:@"success"])
        {
            
            if ([[operation.responseDic objectForKey:@"result"] isEqualToString:@"oather_error"])
            {
                [appDelegate.appDefault setObject:[operation.responseDic objectForKey:@"服务器开小差了~"] forKey:@"Error_message"];
            }
            else
            {
                [appDelegate.appDefault setObject:[operation.responseDic objectForKey:@"resultMessage"] forKey:@"Error_message"];
            }
            
            [appDelegate.appDefault setObject:[operation.responseDic objectForKey:@"result"] forKey:@"Error_code"];
        }
    }
    
    return operation.responseDic;
}

- (void) operationCompleted:(WebInfoBindingOper *)operation
{
	synchOperComplete = YES;
}


@end

@implementation WebInfoBindingOper

@synthesize binding = _binding;
@synthesize responseDic = _responseDic;
@synthesize responseData = _responseData;
@synthesize urlConnection = _urlConnection;

-(id)initWithBinding:(WebInfoBinding *)binding{
    
    self = [super init];
    if (self) {
        self.binding = binding;
    }
    return self;
}

-(void)sendHttpPocket:(NSData *) bodyPocket{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: self.binding.address cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:self.binding.defaultTimeout];
    
    
    
    [request setValue:@"wsdl2objc" forHTTPHeaderField:@"User-Agent"];
    //标准的是application/json，也可以写text/json
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%u", [bodyPocket length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:self.binding.address.host forHTTPHeaderField:@"Host"];
    [request setHTTPMethod: @"POST"];
	[request setHTTPBody: bodyPocket];
    
    
    NSLog(@"request = [%@]", request);
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        self.urlConnection = connection;
        [connection release];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)urlResponse
{
    
    NSLog(@"did recieve response");
    
    //重置响应数据
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"data is %@",data);
    NSLog(@"did  recieve data");
    [self.responseData appendData:data];

}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self.binding operationCompleted:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    
    if (_responseData != nil && _binding != nil)
	{
        NSError *error =nil;
        id result =[NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error];
        
        NSLog(@"responseData :%@", result);
        self.responseDic = (NSDictionary *)result;
        NSLog(@"responseData is %@",self.responseData);
        [_binding operationCompleted:self];
	}
}


- (void)dealloc
{
	[_urlConnection release];
    [_responseDic release];
    [_responseData release];
	
	[super dealloc];
}


@end

//获取服务网管地址
@implementation WebInfoBinding_GetGateAddress

@synthesize app_version = _app_version;
@synthesize client_type = _client_type;
@synthesize test_flag = _test_flag;

-(id)initWithBinding:(WebInfoBinding *)binding AppVersion:(NSString *)aAppVersion ClientType:(NSString *)aClientType TestFlag:(NSString *)aTestFlag{
    self = [super initWithBinding:binding];
    
    if (self) {
        self.app_version = aAppVersion;
        self.client_type = aClientType;
        self.test_flag = aTestFlag;
    }
    
    return self;
}

- (void)main
{
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys:_app_version, @"client_version", _client_type, @"client_type", _test_flag, @"is_test", nil];
    NSError *error =nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

- (void)dealloc
{
	[_app_version release];
    [_client_type release];
    [_test_flag release];
	[super dealloc];
}


@end

//获取版本更新信息
@implementation WebInfoBinding_GetServerVersion

@synthesize app_version = _app_version;
@synthesize client_type = _client_type;

-(id)initWithBinding:(WebInfoBinding *)binding AppVersion:(NSString *)aAppVersion ClientType:(NSString *)aClientType{
    self = [super initWithBinding:binding];
    
    if (self) {
        self.app_version = aAppVersion;
        self.client_type = aClientType;
    }
    
    return self;
}

- (void)main
{
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys:_app_version, @"client_version", _client_type, @"client_type", nil];
    NSLog(@"requst version = [%@]", outData);
    NSError *error =nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

- (void)dealloc
{
	[_app_version release];
    [_client_type release];
	[super dealloc];
}


@end


//注册第一步
@implementation WebInfoBinding_UserRegister

@synthesize user = _user;
@synthesize vesting = _vesting;
@synthesize regist_type = _regist_type;

-(id)initWithBinding:(WebInfoBinding *)binding User:(NSString *)aUser Vesting:(NSString *)aVesting RegistType:(NSString *)aRegistType{
    self = [super initWithBinding:binding];
    
    if (self) {
        self.user = aUser;
        self.vesting = aVesting;
        self.regist_type = aRegistType;
    }
    
    return self;
}

- (void)main
{
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys:_user, @"user", _vesting, @"vesting", _regist_type, @"refist_type", nil];
    NSError *error =nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

- (void)dealloc
{
	[_user release];
    [_vesting release];
    [_regist_type release];
	[super dealloc];
}

@end


//注册第二步
@implementation WebInfoBinding_UserRegisterNext

@synthesize user = _user;
@synthesize password = _password;
@synthesize mac = _mac;
@synthesize refist_type = _refist_type;
@synthesize vesting = _vesting;

-(id)initWithBinding:(WebInfoBinding *)binding user:(NSString *)aUser vesting:(NSString *)aVesting refistType:(NSString *)aRefistType password:(NSString *)aPassword mac:(NSString *)aMac  {
    self = [super initWithBinding:binding];
    
    if (self) {
        self.user = aUser;
        self.password = aPassword;
        self.mac = aMac;
        self.refist_type = aRefistType;
        self.vesting = aVesting;
        
        NSLog(@"canshu = [%@],[%@],[%@],[%@],[%@]", _user,_vesting,_refist_type,_password,_mac);
    }
    return  self;
}


- (void)main
{
	[_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys:_user, @"user",_password, @"pass", _mac, @"mac", _refist_type, @"refist_type", _vesting, @"vesting", nil];
    NSError *error =nil;
    
    NSLog(@"SEND DATA = %@", outData);
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

- (void)dealloc
{
	[_user release];
    [_password release];
    [_mac release];
    [_vesting release];
	[super dealloc];
}

@end


//登录
@implementation WebInfoBinding_UserLogin

@synthesize username = _username;
@synthesize password = _password;

-(id)initWithBinding:(WebInfoBinding *)binding Username:(NSString *)aUsername Password:(NSString *)aPassword Version:(NSString *)aVersion Vesting:(NSString *)aVesting ClientType:(NSString *)aClientType DeviceToken:(NSString *)aDeviceToken{
    self  = [super initWithBinding:binding];
    
    if (self) {
        self.username = aUsername;
        self.password = aPassword;
        self.version = aVersion;
        self.vesting = aVesting;
        self.client_type = aClientType;
        self.device_token = aDeviceToken;
    }
    return self;
}

- (void)main
{
	[_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys:_username, @"user", _password, @"password", _version, @"client_version", _vesting, @"vesting", _client_type, @"client_type", _device_token,@"devicetoken" ,nil];
    NSError *error =nil;
    
    NSLog(@"SEND DATA = %@", outData);
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

- (void)dealloc
{
	[_username release];
    [_password release];
    [_version release];
    [_device_token release];
	[super dealloc];
}

@end

//登录
@implementation WebInfoBinding_UserLogout

@synthesize token = _token;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken{
    self  = [super initWithBinding:binding];
    
    if (self) {
        self.token = _token;
    }
    return self;
}

- (void)main
{
	[_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys:_token, @"token", nil];
    NSError *error =nil;
    
    NSLog(@"SEND DATA = %@", outData);
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    [_token release];
    [super dealloc];
}

@end



//绑定邮箱
@implementation WebInfoBinding_UserBindMac

@synthesize token = _token;
@synthesize mac = _mac;
@synthesize auth_code = _auth_code;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken Mac:(NSString *)aMac AuthCode:(NSString *)aAuthCode{
    self = [super initWithBinding:binding];
    
    if (self) {
        self.token = aToken;
        self.mac = aMac;
        self.auth_code = aAuthCode;
        
        NSLog(@"canshu = [%@ %@ %@]", aToken, aMac, aAuthCode);
        
    }
    return self;
}

- (void)main
{
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _token, @"token", _mac, @"mac", _auth_code, @"auth", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    [_token release];
    [_mac release];
    [_auth_code release];
    [super dealloc];
}

@end

//绑定邮箱
@implementation WebInfoBinding_UserBindEmail

@synthesize token = _token;
@synthesize email = _email;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken Email:(NSString *)aEmail{
    self = [super initWithBinding:binding];
    
    if (self) {
        self.token = aToken;
        self.email = aEmail;
        
        NSLog(@"canshu = [%@ %@]", aToken, aEmail);
        
    }
    return self;
}

- (void)main
{
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _token, @"token", _email, @"email", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    [_token release];
    [_email release];
    [super dealloc];
}

@end

//绑定邮箱第二步
@implementation WebInfoBinding_UserBindEmailNext

@synthesize token = _token;
@synthesize email = _email;
@synthesize auth_code = _auth_code;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken Email:(NSString *)aEmail AuthCode:(NSString *)aAuthCode{
    self = [super initWithBinding:binding];
    
    if (self) {
        self.token = aToken;
        self.email = aEmail;
        self.auth_code = aAuthCode;
        
        NSLog(@"canshu = [%@ %@ %@]", aToken, aEmail, aAuthCode);
        
    }
    return self;
}

- (void)main
{
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _token, @"token", _email, @"email", _auth_code, @"auth", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    [_token release];
    [_email release];
    [_auth_code release];
    [super dealloc];
}

@end






@implementation WebInfoBinding_UserGetDeviceInfo

@synthesize token = _token;
@synthesize device_id = _device_id;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken DeviceId:(NSString *)aDeviceId{
    self = [super initWithBinding:binding];
    
    if (self) {
        self.token = aToken;
        self.device_id = aDeviceId;
        
        NSLog(@"canshu = [%@ %@]", _token, _device_id);
    }
    
    return self;
}

- (void)main
{
    NSLog(@"start main");
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _token, @"token", _device_id, @"device_id", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    [_token release];
    [_device_id release];
    [super dealloc];
}

@end


//添加设备
@implementation WebInfoBinding_UserAddDevice

@synthesize token = _token;
@synthesize deviceID = _deviceID;
@synthesize deviceName = _deviceName;

-(id)initWithBinding:(WebInfoBinding *)binding DeviceId:(NSString *)aDeviceId DeviceName:(NSString *)aDeviceName Token:(NSString *)aToken{
    self = [super initWithBinding:binding];
    
    if (self) {
        
        self.deviceID = aDeviceId;
        self.deviceName = aDeviceName;
        self.token = aToken;
        
        
        NSLog(@"WebInfoBinding_UserAddDevice canshu = [%@ %@ %@]", _deviceID, _deviceName, _token);
    }
    return self;
}

- (void)main
{
    NSLog(@"start main");
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _deviceID, @"device_id", _deviceName, @"name",_token,@"token",nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    
    [_deviceID release];
    [_deviceName release];
    [_token release];
    [super dealloc];
}

@end


//设备重命名
@implementation WebInfoBinding_UserRenameDevice

@synthesize token = _token;
@synthesize deviceID = _deviceID;
@synthesize deviceName = _deviceName;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken DeviceId:(NSString *)aDeviceId DeviceName:(NSString *)aDeviceName{
    self = [super initWithBinding:binding];
    
    if (self) {
        self.token = aToken;
        self.deviceID = aDeviceId;
        self.deviceName = aDeviceName;
        
        NSLog(@"WebInfoBinding_UserRenameDevice canshu = [%@ %@ %@]", _token, _deviceID, _deviceName);
    }
    return self;
}

- (void)main
{
    NSLog(@"start main");
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _token, @"token", _deviceID, @"device_id", _deviceName, @"device_name", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    [_token release];
    [_deviceID release];
    [_deviceName release];
    
    [super dealloc];
}

@end

//更改设备开放权限
@implementation WebInfoBinding_UserModifyDeviceAuthSwitch

@synthesize token = _token;
@synthesize deviceID = _deviceID;
@synthesize authSwitch = _authSwitch;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken DeviceId:(NSString *)aDeviceId AuthSwitch:(NSString *)aAuthSwitch{
    self = [super initWithBinding:binding];
    
    if (self) {
        self.token = aToken;
        self.deviceID = aDeviceId;
        self.authSwitch = aAuthSwitch;
        
        NSLog(@"WebInfoBinding_UserModifyDeviceAuthSwitch canshu = [%@ %@ %@]", _token, _deviceID, _authSwitch);
    }
    return self;
}

-(void)main{
    NSLog(@"start main");
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _token, @"token", _deviceID, @"device_id", _authSwitch, @"is_open", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
}

@end

//设备解绑
@implementation WebInfoBinding_UserUnbindDevice

@synthesize token = _token;
@synthesize deviceID = _deviceID;


-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken DeviceId:(NSString *)aDeviceId{
    self = [super initWithBinding:binding];
    
    if (self) {
        self.token = aToken;
        self.deviceID = aDeviceId;
        
        NSLog(@"WebInfoBinding_UserUnbindDevice canshu = [%@ %@]", _token, _deviceID);
    }
    return self;
}

- (void)main
{
    NSLog(@"start main");
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _token, @"token", _deviceID, @"device_id", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    [_token release];
    [_deviceID release];
    [super dealloc];
}

@end

//设备解绑
@implementation WebInfoBinding_UserUpdateDeviceInfo

@synthesize token = _token;
@synthesize deviceID = _deviceID;
@synthesize authority = _authority;


-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken DeviceId:(NSString *)aDeviceId Authority:(NSString *)aAuthority{
    self = [super initWithBinding:binding];
    
    if (self) {
        self.token = aToken;
        self.deviceID = aDeviceId;
        self.authority = aAuthority;
        
        NSLog(@"WebInfoBinding_UserUpdateDeviceInfo canshu = [%@ %@ %@]", _token, _deviceID ,_authority);
    }
    return self;
}

- (void)main
{
    NSLog(@"start main");
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _token, @"token", _deviceID, @"device_id", _authority, @"authority", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    [_token release];
    [_deviceID release];
    [super dealloc];
}

@end

@implementation WebInfoBinding_UserModifyDevicePassword

@synthesize token = _token;
@synthesize deviceID = _deviceID;
@synthesize deviceUser  = _deviceUser;
@synthesize devicePasswd = _devicePasswd;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken DeviceId:(NSString *)aDeviceId DeviceUser:(NSString *)aDeviceUser DevicePasswd:(NSString *)aDevicePasswd{
    
    self = [super initWithBinding:binding];
    
    if (self) {
        self.token = aToken;
        self.deviceID = aDeviceId;
        self.deviceUser = aDeviceUser;
        self.devicePasswd = aDevicePasswd;
        
        NSLog(@"WebInfoBinding_UserModifyDevicePassword canshu = [%@ %@ %@ %@]", _token, _deviceID ,_deviceUser, _devicePasswd);
    }
    return self;
}

- (void)main
{
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _token, @"token", _deviceID, @"device_id", _deviceUser, @"user", _devicePasswd, @"pass", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    [_token release];
    [_deviceID release];
    [_deviceUser release];
    [_devicePasswd release];
    [super dealloc];
}

@end

//通过邮箱获取验证码
@implementation WebInfoBinding_UserGetEmailCode

@synthesize token = _token;


-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken{
    self = [super initWithBinding:binding];
    
    if (self) {
        self.token = aToken;
        
        NSLog(@"WebInfoBinding_UserGetEmailCode canshu = [%@ ]", _token);
    }
    return self;
}

- (void)main
{
    NSLog(@"start main");
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _token, @"token", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    [_token release];
    
    [super dealloc];
}

@end

@implementation WebInfoBinding_UserForgetPassword

@synthesize phoneNumber = _phoneNumber;


-(id)initWithBinding:(WebInfoBinding *)binding PhoneNumber:(NSString *)aPhoneNumber Vesting:(NSString *)aVesting{
    self = [super initWithBinding:binding];
    
    if (self) {
        self.phoneNumber = aPhoneNumber;
        self.vesting = aVesting;
        NSLog(@"WebInfoBinding_UserForgetPassword canshu = [%@,%@ ]", _phoneNumber,_vesting);
    }
    return self;
}

- (void)main
{
    NSLog(@"start main");
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _phoneNumber, @"user", _vesting, @"vesting", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    [_phoneNumber release];
    [_vesting release];
    [super dealloc];
}

@end

//通过电话号码重置密码
@implementation WebInfoBinding_UserResetPasswordByPhoneNumber

@synthesize username = _username;
@synthesize authCode = _authCode;
@synthesize password = _password;


-(id)initWithBinding:(WebInfoBinding *)binding Username:(NSString *)aUsername AuthCode:(NSString *)aAuthCode Password:(NSString *)aPassword{
    self = [super initWithBinding:binding];
    
    if (self) {
        self.username = aUsername;
        self.authCode = aAuthCode;
        self.password = aPassword;
        
        NSLog(@"WebInfoBinding_UserUnbindDevice canshu = [%@ %@ %@]", _username, _authCode, _password);
    }
    return self;
}

- (void)main
{
    NSLog(@"start main");
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _username, @"phone", _authCode, @"auth", _password,  @"pass", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    [_username release];
    [_authCode release];
    [_password release];
    
    [super dealloc];
}

@end

//修改密码
@implementation WebInfoBinding_UserModifyPassword

@synthesize token = _token;
@synthesize oldPassword = _oldPassword;
@synthesize modifyPassword = _modifyPassword;

-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken Password:(NSString *)aPassword NewPassword:(NSString *)aNewPassword{
    
    self = [super initWithBinding:binding];
    
    if (self) {
        self.token = aToken;
        self.oldPassword = aPassword;
        self.modifyPassword = aNewPassword;
        
        NSLog(@"WebInfoBinding_UserModifyPassword canshu = [%@ %@ %@]", _token, _oldPassword, _modifyPassword);
    }
    
    return self;
}

- (void)main
{
    NSLog(@"start main");
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _token, @"token", _oldPassword, @"old_pass", _modifyPassword, @"new_pass", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    [_token release];
    [_oldPassword release];
    [_modifyPassword release];
    
    [super dealloc];
}


@end


//获取消息
@implementation WebInfoBinding_UserGetMessage

@synthesize token = _token;


-(id)initWithBinding:(WebInfoBinding *)binding Token:(NSString *)aToken{
    
    self = [super initWithBinding:binding];
    
    if (self) {
        self.token = aToken;
        
        
//        NSLog(@"WebInfoBinding_UserGetMessage canshu = [%@ %@ %@]", _token, _startID, _count);
    }
    
    return self;
}

- (void)main
{
    NSLog(@"start main");
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _token, @"token", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}

-(void)dealloc{
    [_token release];
    
    
    [super dealloc];
}

@end



@implementation WebInfoBinding_AppelModify

@synthesize appel = _appel;
@synthesize token = _token;

-(id)initWithBinding:(WebInfoBinding *)binding Appel:(NSString *)aAppel Token:(NSString *)aToken
{

    self = [super initWithBinding:binding];
    if (self) {
        self.appel = aAppel;
        self.token = aToken;
        
    }


    return self;


}
- (void)main
{
    NSLog(@"start main");
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _token, @"token", _appel, @"appel", nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}
-(void)dealloc{
    [_token release];
    [_appel release];
    
    [super dealloc];
}
@end


@implementation WebInfoBinding_ShareDevice

@synthesize device_id = _device_id;
@synthesize phone = _phone;
@synthesize token = _token;
@synthesize phoneType = _phoneType;

-(id)initWithBinding:(WebInfoBinding *)binding DeviceId:(NSString *)aDeviceId Phone:(NSString *)aPhone token:(NSString *)aToken PhoneType:(NSString *)aPhoneType
{

    self = [super initWithBinding:binding];
    if (self) {
        self.device_id = aDeviceId;
        self.phone = aPhone;
        self.token = aToken;
        self.phoneType = aPhoneType;
    }

    return self;

}
- (void)main
{
    NSLog(@"start main");
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _token, @"token", _device_id, @"device_id",_phone,@"phone" , _phoneType,@"phonetype",nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}
-(void)dealloc{
    [_token release];
    [_device_id release];
    [_phone release];
    [_phoneType release];
    [super dealloc];
}

@end


@implementation WebInfoBinding_AgreeAdd

@synthesize id_mer = _id_mer;
-(id)initWithBinding:(WebInfoBinding *)binding IDMer:(NSString *)aIDMer Toekn:(NSString *)aToken
{

   self =  [super initWithBinding:binding];
    if (self) {
        self.id_mer = aIDMer;
        self.token = aToken;
    }

    return self;

}
- (void)main
{
    NSLog(@"start main");
    [_responseDic autorelease];
	_responseDic = [NSDictionary new];
    
    NSDictionary *outData = [NSDictionary dictionaryWithObjectsAndKeys: _id_mer, @"id_mer",_token,@"token",nil];
    
    NSLog(@"SEND DATA = %@", outData);
    NSError *error = nil;
    
    id result = [NSJSONSerialization dataWithJSONObject:outData options:kNilOptions error:&error];
    
	[self sendHttpPocket:result];
    
}
-(void)dealloc{
    [_id_mer release];
    [_token release];
    [super dealloc];
}
@end




