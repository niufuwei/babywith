//
//  SettingsViewController.m
//  BabyAgent
//
//  Created by Fly on 14-3-12.
//  Copyright (c) 2014年 lifei. All rights reserved.
//

#import "SettingsViewController.h"
#import "MainAppDelegate.h"
#import "ListCell.h"
#import "WebInfoManager.h"


#import "ChaneNickNameViewController.h"
#import "ChangePasswordViewController.h"
#import "MessagViewController.h"
#import "AboutUsViewController.h"
#import "SetPasswordViewController.h"

#import "MessageProcess.h"

#import "Activity.h"
@interface SettingsViewController ()
{


    Activity *activity;

}
@end

@implementation SettingsViewController

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
    
    [self titleSet:@"更多"];
    
    
    _userInfo.text = [NSString stringWithFormat:@"登录号:%@",[appDelegate.appDefault objectForKey:@"Username"]];
    NSLog(@"登陆时候的用户是%@",[appDelegate.appDefault objectForKey:@"Username"]);
    
    
    _cellNameArr = [[NSArray alloc] initWithObjects:@"修改昵称",@"修改密码",@"系统消息",@"关于我们", nil];
    
    
    _tableList = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, 320, 200)];
    _tableList.delegate = self;
    _tableList.dataSource = self;
    _tableList.backgroundColor = [UIColor clearColor];
    _tableList.scrollEnabled = NO;
    [self.view addSubview:_tableList];
    _tableList.frame = CGRectMake(0, 90, 320, [self tableView:_tableList numberOfRowsInSection:0]*[self tableView:_tableList heightForRowAtIndexPath:0]);
    activity = [[Activity alloc] initWithActivity:self.view];
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshMessageCount:) name:@"RefreshMessageCount" object:nil] ;
   // [self performSelector:@selector(afterViewdidLoad) withObject:nil afterDelay:0];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{

    [self.tableList reloadData];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier = [[NSString alloc] initWithFormat:@"settingIdentifier"];
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.statusLabel.backgroundColor = [UIColor clearColor];
    }
    
    
    cell.textLabel.text = [_cellNameArr objectAtIndex:[indexPath row]];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"进入指向.png"]];
    
    
    //修改昵称和系统消息的cell稍有不同
    if ([indexPath row] == 0) {
        
        
        
        NSLog(@"昵称////////////////////%@",[appDelegate.appDefault objectForKey:@"Appel_self"]);
        if (![[appDelegate.appDefault objectForKey:@"Appel_self"]  isEqual: @""])
        {
            NSLog(@"昵称是%@",[appDelegate.appDefault objectForKey:@"Appel_self"]);
            cell.statusLabel.text = [NSString stringWithFormat:@"%@",[appDelegate.appDefault objectForKey:@"Appel_self"]];

        }
        else
        {
        
            cell.statusLabel.text = @"无";

        
        }
    }
    else if([indexPath row] == 2)
    {
        if ([appDelegate.systemMessageArray count] > 0)
        {
            
            cell.statusLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"信息提示背景.png"]];
            cell.statusLabel.textAlignment = NSTextAlignmentCenter;
            cell.statusLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[appDelegate.systemMessageArray count]];
        }
        else if([appDelegate.systemMessageArray count] == 0)
        {
          //[cell.statusLabel removeFromSuperview];
        }
    }
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChaneNickNameViewController *changeNick = [[ChaneNickNameViewController alloc] init];
    ChangePasswordViewController *changePass = [[ChangePasswordViewController alloc] init];
    MessagViewController *message = [[MessagViewController alloc ] init];
    AboutUsViewController *about = [[AboutUsViewController alloc] init];
    
    
    
    NSArray *arr = [NSArray arrayWithObjects:changeNick,changePass,message,about,nil];
    
    [self.navigationController pushViewController:[arr objectAtIndex:[indexPath row]] animated:YES];
    


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
   
    
}


- (void)viewDidUnload {
    [self setUserInfo:nil];
    [self setLogOutBtn:nil];
    [self setTableList:nil];
    [super viewDidUnload];
}
- (IBAction)logOut:(id)sender
{
    
    
    [activity start];
   BOOL result = [appDelegate.webInfoManger UserLogoutUsingToken:[appDelegate.appDefault objectForKey:@"Token"]];
    if(result)
    {
    
        [activity stop];
        
        if (![[appDelegate.appDefault objectForKey:@"Password"] isEqualToString:@""])
        {
            [appDelegate.appDefault setObject:@"" forKey:@"Username"];
            [appDelegate.appDefault setObject:@"" forKey:@"Password"];
            [NOTICECENTER postNotificationName:@"MoveToLogin" object:nil];
        }
        else
        {
            
            SetPasswordViewController *setPass = [[SetPasswordViewController alloc] init];
            [self.navigationController pushViewController:setPass animated:YES];
        }
    
        
    }
    else
    {
    
        [activity stop];

    [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
    
    }
    
    
}










@end
