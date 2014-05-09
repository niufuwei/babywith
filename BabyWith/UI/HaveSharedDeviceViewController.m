//
//  HaveSharedDeviceViewController.m
//  BabyWith
//
//  Created by shanchen on 14-3-15.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "HaveSharedDeviceViewController.h"
#import "CameraAddingViewController.h"


@interface HaveSharedDeviceViewController ()

@end

@implementation HaveSharedDeviceViewController

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
    [self rightButtonItemWithImageName:@"skip"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)skip:(UIButton *)button
{
    CameraAddingViewController *vc = [[CameraAddingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)agreeShare:(UIButton *)sender {
    [NOTICECENTER postNotificationName:@"MoveToMain" object:nil];
}

- (IBAction)refuseShare:(UIButton *)sender {
    CameraAddingViewController *vc = [[CameraAddingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}
@end
