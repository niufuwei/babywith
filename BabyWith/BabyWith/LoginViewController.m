//
//  LoginViewController.m
//  AiJiaJia
//
//  Created by wangminhong on 13-4-2.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "LoginViewController.h"
#include "Configuration.h"
#import "MainAppDelegate.h"
#import "RegPhoneViewController.h"
#import "WebInfoManager.h"
#import "ForgetPasswordViewController.h"
#import "UIViewController+Alert.h"
#import <QuartzCore/QuartzCore.h>
#import "FamilyEntryViewController.h"
#import "PersonInfoInitViewController.h"
#import "RelativeLoginViewController.h"

@implementation LoginViewController

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

-(void)viewDidLoad{
    [super viewDidLoad];
    
    int height = self.view.frame.size.height;
    
    _blank = (height-460)/4;
    
    //导航条设置
    {
        //隐藏左边返回按钮
        self.navigationItem.hidesBackButton = YES;
        
        //设置导航条背景图案
        CGSize imageSize = CGSizeMake(320, 44);
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [babywith_green_color set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.navigationController.navigationBar setBackgroundImage:pressedColorImg forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.clipsToBounds = YES;
//        self.navigationController.navigationBar.shadowImage = [[[UIImage alloc] init] autorelease];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"登    录";
        titleLabel.textColor = babywith_text_background_color;
        titleLabel.font = [UIFont systemFontOfSize:22];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        [titleLabel release];
        
        //导航右按钮--注册页面
        UIButton *regButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 36)];
        [regButton setBackgroundImage:[UIImage imageNamed:@"login_register.png"] forState:UIControlStateNormal];
        [regButton setBackgroundImage:[UIImage imageNamed:@"login_register_highlight.png"] forState:UIControlStateHighlighted];
        [regButton setTitle:@"注册" forState:UIControlStateNormal];
        regButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        regButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        regButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [regButton addTarget:self action:@selector(showRegView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView: regButton];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        [rightItem release];
        [regButton release];
        
    }
    
    //LOGO图标加载
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_login.png"]];
    logoView.frame = CGRectMake(100, height/24+_blank, 120,146);
    
    [self.view addSubview:logoView];
    [logoView release];
    
    //文本框设置加载
    {
        //用户名/邮箱/手机号
        _username = [[UITextField alloc] initWithFrame:CGRectMake(60, height*11/25+_blank, 200, 32)];
        _username.layer.cornerRadius = 5.0;
        _username.placeholder = @"手机号/邮箱";
        _username.font = [UIFont systemFontOfSize:14];
        _username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _username.textAlignment = UITextAlignmentLeft;
        _username.delegate = self;
        _username.text = [appDelegate.appDefault objectForKey:@"Username"];
        _username.backgroundColor = babywith_text_background_color;
        _username.clearButtonMode = UITextFieldViewModeWhileEditing;
        _username.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        //左边留空10像素
        UILabel *paddingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 32)];
        paddingLabel.backgroundColor = [UIColor clearColor];
        _username.leftView = paddingLabel;
        _username.leftViewMode = UITextFieldViewModeAlways;
        _username.keyboardType = UIKeyboardTypeASCIICapable;
        
        [self.view addSubview:_username];
        [paddingLabel release];
        
        //密码
        _password = [[UITextField alloc] initWithFrame:CGRectMake(60, height*11/25+50+_blank, 200, 32)];
        _password.layer.cornerRadius = 5.0;
        _password.font = [UIFont systemFontOfSize:14];
        _password.placeholder =@"密码";
        _password.text = [appDelegate.appDefault objectForKey:@"Password"];
        _password.textAlignment = UITextAlignmentLeft;
        _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _password.delegate = self;
        _password.secureTextEntry=YES;
        _password.backgroundColor = babywith_text_background_color;
        _password.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        //左边留空10像素
        UILabel *paddingLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 32)];
        paddingLabel2.backgroundColor = [UIColor clearColor];
        _password.leftView = paddingLabel2;
        _password.leftViewMode = UITextFieldViewModeAlways;
        
        [self.view addSubview:_password];
        [paddingLabel2 release];
        
        //忘记密码
        UIButton *login_forget = [[UIButton alloc] initWithFrame:CGRectMake(60+200+4, height*11/25+52+_blank, 30, 30)];
        [login_forget setBackgroundImage:[UIImage imageNamed:@"login_forget.png"] forState:UIControlStateNormal];
        [login_forget setBackgroundImage:[UIImage imageNamed:@"login_forget_highlight.png"] forState:UIControlStateHighlighted];
        [login_forget addTarget:self action:@selector(showForgetPassword) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:login_forget];
        [login_forget release];
        
        if (_username.text.length != 0 && _password.text.length != 0) {
            UIView *topView = [[UIView alloc] initWithFrame:self.view.frame];
            topView.backgroundColor = babywith_background_color;
            topView.tag = 10;
            
            //iphone4,5比例差
            int gapHeight = (self.view.frame.size.height-460)/2;
            
            //百分比定位logo位置
            UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
            logoView.frame = CGRectMake(59, 100+gapHeight/2, 207,212);
//            logoView.alpha = 0.3;
            [topView addSubview: logoView];
            [logoView release];
            
            [self.navigationController.view addSubview:topView];
            [topView release];
        }
        
    }
    
    //登陆按钮
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(60, height*2/3+_blank, 200, 37)];
    [loginButton setBackgroundColor:babywith_green_color];
    
    CGSize imageSize = CGSizeMake(300, 40);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [babywith_green_color_hightlight set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [loginButton setBackgroundImage:pressedColorImg forState:UIControlStateHighlighted];
    
    [loginButton setTitle:@"登    录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [loginButton.layer setMasksToBounds:YES];
    [loginButton.layer setCornerRadius:5.0];
    [loginButton addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginButton];
    [loginButton release];
    
    //亲友账号登陆按钮
    UIButton *relativeLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(60, height*2/3+_blank+50, 200, 37)];
    [relativeLoginButton setBackgroundColor:babywith_green_color];
    
    [relativeLoginButton setBackgroundImage:pressedColorImg forState:UIControlStateHighlighted];
    
    [relativeLoginButton setTitle:@"亲友账号登录" forState:UIControlStateNormal];
    relativeLoginButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [relativeLoginButton.layer setMasksToBounds:YES];
    [relativeLoginButton.layer setCornerRadius:5.0];
    [relativeLoginButton addTarget:self action:@selector(relativeLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:relativeLoginButton];
    [relativeLoginButton release];
    
    [appDelegate.appDefault setObject:nil forKey:@"BabyWith_address"];
    
    
    //添加单击手势，隐藏键盘
    [self viewAddGest];
    
    //捕捉触发键盘事件，页面上移，防止遮挡文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [self performSelector:@selector(AutoLogin) withObject:nil afterDelay:0.1];
}


-(int )GetGateAddress{
    
    //获取服务器地址
    BOOL result = [appDelegate.webInfoManger UserGetGateAddressUsingAppVersion:ClientVersion ClientType:@"2" TestFlag:@"0"];
    if (!result) {
        if ([[appDelegate.appDefault objectForKey:@"Error_code"] isEqualToString:@"net_error"]) {
            [self makeAlert:@"网络错误，请确认您的网络连接"];
        }
        return -1;
    }
    return  0;
}

int updateFlag = 0;

-(int)CheckUpdate{
    NSLog(@"CheckUpdate");
    
    int result = [appDelegate.webInfoManger UserGetServerVersionUsingAppVersion:ClientVersion ClientType:@"2"];
    if (result < 0) { //检测服务器版本错误
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[appDelegate.appDefault objectForKey:@"Error_message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.delegate = self;
        [alert show];
        [alert release];
        NSLog(@"check update = [%@]",[appDelegate.appDefault objectForKey:@"Error_message"]);
        return -1;
    }else if(result == 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测宝宝微视客户端新版本，是否现在升级？" delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"马上升级", nil];
        alert.delegate = self;
        alert.tag = 2;
        [alert show];
        [alert release];
        return -1;
    }else if(result == 2){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测宝宝微视客户端新版本，是否现在升级？" delegate:self cancelButtonTitle:@"马上升级" otherButtonTitles:nil, nil];
        alert.delegate = self;
        alert.tag = 3;
        [alert show];
        [alert release];
        return -1;
    }
    
    return 0;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        [self CheckUpdate];
    }else if(alertView.tag == 2){
        if (buttonIndex == 0) {
            updateFlag = 1;
        }else{
            //跳转到APPSTORE 软件页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=689223855"]];
        }
    }else if(alertView.tag == 3){
        //跳转到APPSTORE 软件页面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=689223855"]];

    }
}

-(void)AutoLogin{
    if (((NSString *)[appDelegate.appDefault objectForKey:@"Username"]).length != 0 && ((NSString *)[appDelegate.appDefault objectForKey:@"Password"]).length != 0){
        if ([self checkFirst] == 0) {
            [self checkLogin];
        }
    }
    if ([self.navigationController.view viewWithTag:10] != nil) {
        [[self.navigationController.view viewWithTag:10] removeFromSuperview];
    }
}

-(int)checkFirst{
    if ([appDelegate.appDefault objectForKey:@"BabyWith_address"] == nil || ((NSString *)[appDelegate.appDefault objectForKey:@"BabyWith_address"]).length == 0) {
        
        int result = [self GetGateAddress];
        if (result <0) {
            return -1;
        }
        
        if (updateFlag == 0) {
            int result = [self CheckUpdate];
            if (result <0) {
                return -1;
            }
        }
    }
    
    return 0;
}

-(void)doLogin{
    if ([self checkFirst] == 0) {
        [self checkLogin];
    }
}

-(void)checkLogin{
    
    _username.text = [_username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _password.text = [_password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int phone_email_flag = [self checkTelAndEmail:_username.text Type:0];
    if (phone_email_flag < 0 ) {
        return;
    }
    
    if (_password.text.length == 0) {
        [self makeAlert:@"密码不可为空"];
        return;
    }
    
    //登陆校验，发送消息至服务器
    BOOL result = [appDelegate.webInfoManger UserLoginUsingUsername:_username.text Password:_password.text Version:ClientVersion Vesting:@"86" LoginType:[NSString stringWithFormat:@"%d", phone_email_flag] ClientType:@"2"];
    
    if (result) {
        NSLog(@"appdefault=[%d]", [[appDelegate.appDefault objectForKey:@"Family_id"] integerValue]);
        if ([appDelegate.appDefault objectForKey:@"Realname_self"] != nil && ((NSString *)[appDelegate.appDefault objectForKey:@"Realname_self"]).length >0) {
            
            if ([appDelegate.appDefault objectForKey:@"Family_id"] == nil || [[appDelegate.appDefault objectForKey:@"Family_id"] integerValue] == -1) {
                _familyEntryViewController = [[FamilyEntryViewController alloc] init];
                [self.navigationController pushViewController: _familyEntryViewController animated:YES];
            }else{
                //获取家庭信息
                BOOL result = [appDelegate.webInfoManger UserGetFamilyInfoUsingToken:[appDelegate.appDefault objectForKey:@"Token"]];
                
                if (result) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveToMain" object:nil];
                }else{
                    [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
                }
            }
        }
        else{
            _personInfoInitViewController = [[PersonInfoInitViewController alloc] init];
            [self.navigationController pushViewController:_personInfoInitViewController animated:YES];
        }
        
    }
    else{
        //提示框提示错误
        [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
    }
}


-(void)relativeLogin{
    
    if ([self checkFirst] <0) {
        return;
    }
    
    RelativeLoginViewController *relativeLoginViewController = [[[RelativeLoginViewController alloc] init] autorelease];
    [self.navigationController pushViewController:relativeLoginViewController animated:YES];
    
}


-(void)showForgetPassword{
    
    if ([self checkFirst] <0) {
        return;
    }
    
    if (_forgetPasswordViewController == nil) {
        _forgetPasswordViewController = [[ForgetPasswordViewController alloc] init];
    }
    
    [self.navigationController pushViewController:_forgetPasswordViewController animated:YES];
}

-(void)showRegView{
    
    if ([self checkFirst] <0) {
        return;
    }
    
    if (_regPhoneViewController == nil) {
        _regPhoneViewController = [[RegPhoneViewController alloc] init];
    }
    
    [self.navigationController pushViewController:_regPhoneViewController animated:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    [self.view setFrame:CGRectMake(0, -180-_blank*1.2, 320, self.view.frame.size.height)];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        [self.view setFrame:[[UIScreen mainScreen] bounds]];
        return NO;
    }
    return YES;
}


-(void) viewAddGest{
    //单击事件
    UITapGestureRecognizer *taprecognizer;
    taprecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchBlankView:)];
    taprecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:taprecognizer];
    [taprecognizer release];
}

-(void)touchBlankView:(UITapGestureRecognizer *)taprecognizer{
    
    if (taprecognizer.numberOfTapsRequired == 1) {
        [_username resignFirstResponder];
        [_password resignFirstResponder];
        [self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
        [_username resignFirstResponder];
        [_password resignFirstResponder];
        [self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    float sysVer =[[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (sysVer>= 6.0f)
    {
        if ([self.view window] == nil)// 是否是正在使用的视图
        {
            [self viewDidUnload];
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

-(void)viewDidUnload{
    [_username release];
    _username = nil;
    
    [_password release];
    _password = nil;
    
    [_forgetPasswordViewController release];
    _forgetPasswordViewController = nil;
    
    [_regPhoneViewController release];
    _regPhoneViewController = nil;
    
    [_personInfoInitViewController release];
    _personInfoInitViewController = nil;
    
    [_familyEntryViewController release];
    _familyEntryViewController = nil;
}

-(void)dealloc{
    [_username release];
    [_password release];
    [_forgetPasswordViewController release];
    [_regPhoneViewController release];
    [_personInfoInitViewController release];
    [_familyEntryViewController release];
    
    [super dealloc];
}

@end
