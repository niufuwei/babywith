//
//  CameraSetWifiViewController.m
//  BabyWith
//
//  Created by wangminhong on 13-9-1.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "CameraSetWifiViewController.h"
#import "UIViewController+Alert.h"
#import "SettingCell.h"
#import "Configuration.h"
#import "MainAppDelegate.h"
#import "MBProgressHUD.h"
#import "CameraSettingViewController.h"


@implementation CameraSetWifiViewController

- (id)initWithDelegate:(NSObject *)delegate
{
    self = [super init];
    if (self) {
        // Custom initialization
        _delegate = delegate;
    }
    return self;
}

-(void)loadView{
    UIView *view = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] applicationFrame].size.height)];
    view.backgroundColor = babywith_background_color;
    self.view = view;
    [view release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    _wifiListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _wifiListTableView.separatorColor = [UIColor clearColor];
    _wifiListTableView.backgroundView = nil;
    _wifiListTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_wifiListTableView];
}

- (void) WifiScanResult: (NSString*)strDID ssid:(NSString*)strSSID mac:(NSString*)strMac security:(NSInteger)security db0:(NSInteger)db0 db1:(NSInteger)db1 mode:(NSInteger)mode channel:(NSInteger)channel bEnd:(NSInteger)bEnd{
    
    int  flag = 0;
    //去掉重复
    for (NSDictionary *dic in _wifiSearchList) {
        if ([[dic objectForKey:@"strSSID"] isEqualToString:strSSID]) {
            flag = 1;
            break;
        }
    }
    
    if (flag == 0) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:strDID,@"strDID", strSSID, @"strSSID", strMac, @"strMac", [NSString stringWithFormat:@"%d", security], @"security",[NSString stringWithFormat:@"%d", mode], @"mode",[NSString stringWithFormat:@"%d", channel], @"channel", nil];
        
        [_wifiSearchList addObject:dic];
        [_wifiListTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select row = [%d]", indexPath.row);
    
    SettingCell *cell = (SettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    //弹出提示框，输入密码
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alertView.delegate = self;
    alertView.tag = indexPath.row;
    [alertView show];
    [alertView release];
    
    
}

-(void)alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        NSDictionary *dic = [_wifiSearchList objectAtIndex:alertView.tag];
        
        NSString *m_strPwd = [alertView textFieldAtIndex:0].text;
        
        
        int m_security = [[dic objectForKey:@"security"] intValue];
        
        if ([m_strPwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            
            UIAlertView *alertViewTwice = [[UIAlertView alloc] initWithTitle:@"输入密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertViewTwice.alertViewStyle = UIAlertViewStyleSecureTextInput;
            alertViewTwice.message = @"密码不可为空。";
            alertViewTwice.delegate = self;
            alertViewTwice.tag = alertView.tag;
            [alertViewTwice show];
            
            return;
        }
        
        char *pkey = NULL;
        char *pwpa_psk = NULL;
        
        switch (m_security) {
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
     int i =    appDelegate.m_PPPPChannelMgt->SetWifi((char *)[[[appDelegate.appDefault objectForKey:@"Device_selected"] objectForKey:@"device_id"] UTF8String],1, (char *)[[dic objectForKey:@"strSSID"] UTF8String], [[dic objectForKey:@"channel"] intValue], [[dic objectForKey:@"mode"] intValue], m_security, 0, 0, 0, pkey, (char *)"", (char *)"", (char *)"", 0, 0, 0, 0, pwpa_psk);
        
        NSLog(@"设置网络的返回参数是%d",i);
        
        
        
        MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithView:self.view];
        indicator.labelText = @"看护器已设置WIFI，将重启后生效。";
        indicator.mode = MBProgressHUDModeText;
        [self.view addSubview:indicator];
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
            [indicator release];
            [(CameraSettingViewController *)_delegate RebootDevice];
            [self.navigationController popViewControllerAnimated:YES];

            
        }];
    }else if(buttonIndex == 0){
        SettingCell *cell = (SettingCell *)[_wifiListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_wifiSearchList count];
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"WIFI_search";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.textLabel.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = babywith_text_background_color;
        
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

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"camerasetwifiviewcontroller viewdiddisappear=====");
    
    [_wifiSearchList removeAllObjects];
    [_wifiListTableView reloadData];
}

-(void)viewDidUnload{
    [_wifiListTableView release];
    _wifiListTableView = nil;
    
    [_wifiSearchList release];
    _wifiSearchList = nil;
    
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
   
}

-(void)dealloc{
    [_wifiListTableView release];
    [_wifiSearchList release];
    
    [super dealloc];
}

@end
