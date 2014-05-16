//
//  ChangePasswordViewController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-3-18.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UIViewController+Alert.h"
#import "MainAppDelegate.h"
#import "WebInfoManager.h"
#import "Activity.h"
@interface ChangePasswordViewController ()


{


    Activity *activity;
}


@property (nonatomic) BOOL keyboardShowed;

@end

@implementation ChangePasswordViewController

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
    
    
     _firstBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 60, 92, 30)];
    [_firstBtn setTitle:@"显示密码" forState:UIControlStateNormal];
    [_firstBtn setTitleColor:babywith_text_background_color forState:UIControlStateNormal];
    [_firstBtn setBackgroundColor:babywith_green_color];
    [_firstBtn.layer setMasksToBounds:YES];
    [_firstBtn.layer setCornerRadius:5.0];
    [_firstBtn addTarget:self action:@selector(showPass1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_firstBtn];
    
    
    _secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 108, 92, 30)];
    [_secondBtn setTitle:@"显示密码" forState:UIControlStateNormal];
    [_secondBtn setTitleColor:babywith_text_background_color forState:UIControlStateNormal];
    [_secondBtn setBackgroundColor:babywith_green_color];
    [_secondBtn.layer setMasksToBounds:YES];
    [_secondBtn.layer setCornerRadius:5.0];
    [_secondBtn addTarget:self action:@selector(showPass2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_secondBtn];
    
    
    _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(56, 199, 201, 30)];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:babywith_text_background_color forState:UIControlStateNormal];
    [_submitBtn setBackgroundColor:babywith_green_color];
    [_submitBtn.layer setMasksToBounds:YES];
    [_submitBtn.layer setCornerRadius:5.0];
    [_submitBtn addTarget:self action:@selector(submitChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    
    
    
    
   
    
    
    _oldPass.delegate = self;
    _oldPass.secureTextEntry = YES;
    _freshPass.delegate = self;
    _freshPass.secureTextEntry = YES;
    
    
    
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
    [_oldPass resignFirstResponder];
    [_freshPass resignFirstResponder];
    _keyboardShowed = NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_keyboardShowed) {
        return;
    }
    
    
        _keyboardShowed = YES;
    
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_keyboardShowed) {
        return;
    }
   _keyboardShowed = NO;
    
    
}

- (void)showPass1:(id)sender {
    
    if (_oldPass.secureTextEntry == NO)
    {
        _oldPass.secureTextEntry = YES;
        [_firstBtn setTitle:[NSString stringWithFormat:@"显示密码"] forState:UIControlStateNormal];

    }
    else
    {
        _oldPass.secureTextEntry = NO;
        [_firstBtn setTitle:[NSString stringWithFormat:@"隐藏密码"] forState:UIControlStateNormal];
        
    }
    
    
    
}

- (void)showPass2:(id)sender {
    
    if (_freshPass.secureTextEntry == NO)
    {
        _freshPass.secureTextEntry = YES;
        [_secondBtn setTitle:[NSString stringWithFormat:@"显示密码"] forState:UIControlStateNormal];

    }
    else
    {
        _freshPass.secureTextEntry = NO;
        [_secondBtn setTitle:[NSString stringWithFormat:@"隐藏密码"] forState:UIControlStateNormal];

    }
}

- (void)submitChange:(id)sender {
    
    _oldPass.text = [_oldPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _freshPass.text = [_freshPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //原来没有设置密码的话就是@"",可以不填写
    if (![_oldPass.text isEqualToString:[appDelegate.appDefault objectForKey:@"Password"]]) {
        [self makeAlert:@"原密码错误"];
        return;
    }
    
    if ([_freshPass.text length]<6 ||[_freshPass.text length]>12) {
        [self makeAlert:@"密码长度限制为6-12位"];
        return;
    }
    
    [activity start];
    BOOL result = [appDelegate.webInfoManger UserModifyPasswordUsingToken:[appDelegate.appDefault objectForKey:@"Token"] Password:_oldPass.text NewPassword:_freshPass.text];
    if (result)
    {
        [activity stop];
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithWindow:window];
        indicator.labelText = @"密码修改成功";
        indicator.mode = MBProgressHUDModeText;
        [window addSubview:indicator];
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
            _oldPass.text = @"";
            _freshPass.text = @"";
            [NOTICECENTER postNotificationName:@"MoveToMain" object:nil];
        }];
        
    }
    else
    {        [activity stop];

        [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
    }
    
    
    
}





- (void)viewDidUnload {
    [self setOldPass:nil];
    [self setFreshPass:nil];
    [self setFirstBtn:nil];
    [self setSecondBtn:nil];
    [self setSubmitBtn:nil];
    [super viewDidUnload];
}











@end
