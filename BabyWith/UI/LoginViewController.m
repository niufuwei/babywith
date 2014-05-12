//
//  LoginViewController.m
//  BabyWith_
//
//  Created by shanchen on 14-3-12.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//
#import "MainAppDelegate.h"
#include "Configuration.h"
#import "WebInfoManager.h"
#import <QuartzCore/QuartzCore.h>


#import "LoginViewController.h"
#import "LoginRegisterViewController.h"
#import "ForgotPasswordViewController.h"
#import "HomeViewController.h"
#import "Activity.h"
@interface LoginViewController ()
{

    Activity *activity;


}
@property (nonatomic) BOOL keyboardShowed;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.phoneTF.text = [appDelegate.appDefault objectForKey:@"Username"];
    self.passwordTF.text = [appDelegate.appDefault objectForKey:@"Password"];
    self.passwordTF.secureTextEntry = YES;
    
    [self configurationForGreenButton:_loginButton];
    [self titleSet:@"登陆"];
    
    activity = [[Activity alloc] initWithActivity:self.view];
    
    if (!([[appDelegate.appDefault objectForKey:@"Password"] length] == 0) && !([[appDelegate.appDefault objectForKey:@"Username"] length] == 0 ))
    {
        
        [self performSelector:@selector(AutoLogin) withObject:nil afterDelay:0.1];
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    }

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_keyboardShowed)
    {
        return;
    }
    [_phoneTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
    
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            self.view.frame = CGRectMake(0, 0, 320, kScreenHeight -44 -20);
    } completion:^(BOOL finished) {
        _keyboardShowed = NO;
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_keyboardShowed) {
        return;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
        
        if (IOS7)
        {
            self.view.frame = CGRectMake(0, -50, 320, kScreenHeight -44 -20);

        }
        else
        {
            self.view.frame = CGRectMake(0, -70, 320, kScreenHeight -44 -20);

        }
        
    } completion:^(BOOL finished) {
        _keyboardShowed = YES;
    }];
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_keyboardShowed) {
        return;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
        if (IOS7) {
            self.view.frame = CGRectMake(0, 44+20, 320, kScreenHeight -44 -20);

        } else {
            self.view.frame = CGRectMake(0, 0 , 320, kScreenHeight -44 - 20);

        }
    } completion:^(BOOL finished) {
        _keyboardShowed = NO;
    }];
    
}
- (void)AutoLogin{
    
    
    
        
        [self checkLogin];
        
    
    
}
- (void)checkLogin
{
   //去掉空格
    self.phoneTF.text = [self.phoneTF.text
                         stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.passwordTF.text = [self.passwordTF.text
                            stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //检查电话号码是否符合规格
    int phone_email_flag = [self checkTel:self.phoneTF.text Type:1];

    if (phone_email_flag == 0 )
    {
        return;
    }

    else
    {
    [activity start];
    

      //登陆校验，发送消息到服务器
    BOOL result = [appDelegate.webInfoManger UserLoginUsingUsername:self.phoneTF.text Password:self.passwordTF.text Version:ClientVersion Vesting:@"86" ClientType:@"2" DeviceToken:appDelegate.deviceToken];
    
    
    if (result) {
       
        [activity stop];
        
        //放进数据库，保证下次进来的时候就是最新的用户信息
        [appDelegate.appDefault setObject:self.phoneTF.text forKey:@"Username"];
        [appDelegate.appDefault setObject:self.passwordTF.text forKey:@"Password"];
        [USRDEFAULT setInteger:1 forKey:@"First_use_flag"];

        [NOTICECENTER postNotificationName:@"MoveToMain" object:nil];
    }
    else
    {
        [activity stop];

        //提示框提示错误
        [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
    }
    }

}
- (IBAction)login:(UIButton *)sender {
    
        [self checkLogin];
    
}

- (IBAction)accountRegister:(UIButton *)sender {
    LoginRegisterViewController *vc = [[LoginRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)forgotPassword:(UIButton *)sender {
    ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
    

@end
