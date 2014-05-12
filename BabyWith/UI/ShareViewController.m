//
//  ShareViewController.m
//  BabyAgent
//
//  Created by Fly on 14-3-12.
//  Copyright (c) 2014年 lifei. All rights reserved.
//

#import "ShareViewController.h"
#import "MainAppDelegate.h"
#import "DeviceConnectManager.h"
#import "SetNickNameViewController.h"
#import "ShareDeviceViewController.h"
#import "WebInfoManager.h"
@interface ShareViewController ()

@end

@implementation ShareViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self titleSet:@"分享"];
    
    // Do any additional setup after loading the view from its nib.
    
    _shareListTable = [[UITableView alloc] init];
    _label = [[UILabel alloc] init];
    _nextStepBtn = [[UIButton alloc] init];
    
    
    _shareListTable.delegate = self;
    _shareListTable.dataSource = self;
    _shareListTable.scrollEnabled = NO;
    _shareListTable.backgroundColor = [UIColor clearColor];
    _shareListTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    
    
    
}


-(void)nextStep
{

    int i =  [appDelegate.deviceConnectManager getDeviceCount];
    NSLog(@"设备一共有%d个",i);
    for (int j = 0; j< i; j++)
    {
        
        NSLog(@"indexPath  %@",[NSIndexPath indexPathForRow:j inSection:0]);
        
        
        if ([_shareListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]].imageView.image == [UIImage imageNamed:@"多选选中.png"] )
        {
            
            
            _hasSelect = YES;
            [appDelegate.selectDeviceArr addObject:[appDelegate.deviceConnectManager getDeviceInfoAtRow:j]];
            
            NSLog(@"qqqqqqq%@",[appDelegate.deviceConnectManager getDeviceInfoAtRow:j]);

        }
        
    }
    
    
    NSLog(@"选中的设备的数量是%d",[appDelegate.selectDeviceArr count]);
    
    
    //有选中的话根据数据库有没有昵称进入不同的页面
    if (_hasSelect == YES)
    {
        if ([appDelegate.appDefault objectForKey:@"Appel_self"])
        {
            _hasSelect = NO;
            //[appDelegate.selectDeviceArr removeAllObjects];
            ShareDeviceViewController *vc = [[ShareDeviceViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            _hasSelect = NO;
            //[appDelegate.selectDeviceArr removeAllObjects];
            SetNickNameViewController *vc = [[SetNickNameViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        //否则提示至少选择一台设备
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithWindow:window];
        indicator.labelText = @"至少选择一台设备";
        indicator.mode = MBProgressHUDModeText;
        [window addSubview:indicator];
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
        }];
        
    
    }
    
    

}
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];
    
    [_shareListTable reloadData];
    
    if ([self tableView:_shareListTable numberOfRowsInSection:0] == 0)
    {
        _nextStepBtn.hidden = YES;
        
        _shareListTable.frame = CGRectMake(0, 0, 0, 0);
        
        
        _label.frame = CGRectMake(20, 200, 280, 60);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text =@"您还没有绑定设备";
        _label.hidden = NO;
        _label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_label];
        
    }
    else
    {
        _label.hidden = YES;
        
        _shareListTable.frame = CGRectMake(0,0, 320, [self tableView:_shareListTable numberOfRowsInSection:0]* 80);
        NSLog(@"tableview的高度是%f",_shareListTable.frame.size.height);
                
        
        _nextStepBtn.frame = CGRectMake(35, _shareListTable.frame.size.height +50, 250, 40);
        [self configurationForGreenButton:_nextStepBtn];
        [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        _nextStepBtn.hidden = NO;
        [self.view addSubview:_nextStepBtn];
    }
    [self.view addSubview:_shareListTable];

    
    //NSLog(@"拥有的设备数量是%d",[appDelegate.deviceConnectManager getDeviceCount]);

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [appDelegate.deviceConnectManager getDeviceCount];
    NSLog(@"拥有的设备数量是%d",[appDelegate.deviceConnectManager getDeviceCount]);

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier = @"ShareListIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    NSInteger row = [indexPath row];
    cell.textLabel.text = [[appDelegate.deviceConnectManager getDeviceInfoAtRow:row] objectForKey:@"name"];
    cell.imageView.frame = CGRectMake(10, 23, 20, 20);
    cell.imageView.image = [UIImage imageNamed:@"多选未选中.png"];
    NSLog(@"hdxuwihdwiubgwibdg");
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell * cell = [_shareListTable cellForRowAtIndexPath:indexPath];
    
    if (cell.imageView.image == [UIImage imageNamed:@"多选未选中.png"])
    {
        cell.imageView.image = [UIImage imageNamed:@"多选选中.png"];
        
        
        

        
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"多选未选中.png"];
        

    
    }
   

    
}


- (void)viewDidUnload {
    [self setShareListTable:nil];
    [super viewDidUnload];
}
@end
