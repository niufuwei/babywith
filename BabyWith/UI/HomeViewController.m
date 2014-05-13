//
//  HomeViewController.m
//  BabyAgent
//
//  Created by Fly on 14-3-12.
//  Copyright (c) 2014年 lifei. All rights reserved.
//

#import "HomeViewController.h"
#import "CameraAddingViewController.h"
#import "DeviceConnectManager.h"
#import "MainAppDelegate.h"
#import "CameraPlayViewController.h"
#import "NewMessageViewController.h"
#import "CommonProblemsGuideViewController.h"
#include "Configuration.h"
@interface HomeViewController ()

@property (strong ,nonatomic) NSMutableArray *deviceArray;

@end

@implementation HomeViewController

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
    _homeTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 50) style:UITableViewStyleGrouped];
    _homeTableView1.delegate = self;
    _homeTableView1.dataSource = self;
    _homeTableView1.backgroundView = nil;
    self.view.backgroundColor = babywith_background_color;
    [self.view addSubview:_homeTableView1];
    
    

    
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 82, 51)];
    [navButton setImage:[UIImage imageNamed:@"添加设备"] forState:UIControlStateNormal];
    [navButton addTarget:self action:@selector(bind:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView: navButton];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    [self titleSet:@"主页"];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMessageCount:) name:@"changeCount" object:nil];
    
}
-(void)changeMessageCount:(NSNotification*)NSNotification
{

    [_homeTableView1 reloadData];
    


}
- (void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"view will appear");
    //获取设备列表，并且刷新数据
    self.deviceArray = [appDelegate.deviceConnectManager getDeviceInfoList];
    NSLog(@"self.device is %@",self.deviceArray);
    [_homeTableView1 reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//进入到添加设备页面
- (void)bind:(UIBarButtonItem *)item
{
    CameraAddingViewController *vc = [[CameraAddingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        NSLog(@"第三个section是%d",[self.deviceArray count]);
        return [self.deviceArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier1 = @"cell1";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (!cell1) {
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
    }
    
    
    static NSString *cellIdentifier2 = @"cell2";
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    if (!cell2) {
        cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
    }
    
    static NSString *cellIdentifier3 = @"cell3";
    UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    if (!cell3) {
        cell3 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
    }

    
    if (indexPath.section == 0)
      {
        cell1.textLabel.text = @"常见问题指南";
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
          cell1.backgroundColor = babywith_background_color;
        return cell1;
    }
    else if (indexPath.section == 1)
    {
        cell2.textLabel.text = @"新分享设备";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(250, 10, 24, 24)];
        label.text =[NSString stringWithFormat:@"%lu",(unsigned long)[appDelegate.messageArray count]];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"信息提示背景.png"]];
        cell2.backgroundColor = babywith_background_color;
        [cell2 addSubview:label];

        cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([appDelegate.messageArray count] == 0)
        {
            label.hidden = YES;
        }
        else
        {
            label.hidden = NO;
        }
        return cell2;
    }
    else if (indexPath.section == 2)
    {
        cell3.textLabel.text = [[self.deviceArray  objectAtIndex: indexPath.row ]objectForKey:@"name"];
        cell3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell3.backgroundColor = babywith_background_color;

        return cell3;
    }
    
    return nil;
}



#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CommonProblemsGuideViewController *guideVC = [[CommonProblemsGuideViewController alloc] init];
        [self.navigationController pushViewController:guideVC animated:YES];
    }
   else if (indexPath.section == 1)
    {
        NewMessageViewController * newMessageVC = [[NewMessageViewController alloc] init];
        [self.navigationController pushViewController:newMessageVC animated:YES];
    }
    else if (indexPath.section == 2)
    {
        
        NSLog(@"self.array is %@",self.deviceArray);
        
        
        [appDelegate.appDefault setObject:[self.deviceArray objectAtIndex:indexPath.row] forKey:@"Device_selected"];
        NSLog(@"存入的设备是%@",[appDelegate.appDefault objectForKey:@"Device_selected"]);
        CameraPlayViewController *vc = [[CameraPlayViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


@end
