//
//  MessagViewController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-3-19.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "MessagViewController.h"
#import "MainAppDelegate.h"
#import "WebInfoManager.h"
#import "MessageCell.h"
@interface MessagViewController ()

@end

@implementation MessagViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self titleSet:@"系统消息"];
    
    
    
    if ([appDelegate.systemMessageArray count] == 0)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 280, 60)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text =@"暂时没有系统消息";
        label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
    }
    
    
    
    
    _messageArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    
    _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44)];
    _messageTableView.dataSource = self;
    _messageTableView.delegate = self;
    _messageTableView.backgroundColor = [UIColor clearColor];
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_messageTableView];
    
    _messageTableView.frame = CGRectMake(0, 0, 320, 100.0*[self tableView:_messageTableView numberOfRowsInSection:0]);
    
    
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];
    [_messageArray addObjectsFromArray:appDelegate.systemMessageArray];
    [_messageTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark -tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [appDelegate.systemMessageArray count];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 100;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    static NSString *identifier = @"Message_identifier";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.textLabel.text =[NSString stringWithFormat:@"%@ 将他使用的设备 %@ 分享给你",[[appDelegate.systemMessageArray objectAtIndex:indexPath.row] objectAtIndex:0],[[_messageArray objectAtIndex:indexPath.row] objectAtIndex:1]];
    cell.detailTextLabel.text = [[_messageArray objectAtIndex:indexPath.row] lastObject];
    
    return cell;
}


















@end
