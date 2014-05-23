//
//  WifiListViewController.m
//  AiJiaJia
//
//  Created by wangminhong on 13-6-20.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "WifiListViewController.h"
#import "SettingCell.h"
#import "MBProgressHUD.h"
#import "Configuration.h"
#import "UIViewController+Alert.h"

@implementation WifiListViewController
@synthesize deviceID = _deviceID;

- (id)initWithDevice:(NSString *)deviceID
{
    self = [super init];
    if (self) {
        self.deviceID = deviceID;
    }
    return self;
}

-(void)loadView{
    UIView *view = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] applicationFrame].size.height)];
    view.backgroundColor = babywith_background_color;
    self.view = view;
    [view release];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //导航条设置
    {
        //左导航-主选择页面
        UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        navButton.tag = 1;
        [navButton setImage:[UIImage imageNamed:@"goBack.png"] forState:UIControlStateNormal];
        [navButton setImage:[UIImage imageNamed:@"goBack_highlight.png"] forState:UIControlStateHighlighted];
        [navButton addTarget:self action:@selector(ShowPrePage) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView: navButton];
        self.navigationItem.leftBarButtonItem = leftItem;
        
        [navButton release];
        [leftItem release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"看护器无线网络设置";
        titleLabel.textColor = babywith_text_background_color;
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        [titleLabel release];
    }
    
    _wifiSearchList = [[NSMutableArray alloc] initWithCapacity:1];
    
    _wifiListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _wifiListTableView.delegate = self;
    _wifiListTableView.dataSource = self;
    _wifiListTableView.backgroundView = nil;
    _wifiListTableView.backgroundColor = [UIColor clearColor];
    _wifiListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:_wifiListTableView];
    
    CCircleBuf *pVideoBuf = new CCircleBuf();
    CCircleBuf *pPlaybackVideoBuf = new CCircleBuf();
    
    pPPPPChannel = new CPPPPChannel(pVideoBuf, pPlaybackVideoBuf, [_deviceID UTF8String], [@"admin" UTF8String], [@"888888" UTF8String]);
    pPPPPChannel->m_PPPPStatusDelegate = self;
    pPPPPChannel->SetWifiParamsDelegate(self);
    pPPPPChannel->Start();
}

- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status{
    NSLog(@"status=[%d]", status);
    switch (status) {
        case PPPP_STATUS_CONNECT_FAILED:
            break;
        case PPPP_STATUS_DISCONNECT:
            break;
        case PPPP_STATUS_INVALID_ID:
            break;
        case PPPP_STATUS_ON_LINE:
            NSLog(@"online ===========");
            pPPPPChannel->SetSystemParams(MSG_TYPE_WIFI_SCAN, nil, 0);
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            break;
        case PPPP_STATUS_CONNECT_SUCCESS:
            break;
        default:
            break;
    }
}


- (void) WifiScanResult: (NSString*)strDID ssid:(NSString*)strSSID mac:(NSString*)strMac security:(NSInteger)security db0:(NSInteger)db0 db1:(NSInteger)db1 mode:(NSInteger)mode channel:(NSInteger)channel bEnd:(NSInteger)bEnd
{
    
    int  flag = 0;
    //去掉重复
    for (NSDictionary *dic in _wifiSearchList)
    {
        if ([[dic objectForKey:@"strSSID"] isEqualToString:strSSID])
        {
            flag = 1;
            break;
        }
    }
    
    if (flag == 0)
    {
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:strDID,@"strDID", strSSID, @"strSSID", strMac, @"strMac", [NSString stringWithFormat:@"%d", security], @"security",[NSString stringWithFormat:@"%d", mode], @"mode",[NSString stringWithFormat:@"%d", channel], @"channel", nil];
        NSLog(@"dic is %@",dic);
        [_wifiSearchList addObject:dic];
        [_wifiListTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
}

- (void) WifiParams: (NSString*)strDID enable:(NSInteger)enable ssid:(NSString*)strSSID channel:(NSInteger)channel mode:(NSInteger)mode authtype:(NSInteger)authtype encryp:(NSInteger)encryp keyformat:(NSInteger)keyformat defkey:(NSInteger)defkey strKey1:(NSString*)strKey1 strKey2:(NSString*)strKey2 strKey3:(NSString*)strKey3 strKey4:(NSString*)strKey4 key1_bits:(NSInteger)key1_bits key2_bits:(NSInteger)key2_bits key3_bits:(NSInteger)key3_bits key4_bits:(NSInteger)key4_bits wpa_psk:(NSString*)wpa_psk
{
   
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select row = [%d]", indexPath.row);
    
    //弹出提示框，输入密码
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alertView.delegate = self;
    alertView.tag = indexPath.row;
    [alertView show];
    
    
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        
        
        
        NSDictionary *dic = [_wifiSearchList objectAtIndex:alertView.tag];
        
        NSString *m_strPwd = [alertView textFieldAtIndex:0].text;

        
        int m_security = [[dic objectForKey:@"security"] intValue];
        
        if ([m_strPwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            [self makeAlert:@"请输入密码"];
            return;
        }
        
        char *pkey = NULL;
        char *pwpa_psk = NULL;
        
        
        NSLog(@"密码是%d",m_security);
        switch (m_security)
        {
            case 0:
                pkey = (char *)"";
                pwpa_psk = (char *)"";
                break;
            case 1:
                pkey = (char *)[m_strPwd UTF8String];
                pwpa_psk = (char *)"";
                break;
            case 2:
            case 3:
            case 4:
            case 5:
                pkey = (char *)"";
                pwpa_psk = (char *)[m_strPwd UTF8String];
                break;
            default:
                break;
        }
        
        int i =  pPPPPChannel->SetWifi(1, (char *)[[dic objectForKey:@"strSSID"] UTF8String], [[dic objectForKey:@"channel"] intValue], [[dic objectForKey:@"mode"] intValue], m_security, 0, 0, 0, pkey, (char *)"", (char *)"", (char *)"", 0, 0, 0, 0, pwpa_psk);
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        NSLog(@"加入的局域网的参数是%d",i);

        MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithWindow:window];
        indicator.labelText = @"看护器已设置WIFI";
        indicator.mode = MBProgressHUDModeText;
        [window addSubview:indicator];
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
            [indicator release];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  40;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_wifiSearchList count];
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"WIFI_search";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.textLabel.textColor = [UIColor colorWithRed:49/255.0 green:102/255.0 blue:143/255.0 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    cell.textLabel.text = [[_wifiSearchList objectAtIndex:indexPath.row] objectForKey:@"strSSID"];
    return cell;
}

-(void)ShowPrePage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(void)viewDidUnload{
    
    [_wifiListTableView release];
    _wifiListTableView = nil;
    
    [_wifiSearchList release];
    _wifiSearchList = nil;
    
    [_deviceID release];
    _deviceID = nil;
}

-(void)dealloc{
    
    [_wifiListTableView release];
    [_wifiSearchList release];
    [_deviceID release];
    
    if (pPPPPChannel != NULL) {
        SAFE_DELETE(pPPPPChannel);
    }
    
    [super dealloc];
}

@end
