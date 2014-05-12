//
//  SetPasswordViewController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-3-19.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "MainAppDelegate.h"
#import "WebInfoManager.h"
#import "Activity.h"
@interface SetPasswordViewController ()
{

    Activity *activity;


}
@end

@implementation SetPasswordViewController

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
    _passwordField.secureTextEntry = YES;
    [self configurationForGreenButton:_hidePass];
    [self configurationForGreenButton:_submit];
    
    activity = [[Activity alloc] initWithActivity:self.view];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


- (void)viewDidUnload {
    [self setPasswordField:nil];
    [self setHidePass:nil];
    [self setSubmit:nil];
    [super viewDidUnload];
}


- (IBAction)hidePass:(id)sender {
    
    if (_passwordField.secureTextEntry == YES) {
        _passwordField.secureTextEntry = NO;
        _hidePass.titleLabel.text = [NSString stringWithFormat:@"显示密码"];
    } else {
        _passwordField.secureTextEntry = YES;
        _hidePass.titleLabel.text = [NSString stringWithFormat:@"隐藏密码"];
    }
    
    
    
}

- (IBAction)submitPass:(id)sender
{
    
    
    _passwordField.text = [_passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    
    
    if ([_passwordField.text length]<6 ||[_passwordField.text length]>12) {
        [self makeAlert:@"密码长度限制为6-12位"];
        return;
    }
    
    
    [activity start];
    BOOL result = [appDelegate.webInfoManger UserModifyPasswordUsingToken:[appDelegate.appDefault objectForKey:@"Token"] Password:@"" NewPassword:_passwordField.text];
    if (result){
        
        [activity stop];
        
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithWindow:window];
        indicator.labelText = @"密码设置成功";
        indicator.mode = MBProgressHUDModeText;
        [window addSubview:indicator];
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
            
            _passwordField.text = @"";
            [NOTICECENTER postNotificationName:@"MoveToLogin" object:nil];
        }];
        
    }else{
        
        [activity stop];

        [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
    }
    
    
    
}
















@end
