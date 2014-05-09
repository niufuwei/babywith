//
//  CameraSettingViewController.m
//  AiJiaJia
//
//  Created by wangminhong on 13-4-16.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "CameraSettingViewController.h"
#import "SettingCell.h"
#import "Configuration.h"
#import "MainAppDelegate.h"
#import "WebInfoManager.h"
#import "DeviceConnectManager.h"
#import "UIViewController+Alert.h"
#import "CameraPlayViewController.h"
#import "CameraParamSettingViewController.h"
#import "WifiListViewController.h"
#import "CameraSetNameViewController.h"
#import "CameraSetWifiViewController.h"



@implementation CameraSettingViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)loadView{
    UIView *view = [[ UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    view.backgroundColor = babywith_background_color;
    self.view = view;
    [view release];
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];
    [self CameraIsValid];


}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    _deviceDictionary = [[NSMutableDictionary alloc] initWithDictionary:[appDelegate.appDefault objectForKey:@"Device_selected"]];
//    _deviceDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    //导航设置
    {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = [_deviceDictionary objectForKey:@"name"];
        titleLabel.textColor = babywith_text_background_color;
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        [titleLabel release];
    }
    
    _cameraTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 250) style:UITableViewStylePlain];
    _cameraTableView.delegate = self;
    _cameraTableView.dataSource = self;
    _cameraTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _cameraTableView.separatorColor = [UIColor clearColor];
    _cameraTableView.backgroundView = nil;
    _cameraTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_cameraTableView];
    
    _ssidStr = [[NSString alloc] init];
    _ssidStr = @"获取中";
    
    UIButton *dissolveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dissolveButton.frame = CGRectMake(50, CGRectGetHeight(_cameraTableView.frame)+20, 220, 50);
    //dissolveButton.autoresizingMask =
    [dissolveButton addTarget:self action:@selector(dissolveDevice:) forControlEvents:UIControlEventTouchUpInside];
    [dissolveButton setBackgroundColor:[UIColor redColor]];
    [dissolveButton setTitle:@"解绑设备" forState:UIControlStateNormal];
    [self.view addSubview:dissolveButton];
    
    
}
- (void)dissolveDevice:(UIButton *)button
{
    NSLog(@"%@", [_deviceDictionary objectForKey:@"device_id"]);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定解绑本看护器" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];

}
-(void)ShowMainList:(UIButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMainList" object:[NSString stringWithFormat:@"%d",button.tag]];
    _ssidStr = @"获取中";
}

-(void)CameraIsValid{
    
    
    NSLog(@"函数调用.......");
    [_deviceDictionary addEntriesFromDictionary:[appDelegate.appDefault objectForKey:@"Device_selected"]];
    ((UILabel *)self.navigationItem.titleView).text = [_deviceDictionary objectForKey:@"name"];
    
    [self reloadTableView];
    
    appDelegate.m_PPPPChannelMgt->pCameraViewController = self;
    appDelegate.m_PPPPChannelMgt->ChangeStatusDelegate([[[appDelegate.appDefault objectForKey:@"Device_selected"]  objectForKey:@"device_id"]  UTF8String], self);
    
    int result = [self CheckOnline];
    
    if (result <= 1)
    {
        [self performSelector:@selector(StartChannel) withObject:nil];
        return;
    }
    
    //设置WIFI回调接收
    appDelegate.m_PPPPChannelMgt->SetWifiParamGettingDelegate((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], self);
    
    //获取WIFI设置信息
    appDelegate.m_PPPPChannelMgt->PPPPSetSystemParams((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], MSG_TYPE_GET_PARAMS, nil, 0);
    
}

-(void)StartChannel
{
    appDelegate.m_PPPPChannelMgt->Start((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], (char *)[@"admin" UTF8String], (char *)[[_deviceDictionary objectForKey:@"pass"] UTF8String]);
}

- (void) WifiParams: (NSString*)strDID enable:(NSInteger)enable ssid:(NSString*)strSSID channel:(NSInteger)channel mode:(NSInteger)mode authtype:(NSInteger)authtype encryp:(NSInteger)encryp keyformat:(NSInteger)keyformat defkey:(NSInteger)defkey strKey1:(NSString*)strKey1 strKey2:(NSString*)strKey2 strKey3:(NSString*)strKey3 strKey4:(NSString*)strKey4 key1_bits:(NSInteger)key1_bits key2_bits:(NSInteger)key2_bits key3_bits:(NSInteger)key3_bits key4_bits:(NSInteger)key4_bits wpa_psk:(NSString*)wpa_psk
{
    NSLog(@"wifi params  ssid = [%@]", strSSID);
    if ([strSSID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        _ssidStr = @"无";
    }
    else
    {
        _ssidStr = strSSID;
    }
    
    [self reloadTableView];
}

- (void) WifiScanResult: (NSString*)strDID ssid:(NSString*)strSSID mac:(NSString*)strMac security:(NSInteger)security db0:(NSInteger)db0 db1:(NSInteger)db1 mode:(NSInteger)mode channel:(NSInteger)channel bEnd:(NSInteger)bEnd
{
    
}

-(int)CheckOnline{

    return appDelegate.m_PPPPChannelMgt->CheckOnlineReturn((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String]);
}

-(void)ChangeQuality:(int)quality{
    
    NSLog(@"ChangeQuality qulity = [%d] ", quality);
    
    //添加默认参数 视频质量，移动侦测开关
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[appDelegate.appDefault objectForKey:[_deviceDictionary objectForKey:@"device_id"]]];
    [param setObject:[NSString stringWithFormat:@"%d", quality] forKey:@"quality"];
    [appDelegate.appDefault setObject:param forKey:[_deviceDictionary objectForKey:@"device_id"]];
    NSLog(@"quality dic = [%@]", [appDelegate.appDefault objectForKey:[_deviceDictionary objectForKey:@"device_id"]]);
    
    if ([self CheckOnline] == 2)
    {
        appDelegate.m_PPPPChannelMgt->CameraControl( (char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String],13, quality);
    }
    
    [self reloadTableView];
}

//PPPPStatusDelegate
- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status{
    NSString* strPPPPStatus;
    switch (status) {
        case PPPP_STATUS_UNKNOWN:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_FAILED:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_ID:
            NSLog(@"PPPP_STATUS_INVALID_ID");
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            [self performSelectorOnMainThread:@selector(InvalidId) withObject:nil waitUntilDone:YES];
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
            [self performSelectorOnMainThread:@selector(DeviceNotOnline) withObject:nil waitUntilDone:YES];
            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
            [self performSelectorOnMainThread:@selector(ConnectTimeout) withObject:nil waitUntilDone:YES];
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            NSLog(@"PPPP_STATUS_INVALID_USER_PWD");
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvaliduserpwd", @STR_LOCALIZED_FILE_NAME, nil);
            [self performSelectorOnMainThread:@selector(InvalidUserPwd) withObject:nil waitUntilDone:YES];
            break;
        case PPPP_STATUS_VALID_USER_PWD:
            NSLog(@"PPPP_STATUS_VALID_USER_PWD");
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPP_STATUS_VALID_USER_PWD", @STR_LOCALIZED_FILE_NAME, nil);
            [self performSelectorOnMainThread:@selector(ValidUserPwd) withObject:nil waitUntilDone:YES];
            break;
        case PPPP_STATUS_CONNECT_SUCCESS:
            NSLog(@"PPPP_STATUS_CONNECT_SUCCESS manager = [%@]", self);
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectSuccess", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            NSLog(@"PPPPStatusUnknown");
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            [self performSelectorOnMainThread:@selector(Finish:) withObject:@"0" waitUntilDone:NO];
            break;
    }
    NSLog(@"PPPPStatus  %@",strPPPPStatus);
}

-(void)ConnectTimeout{
    if ([self.view window] != nil) {
        [self makeAlert:@"看护器连接超时。"];
    }
}

-(void)DeviceNotOnline{
    if ([self.view window] != nil) {
        [self makeAlert:@"看护器不在线"];
    }
}

-(void)InvalidId{
    if ([self.view window] != nil) {
        [self makeAlert:@"看护器序列号错误。"];
    }
}

-(void)InvalidUserPwd{
    
    NSLog(@"InvalidUserPwd 9 =[%@] [%d]", [_deviceDictionary objectForKey:@"pass"] ,_passwordFlag);
    
    //校验密码是否未初始密码，如果不是，用初始密码重新连接
    if (![[_deviceDictionary objectForKey:@"pass"] isEqualToString:DeviceInitPass])
    {
        NSLog(@"password 10 is %d",_passwordFlag);
        if (_passwordFlag != 1)
        {
            _passwordFlag = 1;
            //校验密码
            appDelegate.m_PPPPChannelMgt->CheckUser((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], (char *)[DeviceInitUser UTF8String], (char *)[DeviceInitPass UTF8String]);
        }
        else{
            if ([self.view window] != nil) {
                NSLog(@"invalid chongzhi.........");
                [self makeAlert:@"看护器连接错误，请重置看护器。"];
                NSLog(@"password 11 is %d",_passwordFlag);
            }
        }
    }else{
        if ([self.view window] != nil) {
            NSLog(@"invalid chongzhi2222.........");
            [self makeAlert:@"看护器连接错误，请重置看护器。"];
        }
    }
}

-(void)ValidUserPwd{
    //校验密码是否未初始密码，如果是，修改密码 -- 可放置在对象中完成
    if (![[_deviceDictionary objectForKey:@"pass"] isEqualToString:DeviceInitPass])
    {    NSLog(@"password 12 is %d",_passwordFlag);
        if (_passwordFlag == 1) {
            //修改密码
            appDelegate.m_PPPPChannelMgt->SetUserPwdForOther((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], (char *)[DeviceInitUser UTF8String], (char *)[DeviceInitPass UTF8String]);
            
            //重启看护器
            appDelegate.m_PPPPChannelMgt->RebootDevice((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], (char *)[DeviceInitUser UTF8String], (char *)[DeviceInitPass UTF8String]);
            
            if ([self.view window] != nil) {
                [self makeAlert:@"看护器第一次使用，初始化中，请耐心等待。"];
            }
        }
        else{
            NSLog(@"password 13 is %d",_passwordFlag);
            appDelegate.m_PPPPChannelMgt->SetOnlineFlag((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], 2);
            
            if ([appDelegate.appDefault objectForKey:[_deviceDictionary objectForKey:@"device_id"]] == nil)
            {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"512", @"quality", @"0", @"sense", nil];
                [appDelegate.appDefault setObject:dic  forKey:[_deviceDictionary objectForKey:@"device_id"]];
            }
            
            //移动侦测回调接收
            appDelegate.m_PPPPChannelMgt->SetAlarmDelegate((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String],appDelegate);
            
            //设置WIFI回调接收
            appDelegate.m_PPPPChannelMgt->SetWifiParamGettingDelegate((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], self);
            
            //设置视频质量
            appDelegate.m_PPPPChannelMgt->CameraControl( (char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String],13, [[[appDelegate.appDefault objectForKey:[_deviceDictionary objectForKey:@"device_id"]] objectForKey:@"quality"] integerValue]);
            
            //设置移动侦测
            appDelegate.m_PPPPChannelMgt->SetAlarm((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], [[[appDelegate.appDefault objectForKey:[_deviceDictionary objectForKey:@"device_id"]] objectForKey:@"sense"] integerValue], 7, 0, 0, 0, 0, 0, 0, 0, 0);
            
            //获取WIFI设置信息
            appDelegate.m_PPPPChannelMgt->PPPPSetSystemParams((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], MSG_TYPE_GET_PARAMS, nil, 0);
            
        }
    }else{
        //生成随机数，修改密码
        int randInt = [[_deviceDictionary objectForKey:@"pass"] integerValue];
        while (randInt == [[_deviceDictionary objectForKey:@"pass"] integerValue]) {
            randInt = [self getRandomNumber:100000 to:999999];
        }
        
        //通知服务器密码已修改
        BOOL result = [appDelegate.webInfoManger UserModifyDevicePasswordUsingToken:[appDelegate.appDefault objectForKey:@"Token"] DeviceId:[_deviceDictionary objectForKey:@"device_id"] DeviceUser:[_deviceDictionary objectForKey:@"user"] DevicePasswd:[NSString stringWithFormat:@"%d", randInt]];
        
        if (result) {
            //修改密码
            appDelegate.m_PPPPChannelMgt->SetUserPwd((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], (char *)"", (char *)"", (char *)"", (char *)"", (char *)[[_deviceDictionary objectForKey:@"user"] UTF8String], (char *)[[NSString stringWithFormat:@"%d", randInt] UTF8String]);
            
            //设置devicelist
            [appDelegate.deviceConnectManager modifyDevicePassword:[_deviceDictionary objectForKey:@"device_id"] Password:[NSString stringWithFormat:@"%d", randInt]];
            [[appDelegate.appDefault objectForKey:@"Device_selected"] addEntriesFromDictionary:[appDelegate.deviceConnectManager getDeviceInfo:[_deviceDictionary objectForKey:@"device_id"]]];
            
            [_deviceDictionary addEntriesFromDictionary:[appDelegate.deviceConnectManager getDeviceInfo:[_deviceDictionary objectForKey:@"device_id"]]];
            
            //重启看护器
            appDelegate.m_PPPPChannelMgt->PPPPSetSystemParams((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], MSG_TYPE_REBOOT_DEVICE, nil, 0);
            
            //重设账户密码
            appDelegate.m_PPPPChannelMgt->SetUserAndPwd((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], (char *)[[_deviceDictionary objectForKey:@"user"] UTF8String], (char *)[[NSString stringWithFormat:@"%d", randInt] UTF8String]);
            
            [self makeAlert:@"看护器第一次使用，初始化中，请耐心等待。"];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cameraSetting";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[SettingCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
        cell.textLabel.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1];
        cell.detailTextLabel.textColor= [UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = babywith_text_background_color;
        
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    switch (indexPath.section) {
            
//        case 0:{
//            cell.textLabel.text = @"ID";
//            cell.detailTextLabel.text = [_deviceDictionary objectForKey:@"device_id"];
//            break;
//        }
        case 0:{
            cell.textLabel.text = @"视频质量";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            int quality = [[[appDelegate.appDefault objectForKey:[_deviceDictionary objectForKey:@"device_id"]] objectForKey:@"quality"] integerValue];
            if (quality == 512) {
                cell.detailTextLabel.text = @"高清";
            }else if(quality == 256){
                cell.detailTextLabel.text = @"普通";
            }else{
                cell.detailTextLabel.text = @"一般";
            }
        }
            break;
        case 1:{
            cell.textLabel.text = @"网络选择";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = _ssidStr;

        }
            break;
            

        case 2:{
            cell.textLabel.text = @"开启移动侦测";
            
            int sense = [[[appDelegate.appDefault objectForKey:[_deviceDictionary objectForKey:@"device_id"]] objectForKey:@"sense"] integerValue];
            if (sense == 1)
            {
                cell.tag = 1;
                cell.imageView.image = [UIImage imageNamed:@"switch_on.png"];
            }
            else
            {
                cell.tag = 2;
                cell.imageView.image = [UIImage imageNamed:@"switch_off.png"];
            }
            
        }
          break;
        case 3:{
              cell.textLabel.text = @"开启视频倒置";
            int sense = [[[appDelegate.appDefault objectForKey:[_deviceDictionary objectForKey:@"device_id"]] objectForKey:@"invert"] integerValue];
            if (sense == 1) {
                cell.tag = 1;
                cell.imageView.image = [UIImage imageNamed:@"switch_on.png"];
            }else{
                cell.tag = 2;
                cell.imageView.image = [UIImage imageNamed:@"switch_off.png"];
            }

            
        }
         break;
        case 4:{
                cell.textLabel.text = @"名称修改";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       }
        break;
        
  }
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

//    if (indexPath.section == 5) {
//        
//        NSLog(@"setting campare = [%@] [%@]", [_deviceDictionary objectForKey:@"id_member"], [appDelegate.appDefault objectForKey:@"Member_id_self"]);
//        if ([[_deviceDictionary objectForKey:@"id_member"] integerValue] != [[appDelegate.appDefault objectForKey:@"Member_id_self"] integerValue]) {
//            return 0;
//        }
//    }
    
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {//获取视频质量
            
            if ([self CheckOnline] != 2) {
                [self makeAlert:@"看护器未连接，请稍后重试。"];
            }else{
                _cameraParamSettingViewController = [[CameraParamSettingViewController alloc] initWithDelegate:self];
                [self.navigationController pushViewController:_cameraParamSettingViewController animated:YES];
            }
            
            break;
        }
        case 1://网络选择
        {
            if ([self CheckOnline] != 2) {
                [self makeAlert:@"看护器未连接，请稍后重试。"];
            }else{
                if (_cameraSetWifiViewController == nil) {
                    _cameraSetWifiViewController = [[CameraSetWifiViewController alloc] init];
                }
                
                //设置WIFI回调接收
                appDelegate.m_PPPPChannelMgt->SetWifiParamDelegate((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], _cameraSetWifiViewController);
                
                appDelegate.m_PPPPChannelMgt->PPPPSetSystemParams((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], MSG_TYPE_WIFI_SCAN, nil, 0);
                
                [self.navigationController pushViewController:_cameraSetWifiViewController animated:YES];
            }
            break;
        }

        case 2:{
            
            SettingCell *cell = (SettingCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            if (cell.tag == 1) {
                cell.tag = 2;
                cell.imageView.image = [UIImage imageNamed:@"switch_off.png"];
            }else{
                cell.tag = 1;
                cell.imageView.image = [UIImage imageNamed:@"switch_on.png"];
            }
            
            //添加默认参数 视频质量，移动侦测开关
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[appDelegate.appDefault objectForKey:[_deviceDictionary objectForKey:@"device_id"]]];
            [param setObject:[NSString stringWithFormat:@"%d", 2-cell.tag] forKey:@"sense"];
            [appDelegate.appDefault setObject:param forKey:[_deviceDictionary objectForKey:@"device_id"]];
            NSLog(@"sense is = [%@]", [[appDelegate.appDefault objectForKey:[_deviceDictionary objectForKey:@"device_id"]] objectForKey:@"sense"]);
            
            if ([self CheckOnline] == 2)
            {
                appDelegate.m_PPPPChannelMgt->SetAlarm((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], 2-cell.tag, 7, 0, 0, 0, 0, 0, 0, 0, 0);
                MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithView: self.view];
                indicator.labelText = @"移动侦测设置成功";
                indicator.mode = MBProgressHUDModeText;
                [self.view addSubview:indicator];
                [indicator showAnimated:YES whileExecutingBlock:^{
                    sleep(1.2);
                } completionBlock:^{
                    [indicator removeFromSuperview];
                    [indicator release];
                }];
            }
            
            break;
            
        }
            case 3://视频倒置
        {
            
            SettingCell *cell = (SettingCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            if (cell.tag == 1) {
                cell.tag = 2;
                cell.imageView.image = [UIImage imageNamed:@"switch_off.png"];
            }else{
                cell.tag = 1;
                cell.imageView.image = [UIImage imageNamed:@"switch_on.png"];
            }
            
            //添加默认参数 视频倒置开关
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[appDelegate.appDefault objectForKey:[_deviceDictionary objectForKey:@"device_id"]]];
            [param setObject:[NSString stringWithFormat:@"%d", 2-cell.tag] forKey:@"invert"];
            [appDelegate.appDefault setObject:param forKey:[_deviceDictionary objectForKey:@"device_id"]];
            NSLog(@"invert dic = [%@]", [appDelegate.appDefault objectForKey:[_deviceDictionary objectForKey:@"device_id"]]);
            

            MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithView: self.view];
            if (cell.tag == 1) {
                indicator.labelText = @"视频倒置设置成功";

            }else if (cell.tag == 2){
                indicator.labelText = @"视频正常设置成功";

            }
            indicator.mode = MBProgressHUDModeText;
            [self.view addSubview:indicator];
            [indicator showAnimated:YES whileExecutingBlock:^{
                sleep(1.2);
            } completionBlock:^{
                [indicator removeFromSuperview];
                [indicator release];
            }];

            
            break;
        }
                case 4:
             {
                //名称修改
                    _cameraSetNameViewController = [[CameraSetNameViewController alloc] init];
                    [self.navigationController pushViewController:_cameraSetNameViewController animated:YES];
                 
                    
            }
            break;
        case 5:{//权限开放
            SettingCell *cell = (SettingCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            if (cell.tag == 1) {
                
                BOOL result = [appDelegate.webInfoManger UserModifyDeviceAuthSwitchUsingToken:[appDelegate.appDefault objectForKey:@"Token"] DeviceId:[_deviceDictionary objectForKey:@"device_id"] AuthSwitch:@"0"];
                
                if (result) {
                    cell.tag = 2;
                    cell.imageView.image = [UIImage imageNamed:@"switch_off.png"];
                }else{
                    [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
                }
                
            }else{
                
                BOOL result = [appDelegate.webInfoManger UserModifyDeviceAuthSwitchUsingToken:[appDelegate.appDefault objectForKey:@"Token"] DeviceId:[_deviceDictionary objectForKey:@"device_id"] AuthSwitch:@"1"];
                
                if (result) {
                    cell.tag = 1;
                    cell.imageView.image = [UIImage imageNamed:@"switch_on.png"];
                }else{
                    [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
                }
                
                cell.tag = 1;
                cell.imageView.image = [UIImage imageNamed:@"switch_on.png"];
            }
            break;
        }
        default:
            break;
    }
}

-(void)alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        //设备解绑
        BOOL result = [appDelegate.webInfoManger UserUnbindDeviceUsingToken:[appDelegate.appDefault objectForKey:@"Token"] DeviceId:[_deviceDictionary objectForKey:@"device_id"]];
        
        if (result) {
            [self performSelector:@selector(UnbindDevice) withObject:nil afterDelay:0.1];
        }else{
            [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
        }
    }
        
}

-(void)UnbindDevice{
    appDelegate.m_PPPPChannelMgt->Stop((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String]);
    [appDelegate.appDefault setObject:nil forKey:@"Device_selected"];
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMainList" object:@"10"];
}

-(void)RebootDevice{
    //重启看护器
    appDelegate.m_PPPPChannelMgt->PPPPSetSystemParams((char *)[[_deviceDictionary objectForKey:@"device_id"] UTF8String], MSG_TYPE_REBOOT_DEVICE, nil, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 1;
        case 3:
            return 1;
        case 4:
            return 1;
        case 5:
            return 1;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[_deviceDictionary objectForKey:@"id_member"] integerValue] != [[appDelegate.appDefault objectForKey:@"Member_id_self"] integerValue]) {
        
        return 5;
    }
    return 5;
}

-(void)showVedioMain{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    CGPoint location = scrollView.contentOffset;
    CGPoint tableLocation = _cameraTableView.frame.origin;
    
    if (tableLocation.x - location.x <-200) {
        _cameraTableView.frame = CGRectMake(0, -200, 320, 420);
    }else if(tableLocation.x - location.x >0){
        _cameraTableView.frame = CGRectMake(0, 0, 320, 420);
    }else{
        _cameraTableView.frame = CGRectMake(0, tableLocation.x - location.x, 320, 420);
    }
}

//-(void)viewDidAppear:(BOOL)animated{
//    ((UILabel *)(self.navigationItem.titleView)).text = [_deviceDictionary objectForKey:@"name"];
//}

-(void)reloadTableView{
    [_cameraTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

-(void)viewDidUnload{
    [_cameraTableView release];
    _cameraTableView = nil;
    
    [_wifiListViewController release];
    _wifiListViewController = nil;
    
    [_deviceDictionary release];
    _deviceDictionary = nil;
    
    [_cameraParamSettingViewController release];
    _cameraParamSettingViewController = nil;
    
    [_cameraSetNameViewController release];
    _cameraSetNameViewController = nil;
}

-(void)dealloc{
    [_cameraTableView release];
    [_wifiListViewController release];
    [_deviceDictionary release];
    [_cameraParamSettingViewController release];
    [_cameraSetNameViewController release];
    
    //[super dealloc];
}


@end
