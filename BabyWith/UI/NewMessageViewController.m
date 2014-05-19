//
//  NewMessageViewController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-4-22.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "NewMessageViewController.h"
#import "MainAppDelegate.h"
#import "NewMessageCell.h"
#import "WebInfoManager.h"
#import "DeviceConnectManager.h"
@interface NewMessageViewController ()

@end

@implementation NewMessageViewController

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
    // Do any additional setup after loading the view.
    _messageTableView = [[UITableView alloc] init];
    _messageTableView.delegate = self;
    _messageTableView.dataSource = self;
    _messageTableView.allowsSelection = NO;
    _messageTableView.backgroundColor = babywith_background_color;
    _label = [[UILabel alloc] init];
    
    [self setTitle:@"新分享设备"];
    
}
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];
    [_messageTableView reloadData];
    
    if ([appDelegate.messageArray count] == 0)
    {
        
        _messageTableView.frame = CGRectMake(0, 0, 0, 0);
        
        _label.frame = CGRectMake(20, 200, 280, 60);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text =@"您还没有设备分享信息";
        _label.hidden = NO;
        _label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_label];
    }
    else
    {
        _label.hidden = YES;
        if (130.0*[self tableView:_messageTableView numberOfRowsInSection:0] > self.view.frame.size.height - 66)
        {
            _messageTableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        }
        else
        {
        _messageTableView.frame = CGRectMake(0, 0, 320, 130.0*[self tableView:_messageTableView numberOfRowsInSection:0]);

        }
    }
    [self.view addSubview:_messageTableView];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection %d",[appDelegate.messageArray count]);

   return  [appDelegate.messageArray count];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier = @"NewMessageIdentifier";
    
    NewMessageCell *cell = (NewMessageCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewMessageCell1" owner:self options:nil];
       cell = [nib objectAtIndex:0];
    }
    
    
    cell.messageLabel.text = [NSString stringWithFormat:@"%@ ",[appDelegate.appDefault objectForKey:@"alert"]];
    
   
    
    [cell.agreeShareBtn addTarget:self action:@selector(agreeShare:) forControlEvents:UIControlEventTouchUpInside];
    [cell.refuseShareBtn addTarget:self action:@selector(refuseShare:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 130.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;

}


#pragma mark shareFunction

-(void)agreeShare:(UIButton *)btn
{
    NSLog(@"同意分享1");
    UITableViewCell *cell = (UITableViewCell *)[btn superview];
    NSIndexPath *indexPath = [self.messageTableView indexPathForCell:cell];
    
    NSString *IDMer = [NSString stringWithFormat:@"%@",[appDelegate.messageArray objectAtIndex:indexPath.row] ];
    
    
    NSLog(@"iiiiiiiiiiiiii%@",IDMer);
    if ([appDelegate.webInfoManger UserAgreeAddDeviceUsingIDMer:IDMer Toekn:[appDelegate.appDefault objectForKey:@"Token"]])
    {
        NSLog(@"分享成功");
        [appDelegate.messageArray removeObjectAtIndex:indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
    }
     else
    {
    
        [self makeAlert:@"同意分享出错"];
    
        
    }



}
 -(void)refuseShare:(UIButton *)btn
    
{

    NSLog(@"拒绝别人的分享");
    UITableViewCell *cell = (UITableViewCell *)[btn superview];
    NSIndexPath *indexPath = [self.messageTableView indexPathForCell:cell];
    [appDelegate.messageArray removeObjectAtIndex:indexPath.row];
    [self.messageTableView reloadData];


}








@end
