//
//  SharedPersonsViewController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-4-23.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "SharedPersonsViewController.h"
#import "MainAppDelegate.h"


@implementation SharedPersonsViewController

- (id)initWithDeviceID:(NSString *)deviceID
{
    self = [super init];
    if (self) {
        self.deviceID = deviceID;
    }
        return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self titleSet:@"分享人员"];
    
    
    // Do any additional setup after loading the view.
    _sharedPersonTableView =  [[UITableView alloc] init];
    _sharedPersonTableView.delegate = self;
    _sharedPersonTableView.dataSource = self;
    _sharedPersonTableView.backgroundColor = [UIColor clearColor];
    _label = [[UILabel alloc] init];
    
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];
    [_sharedPersonTableView reloadData];
    
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[appDelegate.appDefault arrayForKey:[NSString stringWithFormat:@"%@_number",self.deviceID]]];
    NSLog(@"arr is %d",[arr count]);
    
    
    if ([arr count] == 0)
    {
        
        _sharedPersonTableView.frame = CGRectMake(0, 0, 0, 0);
        _label.frame = CGRectMake(20, 200, 280, 60);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text =@"您还没有将设备分享给别人";
        _label.hidden = NO;
        [self.view addSubview:_label];
       
    }
    else
    {
        _label.hidden = YES;
        _sharedPersonTableView.frame = CGRectMake(0, 0, 320, 60.0*[self tableView:_sharedPersonTableView numberOfRowsInSection:0]);
        if (60.0*[self tableView:_sharedPersonTableView numberOfRowsInSection:0] > self.view.frame.size.height - 64)
        {
            _sharedPersonTableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height );
        }
        
        
    }
    [self.view addSubview:_sharedPersonTableView];


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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[appDelegate.appDefault arrayForKey:[NSString stringWithFormat:@"%@_number",self.deviceID]] count];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60.0;


}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier  = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [[appDelegate.appDefault arrayForKey:[NSString stringWithFormat:@"%@_number",self.deviceID]] objectAtIndex:indexPath.row];
    cell.backgroundColor = babywith_background_color;
    return cell;
}
@end
