//
//  ShareDeviceViewController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-3-18.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "ShareDeviceViewController.h"
#import "WebInfoManager.h"
#import "MainAppDelegate.h"
@interface ShareDeviceViewController ()

@end

@implementation ShareDeviceViewController

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
     _submit= [[UIButton alloc] initWithFrame:CGRectMake(66, 123, 188, 30)];
    [_submit setTitle:@"提交" forState:UIControlStateNormal];
    [_submit setTitleColor:babywith_text_background_color forState:UIControlStateNormal];
    [_submit setBackgroundColor:babywith_green_color];
    [_submit.layer setMasksToBounds:YES];
    [_submit.layer setCornerRadius:5.0];
    [_submit addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submit];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [self setPhoneNumber:nil];
    [self setSubmit:nil];
    [super viewDidUnload];
}
- (void)submitBtn:(id)sender
{
    _submit.enabled = NO;
    self.phoneNumber.text = [self.phoneNumber.text
                            stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //检查电话号码是否符合规格
    int phone_email_flag = [self checkTel:self.phoneNumber.text Type:1];
    NSLog(@"%d",phone_email_flag);
    if (phone_email_flag < 0 )
    {
        return;
    }
    //设备ID以逗号隔开
    NSString * deviceID;
    int i = [appDelegate.selectDeviceArr count];
    deviceID =  [[appDelegate.selectDeviceArr objectAtIndex:0] objectForKey:@"device_id"];  //一开始始终是取得第一个
     if(i > 1 )
     {
        for (int m = 1; m < i; m++)
        {
            deviceID = [NSString stringWithFormat:@"%@,%@",deviceID,[[appDelegate.selectDeviceArr objectAtIndex:m] objectForKey:@"device_id"]];
        }
    
    
    }
    
    

    BOOL result = [appDelegate.webInfoManger UserShareDeviceUsingDeviceID:deviceID Phone:_phoneNumber.text Token:[appDelegate.appDefault objectForKey:@"Token"] PhoneType:@"2"];
     if (result)
    {
        
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithWindow:window];
        indicator.labelText = @"分享成功";
        indicator.mode = MBProgressHUDModeText;
        [window addSubview:indicator];
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
            
            int i = [appDelegate.selectDeviceArr count];
            NSLog(@"选择的设备的数量是%d",i);
            
            
            for (int n = 1; n <= i; n++)
            {
                //把号码添加到数组中,有多个设备的话就对应多个数组
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:1];
                [array addObject:self.phoneNumber.text];
                
                NSLog(@"这里走了没");
                //如果这个key不存在，就创建这个key
                if (![appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@_number",[[appDelegate.selectDeviceArr objectAtIndex:n - 1] objectForKey:@"device_id"]]])
                {   //第一次创建的时候直接添加就行
                    [appDelegate.appDefault setObject:array forKey:[NSString stringWithFormat:@"%@_number",[[appDelegate.selectDeviceArr objectAtIndex:n - 1] objectForKey:@"device_id"]]];
                    NSLog(@"分享人员的名单是 %@",[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@_number" ,[[appDelegate.selectDeviceArr objectAtIndex:n-1] objectForKey:@"device_id"]]]);
                }
                else//如果对应的key里面有值(array),那就往这个array里面添加
                {
                    NSMutableArray *array1 =[[NSMutableArray alloc] initWithArray: [appDelegate.appDefault arrayForKey:[NSString stringWithFormat:@"%@_number",[[appDelegate.selectDeviceArr objectAtIndex: n -1] objectForKey:@"device_id"]]]];
                    //把array里面的所有元素添加到新的array1里面
                    int j = [array count];
                    for (int s =1;s <= j; s++)
                    {
                        for (NSString * number in array1)
                        {
                            //号码不相同才添加进去
                            if (![number isEqualToString:(NSString *)[array objectAtIndex:s - 1 ]])
                            {
                                [array1 addObject:[array objectAtIndex:s - 1 ]];
                            }
                            
                        }
                        
                    }
                    
                    NSArray *array2 = [NSArray arrayWithArray:array1];
                    [appDelegate.appDefault setObject:array2 forKey:[NSString stringWithFormat:@"%@_number",[[appDelegate.selectDeviceArr objectAtIndex: n - 1] objectForKey:@"device_id"]]];
                    
                    
                    NSLog(@"分享人员的名单是 %@",[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@_number",[[appDelegate.selectDeviceArr objectAtIndex:n -1] objectForKey:@"device_id"]]]);
                }
            }
            
            _submit.enabled = YES;
            [appDelegate.selectDeviceArr removeAllObjects];
            [NOTICECENTER postNotificationName:@"MoveToMain" object:nil];
        }];
        
    }
    else
    {
        _submit.enabled = YES;

        [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
        
    }
   
    
}






@end
