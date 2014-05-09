//
//  CameraAlarmSettingViewController.m
//  BabyWith
//
//  Created by wangminhong on 13-7-24.
//  Copyright (c) 2013年 shancheng.com. All rights reserved.
//

#import "CameraAlarmSettingViewController.h"

@implementation CameraAlarmSettingViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    UIView *view = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] applicationFrame].size.height)];
    view.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
    self.view = view;
    [view release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航条设置
    {
        //左导航--我的视频我的家主选择页面
        UIImage *navLittleImage = [UIImage imageNamed:@"goBack.png"];
        UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 27)];
        [navButton setBackgroundImage:navLittleImage forState:UIControlStateNormal];
        navButton.tag = 2;
        [navButton addTarget:self action:@selector(ShowPrePage) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView: navButton];
        self.navigationItem.leftBarButtonItem = leftItem;
        
        [leftItem release];
        [navButton release];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
