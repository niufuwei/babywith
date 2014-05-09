//
//  CameraParamSettingViewController.m
//  BabyWith
//
//  Created by wangminhong on 13-7-24.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "CameraParamSettingViewController.h"
#import "SettingCell.h"
#import "Configuration.h"
#import "MainAppDelegate.h"
#import "CameraSettingViewController.h"

@implementation CameraParamSettingViewController

- (id)initWithDelegate:(NSObject *)delegate
{
    self = [super init];
    if (self) {
        // Custom initialization
        _delegate = delegate;
    }
    return self;
}

-(void)loadView{
    UIView *view = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] applicationFrame].size.height)];
    view.backgroundColor = babywith_background_color;
    self.view = view;
    [view release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航条设置
    {
        //左导航-主选择页面
        UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        navButton.tag = 1;
        [navButton setImage:[UIImage imageNamed:@"goBack.png"] forState:UIControlStateNormal];
        [navButton setImage:[UIImage imageNamed:@"goBack_highlight.png"] forState:UIControlStateHighlighted];
        [navButton addTarget:self action:@selector(ShowPrePage) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView: navButton];
        self.navigationItem.leftBarButtonItem = leftItem;
        
        [navButton release];
        [leftItem release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"视频质量设置";
        titleLabel.textColor = babywith_text_background_color;
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        [titleLabel release];
    }
    _selectedRow = 0;
    
    _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    _settingTableView.dataSource = self;
    _settingTableView.delegate = self;
    _settingTableView.backgroundView = nil;
    _settingTableView.backgroundColor = [UIColor clearColor];
    _settingTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:_settingTableView];
    
    int quality = [[[appDelegate.appDefault objectForKey:[[appDelegate.appDefault objectForKey:@"Device_selected"] objectForKey:@"device_id"]] objectForKey:@"quality"] integerValue];
    
    _selectedRow = 512/quality -1;
    
    if (_selectedRow == 3) {
        _selectedRow = 2;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingCell *cell = (SettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.tag == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.tag = 1;
        
        SettingCell *releaseCell = (SettingCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0]];
        releaseCell.accessoryType = UITableViewCellAccessoryNone;
        releaseCell.tag = 0;
        
        _selectedRow = indexPath.row;
        int quality = 0;
        if (_selectedRow == 0) {
            quality = 512;
        }else{
            quality = 512/(_selectedRow*2);
        }
        
        MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithView:self.view];
        indicator.labelText = @"视频质量已设置。";
        indicator.mode = MBProgressHUDModeText;
        [self.view addSubview:indicator];
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
            [indicator release];
            [(CameraSettingViewController *)_delegate ChangeQuality:quality];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"relativeSetting";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.textLabel.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = babywith_text_background_color;
    }
    
    if (indexPath.row == _selectedRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.tag = 1;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.tag = 0;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"高清";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"普通";
    }else{
        cell.textLabel.text = @"一般";
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
        default:
            break;
    }
    return 0;
}

-(void)viewDidUnload{
    
    [_settingTableView release];
    _settingTableView = nil;
}

-(void)dealloc{
    
    [_settingTableView release];
    
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    //float sysVer =[[[UIDevice currentDevice] systemVersion] floatValue];
    
    
}

@end
