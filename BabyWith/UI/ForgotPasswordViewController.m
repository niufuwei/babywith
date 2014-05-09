//
//  ForgotPasswordViewController.m
//  BabyWith_
//
//  Created by shanchen on 14-3-12.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "NextForgotPasswordViewController.h"
#import "MainAppDelegate.h"
@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

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
    
    [self titleSet:@"找回密码"];
    [self configurationForGreenButton:_nextButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    }


- (IBAction)next:(id)sender {
    
    NSString *configStr = [_phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int phone_flag = [self checkTel:configStr Type:1];
    if (phone_flag == 0) {
        return;
    }
    [appDelegate.appDefault setObject:_phoneTF.text forKey:@"Username"];
    NextForgotPasswordViewController *vc = [[NextForgotPasswordViewController alloc]init];
    vc.configPhoneNum = configStr;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
