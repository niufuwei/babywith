//
//  SettingsViewController.h
//  BabyAgent
//
//  Created by Fly on 14-3-12.
//  Copyright (c) 2014年 lifei. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *userInfo;
@property (retain, nonatomic) IBOutlet UIButton *logOutBtn;
@property (retain, nonatomic) UITableView *tableList;

@property (nonatomic,retain) NSArray *cellNameArr;
@property (nonatomic,assign) int messageCount;

- (IBAction)logOut:(id)sender;
@end
