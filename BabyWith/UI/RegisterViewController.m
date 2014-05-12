//
//  RegisterViewController.m
//  BabyWith
//
//  Created by shanchen on 14-3-11.
//  Copyright (c) 2014年 shancheng.com. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "WebInfoBinding.h"
#import "WebInfoManager.h"
#import "MainAppDelegate.h"
#import <AdSupport/ASIdentifierManager.h>
#import "CameraAddingViewController.h"
#import "HaveSharedDeviceViewController.h"
#import "Activity.h"

@interface RegisterViewController ()
{

    Activity *activity ;

}

@property (nonatomic) BOOL keyboardShowed;

@end

@implementation RegisterViewController

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
    [self titleSet:@"babywith"];
    [self configurationForGreenButton:_registerButton];
    
   
    activity = [[Activity alloc] initWithActivity:self.view];
    
    
    NSLog(@"是否是第一次登陆%@",[USRDEFAULT objectForKey:@"First_use_flag"]);


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    }

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_keyboardShowed) {
        return;
    }
    [_phoneTF resignFirstResponder];
    [_confirmTF resignFirstResponder];
    
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
        self.view.frame = CGRectMake(0, -100, 320, kScreenHeight -44 -20);
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
        self.view.frame = CGRectMake(0, 0, 320, kScreenHeight -44 -20);
    } completion:^(BOOL finished) {
        _keyboardShowed = NO;
    }];
    
}

- (IBAction)skipRegistration:(UIButton *)sender {
    LoginViewController *vc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    //[NOTICECENTER postNotificationName:@"MoveToMain" object:nil];
}

- (IBAction)startRegister:(UIButton *)sender {
    //校验手机号码

    NSString *phoneStr = [_phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int phone_email_flag = [self checkTel:phoneStr Type:1];
    if (phone_email_flag == 0) {
        return;
    }
    if (![phoneStr isEqualToString:[_confirmTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        [self makeAlert:@"确认号码不一致"];
        return;
    }
    //注册
    [self macAddressGet];
    
    
    [activity start];
    
    BOOL result = [appDelegate.webInfoManger UserRegisterUsingUser:phoneStr Vesting:@"86" RefistType:@"1" Password:@"" Mac:[appDelegate.appDefault objectForKey:@"Mac_self"]];

    
    //    BOOL result = [appDelegate.webInfoManger UserRegisterUsingUser:userTextField.text Checkcode:[appDelegate.appDefault objectForKey:@"Phone_checkcode"] Password:passwdTextField.text Mac:[appDelegate.appDefault objectForKey:@"Mac_self"] RegistType:[NSString stringWithFormat:@"%d",phone_email_flag] Vesting:@"86"];
        if (result) {
            
            
            [activity stop];
            
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
            MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithWindow:window];
            indicator.labelText = @"注册成功。";
            indicator.mode = MBProgressHUDModeText;
            [window addSubview:indicator];
            [indicator showAnimated:YES whileExecutingBlock:^{
                sleep(1.2);
            } completionBlock:^{
                [indicator removeFromSuperview];
                [USRDEFAULT setInteger:1 forKey:@"First_use_flag"];
                if (result) {
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"有分享设备" otherButtonTitles:@"没有分享设备", nil];
//                    alert.tag = 1;
//                    [alert show];
                    
                    
                    //登陆校验，发送消息到服务器
                    BOOL result = [appDelegate.webInfoManger UserLoginUsingUsername:_phoneTF.text Password:@"" Version:ClientVersion Vesting:@"86" ClientType:@"2" DeviceToken:appDelegate.deviceToken];
                    
                    if (result)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveToMain" object:nil];
                        
                    }
                    

                }else{ //错误判断 如果是版本更新TODO

                    [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
                }
            }];
        }else{
            
            

            [activity stop];
            
            [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
        }
    
}
//// 注册账号
//"/api/user/Regist1";
//参数：
//"user", 填写的手机号);
//"vesting", 国家码；
//"refist_type", 手机端类型Android1，ios2；
//"pass",密码；
//"mac", mac地址);
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag != 1)
    {
        return;
    }
    switch (buttonIndex)
    {
        case 0:
        {
            HaveSharedDeviceViewController *vc = [[HaveSharedDeviceViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 1:
        {
            CameraAddingViewController *vc = [[CameraAddingViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            //self.navigationItem.backBarButtonItem.tintColor = babywith_orange_color;
            //[NOTICECENTER postNotificationName:@"MoveToMain" object:Nil];
        }
            break;
        default:
            break;
    }
}

- (void)macAddressGet
{
    //本机MAC地址
    if (IOS7) {
        [appDelegate.appDefault setValue:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] forKey:@"Mac_self"];
    }else{
        NSString *mac = [self getLocalMacAddress];
        [appDelegate.appDefault setValue:mac forKey:@"Mac_self"];
    }
}
@end
