//
//  LoginRegisterViewController.m
//  BabyWith_
//
//  Created by shanchen on 14-3-12.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//
#import "WebInfoBinding.h"
#import "WebInfoManager.h"
#import "MainAppDelegate.h"
#import <AdSupport/ASIdentifierManager.h>
#import "HomeViewController.h"
#import "LoginRegisterViewController.h"
#import "Activity.h"
@interface LoginRegisterViewController ()
{

    Activity *activity;

}
@property (nonatomic) BOOL keyboardShowed;
@property (nonatomic,assign) BOOL agreeOrNot;


@end

@implementation LoginRegisterViewController

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
    [self titleSet:@"账号注册"];
    [self configurationForGreenButton:_registerButton];
    
    _agreeOrNot = NO;
    UIImageView *buttonImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    buttonImage.image = [UIImage imageNamed:@"notAgree.png"];
    buttonImage.tag = 2;
    [_agreeMentBtn addSubview:buttonImage];
    
    
    
    activity = [[Activity alloc] initWithActivity:self.view];
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
        self.view.frame = CGRectMake(0, 44+20, 320, kScreenHeight -44 -20);
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
        self.view.frame = CGRectMake(0, 44+20, 320, kScreenHeight -44 -20);
    } completion:^(BOOL finished) {
        _keyboardShowed = NO;
    }];
    
}

- (IBAction)startRegister:(id)sender {
    
    //校验手机号码
    
    NSString *phoneStr = [_phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *configStr = [_confirmTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int phone_email_flag = [self checkTel:phoneStr Type:1];
    if (phone_email_flag == 0) {
        return;
    }
    
    
    if ([configStr isEqualToString:phoneStr] && ![phoneStr isEqualToString:@""])
    {
        
        
        if (_agreeOrNot == YES)    //同意协议
        {
    //注册
    [appDelegate.appDefault setObject:babywith_gate_address forKey:@"BabyWith_address_api"];
    [self macAddressGet];
    
            [activity start];
    BOOL result = [appDelegate.webInfoManger UserRegisterUsingUser:phoneStr Vesting:@"86" RefistType:@"1" Password:@"" Mac:[appDelegate.appDefault objectForKey:@"Mac_self"]];
    
    if (result)
    {
        
        
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithWindow:window];
        indicator.labelText = @"注册成功";
        indicator.mode = MBProgressHUDModeText;
        [window addSubview:indicator];
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
            
            //登陆校验，发送消息到服务器
            BOOL result = [appDelegate.webInfoManger UserLoginUsingUsername:_phoneTF.text Password:@"" Version:ClientVersion Vesting:@"86" ClientType:@"2" DeviceToken:appDelegate.deviceToken];
            
            if (result)
            {
                [activity stop];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveToMain" object:nil];

            }
            
            
        }];
    }
    else
    {
        [activity stop];
        [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
    }
        }
        else
        {
            
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
            MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithWindow:window];
            indicator.labelText = @"请同意相关服务协议和隐私政策";
            indicator.mode = MBProgressHUDModeText;
            [window addSubview:indicator];
            [indicator showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                
                [indicator removeFromSuperview];
            }];
        
            
        
        
        }
    
    }
}

- (IBAction)agreeOrNot:(id)sender {
    if (_agreeOrNot == NO) {
        ((UIImageView *)[sender viewWithTag:2]).image = [UIImage imageNamed:@"agree.png"];
        
    } else {      
       ((UIImageView *)[sender viewWithTag:2]).image = [UIImage imageNamed:@"notAgree.png"];
      
    }
    _agreeOrNot = !_agreeOrNot;
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
