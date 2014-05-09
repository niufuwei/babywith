//
//  BaseNavigationController.m
//  BabyAgent
//
//  Created by Fly on 14-3-12.
//  Copyright (c) 2014年 lifei. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseTabBarController.h"


@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

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
}

- (id)initWithRootViewController:(UIViewController *)rootViewController{
    id obj  = [super initWithRootViewController:rootViewController];
    self.delegate = self;
    [self dropShadowWithOpacity:0.4];
    return obj;
    
    
}

- (void) dropShadowWithOpacity:(float)opacity {
    if (opacity == 0) {
        self.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
        self.navigationBar.layer.shadowOpacity = opacity;
    }else{
        self.navigationBar.layer.masksToBounds = NO;
        self.navigationBar.layer.shadowOffset = CGSizeMake(1, 1);
        self.navigationBar.layer.shadowOpacity = opacity;
        self.navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.navigationBar.bounds].CGPath;
    }
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (nil == navigationController.viewControllers) {
        return;
    }
    //[viewController baseViewWillAppear:NO];
    UITabBarController* tabBarController = viewController.tabBarController;
    if (tabBarController && [tabBarController isKindOfClass:[BaseTabBarController class]]) {
        BaseTabBarController* baseTabBarController = (BaseTabBarController*)tabBarController;
        if (viewController.hidesBottomBarWhenPushed) {
            baseTabBarController.mSegmentBar.hidden = NO;
        }else{
            baseTabBarController.mSegmentBar.hidden = YES;
        }
    }

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

@end
