//
//  SetNickNameViewController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-3-18.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "SetNickNameViewController.h"
#import "ShareDeviceViewController.h"
#import "MainAppDelegate.h"
#import "WebInfoManager.h"
#import "Activity.h"
@interface SetNickNameViewController ()
{

    Activity *activity;

}
@end

@implementation SetNickNameViewController

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
    
    _nextBtn= [[UIButton alloc] initWithFrame:CGRectMake(59, 107, 202, 30)];
    [_nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:babywith_text_background_color forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:babywith_green_color];
    [_nextBtn.layer setMasksToBounds:YES];
    [_nextBtn.layer setCornerRadius:5.0];
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    
    
    activity = [[Activity alloc] initWithActivity:self.view];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setNickNameField:nil];
    [self setNextBtn:nil];
    [super viewDidUnload];
}
- (void)nextAction:(id)sender {
    
    
    if ([_nickNameField.text isEqualToString:@""])
    {
        [self makeAlert:@"昵称不可为空"];
        return;
    }
    else
    {
        [activity start];
        BOOL result = [appDelegate.webInfoManger UserModifyAppelUsingAppel:_nickNameField.text Toekn:[appDelegate.appDefault objectForKey:@"Token"]];
        if (result)
        {
            [activity stop];
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
            MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithWindow:window];
            indicator.labelText = @"修改成功";
            indicator.mode = MBProgressHUDModeText;
            [window addSubview:indicator];
            [indicator showAnimated:YES whileExecutingBlock:^{
                sleep(1.2);
            } completionBlock:^{
                [indicator removeFromSuperview];
                ShareDeviceViewController *shareVC = [[ShareDeviceViewController alloc] init];
                [self.navigationController pushViewController:shareVC animated:YES];
            }];
        }
        else
        {            [activity stop];

            [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
        }
        
    }
    
    
}






@end
